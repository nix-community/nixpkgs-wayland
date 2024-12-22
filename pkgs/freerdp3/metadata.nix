rec {
  domain = "github.com";
  owner = "FreeRDP";
  repo = "FreeRDP";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "6111ac458c041e7d21d88910deb2f061317a743f";
  sha256 = "sha256-yOkJ1uT8CwnhsjAR2E9nD2F+FXFm3ZbZFVY4913rVI4=";
  # Can't find SDL2 started in https://github.com/FreeRDP/FreeRDP/pull/10996 probably
  skip = true;
}
