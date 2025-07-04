{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.desktop;

  sources = import ../nix;
  stylix = import sources.stylix;

  configuration = {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-gray-light.yaml";
    };
  };
in
{
  options.dotfiles.desktop = {
    stylix = {
      enable = lib.mkEnableOption "Enable stylix";
    };
  };

  config = lib.mkIf cfg.stylix.enable configuration;

  imports = [
    stylix.homeModules.stylix
  ];
}
