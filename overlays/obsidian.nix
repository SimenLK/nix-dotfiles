self: super:
let
  version = "1.5.3";
in
{
  obsidian = super.obsidian.overrideAttrs (attrs: {
    src = super.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
      hash = "sha256-F7nqWOeBGGSmSVNTpcx3lHRejSjNeM2BBqS9tsasTvg=";
    };
  });
}
