self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnet-sdk_6 = super.dotnetCorePackages.sdk_6_0.overrideAttrs (attrs: rec {
    version = "6.0.101";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "sha512:0i06qhzpg4lq1fdpq4d47ml42zicpq34bgb30d638f7wxf8hj9hrx0l5axxh2vnmcqlj9via18wp8d9kx17f1h30z4xaqm2a0spmkc1";
    };
  });
}

