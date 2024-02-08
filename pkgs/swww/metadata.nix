rec {
  owner = "Horus645";
  repo = "swww";
  repo_git = "https://github.com/${owner}/${repo}";
  branch = "main";
  rev = "a4c5bdbf08f6ff1839aa76f162f540b822cabca3";
  sha256 = "sha256-huJnElxtHGmNd2I3zeDClPgfhfFPtb2y99FzR9i9JPc=";
  # error: failed to select a version for the requirement `utils = "^0.8"`
  # candidate versions found which didn't match: 0.8.2-master
  # https://github.com/LGFae/swww/commit/a4c5bdbf08f6ff1839aa76f162f540b822cabca3
  # https://github.com/LGFae/swww/commit/a69934937b81dba41533c473f9ce55a4fc41fb31
  # :/
  skip = true;
}
