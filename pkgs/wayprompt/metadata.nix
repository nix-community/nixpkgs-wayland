rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "10be4e07d6442c3f25127c7189fb13db7923d6c9";
  sha256 = "sha256-TSFdDepU1mmjcBrQ87E0qm9iIsEE2nImBH0jS+EyDfg=";
  fetchSubmodules = true;
}
