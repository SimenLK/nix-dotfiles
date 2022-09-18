self: super:
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.2.3";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0bdbb0g284fs9ldlvdv4l572b89rm9axibmsyw74lmyidxhziprg";
      };
  });
}
