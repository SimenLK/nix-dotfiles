{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop.sway;

  configuration = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      alacritty
      dmenu
    ];
  };
in {
  options.dotfiles.desktop.sway = {
    enable = mkEnableOption "Enable Wayland Sway";
  };

  config = mkIf cfg.enable configuration;
}

