rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "ac3412155c49349462fe5c0c3308921288bf5bbc";
  sha256 = "sha256-RHrJ3LDR5mirfH1Tna1OHpG1Hm5udyJgvYnJL38mowU=";
  fetchSubmodules = true;
}
