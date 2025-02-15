#!/usr/bin/env nu

let system = "x86_64-linux";
let forceCheck = false; # use for development to re-update all pkgs

$env.CACHIX_CACHE = (
  if "CACHIX_CACHE" in $env { $env.CACHIX_CACHE }
  else "nixpkgs-wayland"
)

$env.CACHIX_SIGNING_KEY = (
  if "CACHIX_SIGNING_KEY_NIXPKGS_WAYLAND" in $env { $env.CACHIX_SIGNING_KEY_NIXPKGS_WAYLAND }
  else "null"
)

def getBadHash [ attrName: string ] {
  let val = ((do -i { ^nix build --no-link $attrName }| complete)
      | get stderr
      | split row "\n"
      | where ($it | str contains "got:")
      | str replace --regex '\s+got:(.*)(sha256-.*)' '$2'
      | get 0
  )
  $val
}

def replaceHash [ packageName: string, position: string, hashName: string, oldHash: string ] {
  let fakeSha256 = "0000000000000000000000000000000000000000000000000000";

  do -c { ^sd -s $"($oldHash)" $"($fakeSha256)" $"($position)" }
  let newHash = (getBadHash $".#($packageName)")
  do -c { ^sd -s $"($fakeSha256)" $"($newHash)" $"($position)" }

  print -e {packageName: $packageName, hashName: $hashName, oldHash: $oldHash, newHash: $newHash}
}

def updatePkg [packageName: string] {
  let position = $"pkgs/($packageName)/metadata.nix"
  let verinfo = (^nix eval --json -f $position | str trim | from json)

  let skip = (("skip" in ($verinfo | transpose | get column0)) and $verinfo.skip)
  if $skip {
    print -e $"(ansi light_yellow) update ($packageName) - (ansi light_cyan_underline)skipped(ansi reset)"
  } else {
    # Try update rev
    let newrev = (
      if ("repo_git" in ($verinfo | transpose | get column0)) {
        (do -c {
          ^git ls-remote $verinfo.repo_git $"refs/heads/($verinfo.branch)"
        } | complete | get stdout | str trim | str replace --regex '(\s+)(.*)$' "")
      } else if ( "repo_hg" in ($verinfo | transpose | get column0) ) {
        (do -c {
          ^hg identify $verinfo.repo_hg -r $verinfo.branch
        } | complete | get stdout | str trim)
      } else {
        error make { msg: "unknown repo type" }
      }
    )

    let shouldUpdate = (if ($forceCheck) {
      print -e $"(ansi light_yellow) update ($packageName) - (ansi light_yellow_underline)forced(ansi reset)"
      true
    } else if ($newrev != $verinfo.rev) {
      print -e $"(ansi light_yellow) update ($packageName) - (ansi light_yellow_underline)update to ($newrev)(ansi reset)"
      true
    } else {
      print -e $"(ansi dark_gray) update ($packageName) - noop(ansi reset)"
      false
    })

    if ($shouldUpdate) {
      do -c { ^sd -s $"($verinfo.rev)" $"($newrev)" $"($position)" }
      print -e {packageName: $packageName, oldrev: $verinfo.rev, newrev: $newrev}

      replaceHash $packageName $position "sha256" $verinfo.sha256
      if "vendorSha256" in ($verinfo | transpose | get column0) {
        replaceHash $packageName $position "vendorSha256" $verinfo.vendorSha256
      }

      do -c {
        ^git commit $position -m $"auto-update: ($packageName): ($verinfo.rev) => ($newrev)"
      } | complete
    }

    null
  } # end !skip
}

def updatePkgs [] {
  let pkgs = (^nix eval --json $".#packages.($system)" --apply 'x: builtins.attrNames x' | str trim | from json)
  let pkgs = ($pkgs | where ($it != "default"))
  $pkgs | each { |packageName|
    updatePkg $packageName
  } # end each-pkg loop
}

def "main rereadme" [] {
  let color = "yellow"
  let packageNames = (nix eval --json $".#packages.($system)" --apply 'x: builtins.attrNames x' | str trim | from json)
  let pkgList = ($packageNames | where ($it != "default"))
  let delimStart = "<!--pkgs-start-->"
  let delimEnd = "<!--pkgs-end-->"
  let pkgrows = ($pkgList | each { |packageName|
    let meta = (do -c {
      nix eval --json $".#packages.($system).($packageName).meta" | str trim | from json
    })
    let home = (if "homepage" in ($meta | transpose | get column0) {
      $meta.homepage
    } else { "__missing__" })
    ($"| [($packageName)]\(($home)\) | ($meta.description) |")
  })
  let rows = [
    $delimStart
    "| Package | Description |"
    "| --- | --- |"
    $pkgrows
    $delimEnd
  ]
  let tableText = ($rows | flatten | str join "\n")

  let regexString = ([ '(?s)(.*)' $delimStart '(.*)' $delimEnd '(.*)' ] | str join '')
  let replaceText = $"\$1($tableText)\$3"
  ^rg --multiline $regexString "README.md" --replace $replaceText | save --raw README2.md
  mv -f README2.md README.md

  do -i { ^git commit -m "auto-update: updated readme" "./README.md" }
}

def flakeAdvance [] {
  ^nix flake update --recreate-lock-file --commit-lock-file
}

def gitPush [] {
  print -e ":: git push origin HEAD"
  ^git push origin HEAD
}

def "main build" [] {
  print -e ":: nix build bundle (cachix)"
  ^nix build --keep-going --print-out-paths '.#bundle.x86_64-linux' | cachix push $env.CACHIX_CACHE

  print -e ":: nix build devshell-inputDrv (cachix)"
  ^nix build --keep-going --print-out-paths $"devShells.($system).default.inputDerivation" | cachix push $env.CACHIX_CACHE
}

def "main advance" [] {
  flakeAdvance
  main build
  gitPush
}

def "main update" [packageName?: string] {
  print -e ":: update"
  if $packageName == null {
    flakeAdvance
    updatePkgs
    main build
    main rereadme
    gitPush
  } else {
    updatePkg $packageName
  }
}

def main [] {
  print -e "commands: [advance, update, build]"
}
