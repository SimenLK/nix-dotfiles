self: super:
{
  glab-latest = super.glab.overrideAttrs (attrs: rec {
    pname = "glab";
    version = "1.35.0";

    src = super.fetchFromGitLab {
      owner = "gitlab-org";
      repo = "cli";
      rev = "${version}";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  });
}
