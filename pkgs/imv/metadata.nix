rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~exec64";
  repo = "imv";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "885e17397ac503de84723d4f0b1c97b1258548ab";
  sha256 = "sha256-LLEEbriHzZhAOQivqHqdr6g7lh4uj++ytlme8AfRjf4=";
  skip = true; # meson.build:1:0: ERROR: Unknown options: "libjxl"
}
