self: super:
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2021.3.4";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0g20wan79qwrm8ml1ns0ma3fcqajjmixzk5sgj0n4dhkzszkq4qj";
      };
  });
}
