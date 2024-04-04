self: super:
let
  arch = "amd64";
  version = "6.7.2";
in
{
  ferdium-old = super.ferdium.overrideAttrs (attrs: {
    src = super.fetchurl {
      url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
      hash = "sha256-RH8iHqJ0Nd3wkXmv/ZGX5JeWtxyJtVLVb0tz6tnkjrw=";
    };
  });
}
