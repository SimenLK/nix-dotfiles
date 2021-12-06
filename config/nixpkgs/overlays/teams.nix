self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.4.00.7556";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "0yak3jxh0gdn57wjss0s7sdjssf1b70j0klrcpv66bizqvw1xl7b";
      };
  });
}
