self: super:
let
  version = "0.31.7";
in
{
  k9s = super.k9s.overrideAttrs (attrs: {
    src = super.fetchFromGitHub {
      owner = "derailed";
      repo = "k9s";
      rev = "v${version}";
      sha256 = "sha256-DRxS2zhDLAC1pfsHiOEU9Xi7DhKcPwzdI3yw5JbbT18=";
    };
  });
}
