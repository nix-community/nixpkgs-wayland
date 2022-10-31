#!/usr/bin/env nu

let system = "x86_64-linux"
let packageNames = (nix eval --json $".#packages.($system)" --apply 'x: builtins.attrNames x' | str trim | from json)
let fakeSha256 = "0000000000000000000000000000000000000000000000000000";
let forceCheck = false; # use for development to re-update all pkgs

def header [ color: string text: string spacer=" ": string ] {
  let text = $"($text) "
  let header = $" ($text | str rpad -c $spacer -l 80)"
  print -e $"(ansi $color)($header)(ansi reset)"
}

def getBadHash [ attrName: string ] {
  let val = ((do -i { ^nix build --no-link $attrName }| complete)
      | get stderr
      | split row "\n"
      | where ($it | str contains "got:")
      | str replace '\s+got:(.*)(sha256-.*)' '$2'
      | get 0
  )
  $val
}

def main [ packageName="all": string ] {
  let pkgList = if $packageName != "all" { [$packageName] } else {$packageNames}
  
  let pkgList = ($pkgList | where ($it != "default"))
  
  $pkgList | each { |packageName|
    header light_yellow_reverse $"update ($packageName)"
    let position = $"($packageName)/metadata.nix"
    let meta = (do -c {
      nix eval --json -f $position | str trim | from json
    })
    let verinfo = $meta;
  
    # Try update rev
    let newrev = (
      if "repo_git" in ($verinfo | transpose | get column0) {
        (do -c {
          ^git ls-remote $verinfo.repo_git $"refs/heads/($verinfo.branch)"
        } | complete | get stdout | str trim | str replace '(\s+)(.*)$' "")
      } else if "repo_hg" in ($verinfo | transpose | get column0) {
        (do -c {
          ^hg identify $verinfo.repo_hg -r $verinfo.branch
        } | complete | get stdout | str trim)
      } else {
        error make { msg: "unknown repo type" }
      }
    )
    
    let skipPkg = if (("skip" in ($verinfo | transpose | get column0)) && $verinfo.skip=="true") {true} else { false }
    let shouldUpdate = ( (not $skipPkg) && ($newrev != $verinfo.rev) )
    if ($forceCheck || $shouldUpdate) {
      print -e {packageName: $packageName, oldrev: $verinfo.rev, newrev: $newrev}
  
      do -c { ^sd -s $"($verinfo.rev)" $"($newrev)" $"($position)" }
      do -c { ^sd -s $"($verinfo.sha256)" $"($fakeSha256)" $"($position)" }
      let newSha256 = (getBadHash $".#($packageName)")
      do -c { ^sd -s $"($fakeSha256)" $"($newSha256)" $"($position)" }
      print -e {packageName: $packageName, oldSha256: $verinfo.sha256, newSha256: $newSha256}
      
      if "vendorSha256" in ($verinfo | transpose | get column0) {
        do -c { ^sd -s $"($verinfo.vendorSha256)" $"($fakeSha256)" $"($position)" }
        let newVendorSha256 = (getBadHash $".#($packageName)")
        print -e {packageName: $packageName, oldVendorSha256: $verinfo.vendorSha256, newVendorSha256: $newVendorSha256}
        do -c { ^sd -s $"($fakeSha256)" $"($newVendorSha256)" $"($position)" }
      }
      if "cargoSha256" in ($verinfo | transpose | get column0) {
        do -c { ^sd -s $"($verinfo.cargoSha256)" $"($fakeSha256)" $"($position)" }
        let newCargoSha256 = (getBadHash $".#($packageName)")
        print -e {packageName: $packageName, oldCargoSha256: $verinfo.cargoSha256, newCargoSha256: $newCargoSha256}
        do -c { ^sd -s $"($fakeSha256)" $"($newCargoSha256)" $"($position)" }
      }
      
      do -c {
        ^git commit --allow-empty $position -m $"auto-update: ($packageName): ($verinfo.rev) => ($newrev)"
      }
    }
  
    null
  }
}
