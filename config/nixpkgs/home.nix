{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = true;
      dropbox.enable = false;
      laptop = true;
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
        zoom = false;
        tex = true;
      };
      kubernetes = true;
      cloud = false;
      geo = true;
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
    vlc
  ];

  programs = {
    git = {
      userEmail = "simen@kirkvik.no";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
      omikron-r = {
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
      ads1-master-0 = {
        user = "root";
        hostname = "10.255.168.199";
      };
    };
  };

  imports = [ ./modules ];
}
