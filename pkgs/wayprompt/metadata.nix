rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "ff0004a7a2a91ef841162369b2ed2e25a2dff9ce";
  sha256 = "sha256-wXgCU3FM/D5348aIAurj3raiCThPFGUDoHPXImRYxM8=";
  fetchSubmodules = true;
}
