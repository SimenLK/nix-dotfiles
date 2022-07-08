self: super:
{
  rider = super.jetbrains.rider.overrideAttrs (attrs: rec {
      version = "2022.1.2";
      name = "rider-${version}";

      src = super.fetchurl {
        url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
        sha256 = "0hdphwlihykfdm2sx2157wapl4pvi57qalnsvxmrh4xh7mfya4s5";
      };
  });
}
