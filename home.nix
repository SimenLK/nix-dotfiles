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
      i3.enable = true;
      hyprland.enable = false;
      dropbox.enable = false;
      fontSize = 13.0;
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
