rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "ad00d4500e6d880ab0ba589c200425a730c17a03";
  sha256 = "sha256-zBBdFDSR8NOjZ7CjF60JXey4mnWJ/p6emnrRc1LMJgM=";
  fetchSubmodules = true;
}
