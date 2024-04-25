self: super:
{
  talosctl = super.talosctl.overrideAttrs (attrs: rec {
    version = "1.23.0";

    src = super.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "";
    };
  });
}
