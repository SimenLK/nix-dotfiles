self: super:
let
  pname = "dotnet-sdk";
  platform = "linux";
  suffix = "x64";
in
{
  dotnet-sdk_7 = super.dotnetCorePackages.sdk_6_0.overrideAttrs (attrs: rec {
    version = "7.0.100";
    src = super.fetchurl {
      url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}-${suffix}.tar.gz";
      sha512 = "sha512:Ci50SGNXo+4Wq7VR7Ngog2+Q2HRNbitrg1VjlchyCQ2eUWb5Ko0FAzEzPQfREsSyfocQC6GvhsrIo38a7pUweA==";
    };
  });
}

