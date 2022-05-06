{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = true;
      dropbox.enable = false;
      i3.enable = true;
      xsessionInitExtra = ''
        xrandr --output DP1 --mode 2560x1440 -r 120
      '';
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = true;
        dotnet = true;
        node = true;
        rust = false;
        haskell = false;
        python = false;
        go = false;
        java = false;
        clojure = false;
      };
      desktop = {
        enable = true;
        gnome = true;
        x11 = true;
        media = false;
        chat = true;
        graphics = true;
        wavebox = false;
        zoom = true;
        tex = true;
      };
      kubernetes = true;
      cloud = true;
      geo = false;
    };
    extraDotfiles = [
      "bcrc"
      "codex"
      "ghci"
      "haskeline"
      "taskrc"
      "mbsyncrc"
      "mailcap"
    ];
    vimDevPlugins = false;
  };

  home.packages = with pkgs; [
    isync
    wally-cli
    tree
    gollum
    vlc
  ];

  programs = {
    git = {
      userEmail = "simen.kirkvik@tromso.serit.no";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
      omikron = {
        user = "simenlk";
        hostname = "omikron.kirkvik.no";
      };
      uvcluster = {
        user = "ski027";
        hostname = "uvcluster.cs.uit.no";
      };
      uit = {
        user = "simen";
        hostname = "kirkvik.td.org.uit.no";
      };
    };
  };

  imports = [ ./modules ];
}
