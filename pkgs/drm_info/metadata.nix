rec {
  # pin until libdrm 2.4.113 is in master
  # https://nixpk.gs/pr-tracker.html?pr=191247
  skip = true;
  domain = "gitlab.freedesktop.org";
  owner = "emersion";
  repo = "drm_info";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "5af85df6a7cd98a56cf2df8543bed503fc5c8591";
  sha256 = "sha256-m2WnnUUNVMCM/YPQVjbqBU4p5XbK7G7nZyTGlLGL2RE=";
}
