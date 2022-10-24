self: super:
{
  discord = super.discord.overrideAttrs (attrs: rec {
    # https://discord.com/api/download?platform=linux&format=tar.gz
    # https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz
    version = "0.0.18";
    name = "discord-${version}";

    src = super.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "1hl01rf3l6kblx5v7rwnwms30iz8zw6dwlkjsx2f1iipljgkh5q4";
    };
  });
}
