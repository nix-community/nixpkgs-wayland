rec {
  type = "gitsourcehut";
  domain = "git.sr.ht";
  owner = "~leon_plickat";
  repo = "wayprompt";
  repo_git = "https://${domain}/${owner}/${repo}";
  branch = "master";
  rev = "a36891ed77b68a4c317361a622c9928be4b9bdbc";
  sha256 = "sha256-tdXW40SLSDGrHxOvHz3cY7VXLmbcQUR+Dmq//bw4V7I=";
  fetchSubmodules = true;
}
