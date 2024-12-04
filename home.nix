{ pkgs, ... }:
{
  imports = [ ./modules ];

  home = {
    username = "simkir";
    homeDirectory = "/home/simkir";
    stateVersion = "23.11";
  };

  dotfiles = {
    desktop = {
      enable = true;
      laptop = false;
      i3.enable = false;
      hyprland = {
        enable = true;
        monitors = [
          "HDMI-A-3,    highres,      0x0,  1.0"
          "DP-2,      preferred, auto-left, 1.0"
        ];
      };
      dropbox.enable = false;
      fontSize = 14.0;
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = true;
        dotnet = true;
      };
      desktop = {
        enable = true;
        chat = false;
        graphics = false;
        IDE = true;
        zoom = false;
      };
      kubernetes = true;
      cloud = true;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
      "mbsyncrc"
      "mailcap"
      "ideavimrc"
    ];
  };

  home.packages = with pkgs; [
  ];

  programs = {
    git = {
      userEmail = "simen.kirkvik@tromso.serit.no";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
    };
  };
}
