rec {
  domain = "gitlab.freedesktop.org";
  owner = "wlroots";
  repo = "wlroots";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "40dde59475bef1eaa7ac70786b700fb3549bb366";
  sha256 = "sha256-NBNKfc5MpFGY/Pph0cXlpGKAXPnz7r5ImWZV9UwvXvA=";
  skip = true; #        > Dependency wayland-server found: NO found 1.21.0 but need: '>=1.22'
  # depends on https://github.com/NixOS/nixpkgs/pull/226283
}
