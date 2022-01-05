{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = true;
      dropbox.enable = false;
      polybar = {
        interface = "enp0s31f6";
        laptop = true;
      };
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = false;
        dotnet = true;
        node = true;
        rust = true;
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
    vlc
    openfortivpn
  ];

  programs = {
    git = {
      userEmail = "simen@kirkvik.no";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
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
