self: super:
{
  talosctl = super.talosctl.overrideAttrs (attrs: rec {
    version = "1.6.7";

    src = super.fetchFromGitHub {
      owner = "siderolabs";
      repo = "talos";
      rev = "v${version}";
      sha256 = "sha256-94oQe0wmrDU9MDWA1IdHDXu6ECtzQFHPh6dZhOvidUg=";
    };
  });
}
