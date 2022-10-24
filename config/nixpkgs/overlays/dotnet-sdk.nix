self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnet-sdk_6_0_101 = super.dotnetCorePackages.sdk_6_0.overrideAttrs (attrs: rec {
    version = "6.0.101";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "sha512:yiE0VAC8rOra1jJzRfU2ToWAWc/LwXWfBdffdwH+wm8erSl7aSivoB5G22+E5QdwxnMUahC5/3Hkx/e8dvv3CQ==";
    };
  });
}

