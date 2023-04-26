#!/usr/bin/env nu

# TODO: use a flake input for cachixpkgs and re-use?? except that we use this with NIX_PATH
let cachixpkgs = "https://github.com/nixos/nixpkgs/archive/nixos-22.11.tar.gz" # used by nix-shell cachix
# TODO: I think this bug got fixed???
# let nix = "./misc/nix.sh"
let nix = "nix"
let nixopts = [
  "--builders-use-substitutes" "--option" "narinfo-cache-negative-ttl" "0"
  # TODO: files bugs such that we can exclusively use the flake's values??
  "--option" "extra-substituters" "'https://cache.nixos.org https://colemickens.cachix.org https://nixpkgs-wayland.cachix.org https://unmatched.cachix.org https://nix-community.cachix.org'"
  "--option" "extra-trusted-public-keys" "'cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= colemickens.cachix.org-1:bNrJ6FfMREB4bd4BOjEN85Niu8VcPdQe4F4KxVsb/I4= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA= unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs='"
];

def getpref [ b: string ] {
  let pp = $".pref.($b)"
  if $b in $env {
    return ($env | get $b)
  } else if ($pp | path exists) {
    print -e $"getpref: ($b): check ($pp)"
    let builder = (open $".pref.($b)" | str trim)
    return $builder
  } else {
    return "cole@localhost" # TODO this isn't finished for aarch64
  }
}
let-env BUILDER_X86 = (getpref "BUILDER_X86")
let-env BUILDER_A64 = (getpref "BUILDER_A64")

print -e $"BUILDER_X86 = ($env.BUILDER_X86)"
print -e $"BUILDER_A64 = ($env.BUILDER_A64)"

def header [ color: string text: string spacer="▒": string ] {
  let text = $"("" | fill -a r -c $spacer -w 2) ($text) "
  let text = $"($text | fill -a l -c $spacer -w 50)"
  print -e $"(ansi $color)($text)(ansi reset)"
}

def evalDrv [ ref: string ] {
  header "light_cyan_reverse" $"eval: ($ref)"
  let res = (^nix-eval-jobs
    --flake $ref
    --check-cache-status
      | from json --objects)
  $res
}

def buildDrvs [ doCache: bool drvs: table ] {
  let builds = [
    # {builder: $env.BUILDER_A64, drvs: ($drvs | where system == "aarch64-linux")}
    {builder: $env.BUILDER_X86, drvs: ($drvs | where system == "x86_64-linux")}
  ]
  for build in $builds {
    buildDrvs__ $doCache $build.builder $build.drvs
  }
}

def printDrvs [ drvs: list ] {
  let im = ($drvs | flatten outputs | each { |it|
    mut r = {}
    $r.drvPath = ($it.drvPath | str replace "/nix/store/" "" )
    $r.out = ($it.out | str replace "/nix/store/" "")
    $r.isCached = $it.isCached
    $r
  })
  print -e $im
}

def buildDrvs__ [ doCache: bool buildHost: string drvs: list ] {
  header "light_blue_reverse" $"build: ($drvs | length) drvs on ($buildHost)]"
  printDrvs $drvs

  if ($drvs | length) == 0 { return; } # TODO_NUSHELL: xxx
  let drvPaths = ($drvs | get "drvPath")
  let drvBuilds = ($drvPaths | each {|i| $"($i)^*"})

  # TODO: try this in a loop a few times, sometimes it fails "too many root paths" <- TODO: File a bug for this
  ^$nix copy $nixopts --no-check-sigs --to $"ssh-ng://($buildHost)" --derivation $drvBuilds

  ^echo $nix build $nixopts --store $"ssh-ng://($buildHost)" -L $drvBuilds
  ^$nix build $nixopts --store $"ssh-ng://($buildHost)" -L $drvBuilds

  if $doCache {
    # do caching here...
    let outs = ($drvs | get outputs | flatten | get out | flatten)
    let outsStr = ($outs | each {|it| $"($it)(char nl)"} | str join)
    header "purple_reverse" $"cache: ($outs | length) paths from ($buildHost)"
    print -e $"CACHING: ($outsStr)"
    (^ssh $buildHost
      ([
        $"printf '%s' '($outsStr)' | env CACHIX_SIGNING_KEY='($env.CACHIX_SIGNING_KEY)' "
        $"nix-shell -I nixpkgs=($cachixpkgs) -p cachix --command 'cachix push ($env.CACHIX_CACHE)'"
      ] | str join ' ')
    )
  }
}

# TODO: we shouldn't need this mostly...
# def "main nixbuild" [ a: string ] {
#   ^nix build $nixopts $a
# }

def downDrvs [ drvs: table target: string ] {
  header "purple_reverse" $"download: ($target): $drvs"
  let builds = ($drvs | get outputs | get out)
  print -e $builds
  ^echo ^ssh $"cole@($target)" (([ "nix" "build" "--no-link" "-j0" $nixopts $builds ] | flatten) | str join ' ')
  ^ssh $"cole@($target)" (([ "nix" "build" "--no-link" "-j0" $nixopts $builds ] | flatten) | str join ' ')
  # if ($env.LAST_EXIT_CODE != 0) {
  #   error make { msg: $"failed to down to ($target)"}
  # }
}

def deployHost [ host: string ] {
  let target = (tailscale ip --4 $host | str trim)
  header light_gray_reverse $"deploy: ($host) -> ($target)"
  let drvs = (evalDrv $"/home/cole/code/nixcfg#toplevels.($host)")
  # NUSHELL BUG:
  let drvs = ($drvs | where { |it| $it.isCached == false or $it.isCached == true})
  buildDrvs true $drvs
  downDrvs $drvs $target
  let topout = ($drvs | get "outputs" | flatten | get "out" | flatten | first)
  let cs = (do -c { ^ssh $"cole@($target)" $"readlink -f /run/current-system" } | str trim)
  if ($cs == $topout) { header light_purple_reverse $"deploy: ($host): already up-to-date"; return }

  header light_purple_reverse $"deploy: ($host): apply and switch"
  ^ssh $"cole@($target)" (([ "sudo" "nix" "build" "--no-link" "-j0" $nixopts "--profile" "/nix/var/nix/profiles/system" $topout ] | flatten) | str join ' ')
  ^ssh $"cole@($target)" $"sudo '($topout)/bin/switch-to-configuration' switch"
}
