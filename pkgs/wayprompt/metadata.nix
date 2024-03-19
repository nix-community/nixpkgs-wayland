rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "760edb6f697c14736ccf0a6832200355bfcc59b8";
  sha256 = "sha256-h5973mEsI6as3KXrgN/hLcCA58Ylx5BHgq8NVYXVHGw=";
  fetchSubmodules = true;
}
