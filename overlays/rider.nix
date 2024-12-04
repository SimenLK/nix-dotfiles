self: super:
let
  jetbrainsNix = "/nix/var/nix/profiles/per-user/root/channels/nixos/pkgs/applications/editors/jetbrains";
  jetbrains = super.callPackage jetbrainsNix { };

  rider-latest = jetbrains.rider.overrideAttrs (attrs: rec {
    version = "2024.3";
    name = "rider-${version}";

    src = super.fetchurl {
      url = "https://download.jetbrains.com/rider/JetBrains.Rider-${version}.tar.gz";
      sha256 = "sha256-75thwYhRtvPvK/o/4UezSsGRYi9lpB8rU7OmCfm/82A=";
    };

    postInstall = ''
      cd $out/rider

      ls -d $PWD/plugins/cidr-debugger-plugin/bin/lldb/linux/*/lib/python3.8/lib-dynload/* |
      xargs patchelf \
        --replace-needed libssl.so.10 libssl.so \
        --replace-needed libcrypto.so.10 libcrypto.so \
        --replace-needed libcrypt.so.1 libcrypt.so

      for dir in lib/ReSharperHost/linux-*; do
        rm -rf $dir/dotnet
        ln -s ${super.dotnet-sdk_8.unwrapped}/share/dotnet $dir/dotnet
      done
    '';
  });
in
{
  rider = rider-latest;
}
