self: super:
{
  discord = super.discord.overrideAttrs (attrs: rec {
    # https://discord.com/api/download?platform=linux&format=tar.gz
    # https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz
    version = "0.0.41";
    name = "discord-${version}";

    src = super.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "sha256-yzCOlYIDvbhJRbiqf5NC2iBT2ezlJP81O/wtkWIEp+U=";
    };
  });
}
