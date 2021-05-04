self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnetCorePackages.sdk_5_0 = super.dotnetCorePackages.sdk_3_1.overrideAttrs (attrs: rec {
    version = "5.0.202";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "27gp0ndypymmr1pigx2sd1fzkwq7ks06a0ypi0a2y71zrn1hq78ipa5xd059fln4w4kbvz7jaqc8ylfap99iin7rwsjia67msyjsidz";
    };
  });

# workaround for a bug in nixpkgs
  dotnetCorePackages.aspnetcore_2_1 = {};
  dotnetCorePackages.netcore_2_1 = {};
  dotnetCorePackages.sdk_2_1 = {};
}

