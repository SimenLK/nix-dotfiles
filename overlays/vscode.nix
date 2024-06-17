self: super:
let
  plat = "linux-x64";
  archive_fmt = "tar.gz";
in
{
  vscode = super.vscode.overrideAttrs (attrs: rec {
      version = "1.63.2";
      name = "vscode-${version}";

      src = super.fetchurl {
        name = "VSCode_${version}_${plat}.${archive_fmt}";
        url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
        sha256 = "1bglf1a8b5whv9pk811fdnx0mvfcfasjxbik73p67msp4yy68lm4";
      };

      buildInputs = attrs.buildInputs ++ [ super.xorg.libxshmfence ];
  });
}
