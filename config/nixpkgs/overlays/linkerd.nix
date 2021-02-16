self: super:
let
  version = "stable-2.9.3";
  srcfile="linkerd2-cli-${version}-linux-amd64";
in {
  linkerd = super.stdenv.mkDerivation {
      name = "linkerd-${version}";

      src = super.fetchurl {
        url="https://github.com/linkerd/linkerd2/releases/download/${version}/${srcfile}";
        sha256 = "1z5irf5iy6iy0xma754c85hcfwsaa6y5hbgbasadnkg5fs9xgrm0";
      };

      buildCommand = ''
        . $stdenv/setup

        mkdir -p $out/bin
        cp $src $out/bin/${srcfile}
        chmod 755 $out/bin/${srcfile}
        ln -s $out/bin/${srcfile} $out/bin/linkerd
      '';

      buildInputs = with super; [ curl ];
    };
}
