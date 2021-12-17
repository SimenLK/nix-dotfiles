{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = true;
      dropbox.enable = false;
      polybar = {
        interface = "eno2";
        laptop = false;
      };
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
        graphics = false;
        wavebox = false;
        zoom = true;
        tex = false;
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
    sshFiles = false;
    vimDevPlugins = true;
  };

  home.packages = with pkgs; [
    isync
    wally-cli
    tree
    jetbrains.rider
  ];

  programs = {
    git = {
      userEmail = "simen.kirkvik@tromso.serit.no";
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
