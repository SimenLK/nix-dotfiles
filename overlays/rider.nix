self: super:
let
  jetbrainsNix = "/nix/var/nix/profiles/per-user/root/channels/nixos/pkgs/applications/editors/jetbrains";
  jetbrains = super.callPackage jetbrainsNix { };

  rider-latest = jetbrains.rider.overrideAttrs (attrs: rec {
    version = "2024.3.6";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-H5258/kMcf5Hbj4XrHi+n8yYLj8BfFmPYxtc1gDm2kM=";
    };
  });
in
{
  rider = rider-latest;
}
