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
      sha512 = "0w9hgfrbfiiz63bvwqqlkz9nwcm7lagxq6pl10ik7f03yg65mqlcq4y0f9kih7xasaw3fvx1s1rvqjwsm04klkkar08fj8q6vr5kv81";
    };
  });

# workaround for a bug in nixpkgs
  dotnetCorePackages.aspnetcore_2_1 = {};
  dotnetCorePackages.netcore_2_1 = {};
  dotnetCorePackages.sdk_2_1 = {};
}

