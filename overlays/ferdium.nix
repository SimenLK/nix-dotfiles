self: super:
let
  arch = "amd64";
  version = "6.7.5";
in
{
  ferdium-old = super.ferdium.overrideAttrs (attrs: {
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-PhWYHGRSX9wpPAlfA/UN2nmr++IWbeeEadgU6WAXaTQ=";
    };
  });
}
