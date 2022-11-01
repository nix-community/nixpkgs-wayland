#!/usr/bin/env nu

let system = "x86_64-linux";
let-env CACHIX_CACHE = (
  if "CACHIX_CACHE" in ($env | transpose | get column0) { $env.CACHIX_CACHE }
  else "nixpkgs-wayland"
)

def buildDrv [ drvRef: string ] {
  print -e $"(ansi yellow) :: eval ($drvRef)(ansi reset)"
  let evalJobs = (
    ^nix-eval-jobs
      --flake $".#($drvRef)"
      --check-cache-status
        | each { |it| ( $it | from json ) }
  )
  print -e $evalJobs
  
  print -e $"(ansi blue) :: build ($drvRef)(ansi reset)"
  print -e ($evalJobs
    | where isCached == false
    | select name drvPath outputs)

  $evalJobs
    | where isCached == false
    | each { |drv|
      do -c { ^nix build $drv.drvPath }
      null
    }

  print -e $"(ansi green) :: cache ($drvRef)(ansi reset)"
  let pushPaths = ($evalJobs | each { |drv|
    $drv.outputs | each { |outPath|
      if ($outPath.out | path exists) {
        $outPath.out
      }
    }
  })
  
  # collect paths to push
  # call cachix push once
  let arg = ($pushPaths | each {|it| $"($it)(char nl)"} | str collect)
  $arg | ^cachix push $env.CACHIX_CACHE | complete
}

def "main rereadme" [] {
  let packageNames = (nix eval --json $".#packages.($system)" --apply 'x: builtins.attrNames x' | str trim | from json)
  let pkgList = ($packageNames | where ($it != "default"))
  let rows = [
    "| Package | Description |"
    "| --- | --- |"
  ]
  let pkgrows = ($pkgList | each { |packageName|
    print -e $packageName
    let meta = (do -c {
      nix eval --json $".#packages.($system).($packageName).meta" | str trim | from json
    })
    let home = (if "homepage" in ($meta | transpose | get column0) {
      $meta.homepage
    } else { "__missing__" })
    ($"| [($packageName)]\(($home)\) | ($meta.description) |")
  })
  let tableText = ([ $rows $pkgrows ] | flatten | str join "\n")
  
  print -e $tableText
  
  ^rg --multiline '(?s)(.*)<!--pkgs-->(.*)<!--end-pkgs-->(.*)' "README.md" --replace $"\$1($tableText)\$3" | save --raw README2.md
  mv README2.md README.md

  (do -c {
    ^git commit -m "auto-update: updated readme" "./README.md"
  })
}

def "main build" [] {
  buildDrv $"packages.($system)"
}

def "main advance" [] {
  ^nix flake lock --recreate-lock-file --commit-lock-file
  (do -c {
    main build
  })
  ^git push origin HEAD
}

def "main update" [] {
  (do -c {
    do {
      cd pkgs
      ./pkgs-update.nu
    }
    main build
    main rereadme
    ^git push origin HEAD
  })
}

def main [] {
  print -e "commands: [advance, update, build]"
}
