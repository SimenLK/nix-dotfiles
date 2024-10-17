self: super:
let
  version = "1.6.7";
in
{
  obsidian = super.obsidian.overrideAttrs (attrs: {
    src = super.fetchurl {
      url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
      hash = "sha256-ok1fedN8+OXBisFpVXbKRW2OhE4o9MC9lJmtMMST6V8=";
    };
  });
}
