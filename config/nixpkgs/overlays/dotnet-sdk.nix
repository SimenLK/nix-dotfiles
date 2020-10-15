self: super:
let
  dotnet-sdk-2 =
      super.dotnet-sdk.overrideAttrs (attrs: rec {
      version = "2.2.402";
      name = "dotnet-sdk-${version}";
      src = super.fetchurl {
        url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/dotnet-sdk-${version}-linux-x64.tar.gz";
        sha256 = "16jp2xwz2dkmampjv7kixn9v6kjcfbbjww5xb2vdwvcwwkkf3bsd";
      };
    });

  dotnet-sdk-3 =
    with self.pkgs;
    let
      version = "3.1.300";
      netCoreVersion = "3.1.4";
      rpath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc libunwind libuuid icu openssl zlib curl libkrb5
      ];

      dotnet-sdk =
        stdenv.mkDerivation rec {
          inherit version netCoreVersion;
          pname = "dotnet-sdk";

          src = fetchurl {
            url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-linux-x64.tar.gz";
            sha512 = "3vxhwqv78z8s9pzq19gn0d35g4340m3zvnv70pglk1cgnk02k9hbh51dsf2j6bgcmdxay8q2719ll7baj1sc7n9287vzkqbk8gs6vbn";
          };

          sourceRoot = ".";

          dontBuild = true;

          installPhase = ''
            runHook preInstall
            mkdir -p $out
            cp -r ./ $out
            runHook postInstall
          '';

          dontPatchelf = true;

          # the dotnet executable cannot be wrapped, must use patchelf.
          # autoPatchelf isn't able to be used as libicu* and other's aren't
          # listed under typical binary section
          postFixup = ''
            for i in \
              dotnet \
              sdk/3.0.100/AppHostTemplate/apphost \
              packs/Microsoft.NETCore.App.Host.linux-x64/3.0.0/runtimes/linux-x64/native/apphost
            do
              patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/$i
              patchelf --set-rpath "${rpath}" $out/$i
            done
            find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
          '';

          doInstallCheck = true;
          installCheckPhase = ''
            $out/dotnet --info
          '';

          meta = with stdenv.lib; {
            homepage = https://dotnet.github.io/;
            description = ".NET Core SDK ${version} with .NET Core ${netCoreVersion}";
            platforms = [ "x86_64-linux" ];
            maintainers = with maintainers; [ "jonringer" ];
            license = licenses.mit;
          };
        };

      dotnet-wrapper =
        pkgs.writeScriptBin "dotnet" ''
            #!${pkgs.bash}/bin/bash

            d=/tmp/dotnet-sdk/${version}

            if [ ! -d $d ]; then
              echo "Copying SDK to temporary DOTNET_ROOT=$d"
              mkdir -p $d

              cp -r ${dotnet-sdk}/* $d
              chmod -R u+w $d
            fi

            export DOTNET_ROOT=$d
            exec $d/dotnet $@
        '';
    in
      dotnet-wrapper;
in
{
  # dotnet-sdk-2 = dotnet-sdk-2;
  dotnet-sdk = dotnet-sdk-3;
}
