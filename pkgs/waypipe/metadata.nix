rec {
  type = "gitlab";
  domain = "gitlab.freedesktop.org";
  owner = "mstoeckl";
  repo = "waypipe";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "a04f6e3573f19ec7d7a7ef74b3fd1ee52400a2f7";
  sha256 = "sha256-WuPiXYzOCrkOX7Yf++70IXXQ5f4Sx0GjJsiuCktSz5E=";
  # Porting to rust, let's stay on pre-rust for a while
  # 2024-12-04
  # https://gitlab.freedesktop.org/mstoeckl/waypipe/-/issues/107
  skip = true;
}
