self: super:
{
  go = super.go.overrideAttrs (attrs: rec {
    version = "1.24.2";

    src = super.fetchurl {
      url = "https://go.dev/dl/go${version}.src.tar.gz";
      hash = "sha256-ncd/+twW2DehvzLZnGJMtN8GR87nsRnt2eexvMBfLgA=";
    };
  });
}
