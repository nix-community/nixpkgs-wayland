rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~emersion";
  repo = "kanshi";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "cec99a56a32b2d7f9eebcc729aa2e16d15150c15";
  sha256 = "sha256-AniC5BWtj2QzCc2dwLPg+QNQUsne45No7uF2oIJiTOs=";
  skip = true; # skip until https://git.sr.ht/~emersion/scfg is in nixpkgs
}
