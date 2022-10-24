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
      laptop = false;
    };
    packages = {
      devel = {
        enable = true;
        cpp = true;
        nix = true;
        db = true;
        dotnet = true;
        node = false;
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
        media = true;
        chat = true;
        graphics = true;
        wavebox = false;
        zoom = true;
        factorio = false;
        tex = true;
      };
      kubernetes = true;
      cloud = true;
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
    vimDevPlugins = true;
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
      omikron-r = {
        user = "simenlk";
        hostname = "omikron.kirkvik.no";
      };
      zelda = {
        user = "simen";
        hostname = "zelda.itpartner.intern";
      };
      uvcluster = {
        user = "ski027";
        hostname = "uvcluster.cs.uit.no";
      };
      uit = {
        user = "simen";
        hostname = "kirkvik.td.org.uit.no";
      };
      ekman = {
        user = "simenlk";
        hostname = "10.255.242.2";
      };

      "10.1.*" = {
        extraOptions = {
          "StrictHostKeyChecking" = "no";
          "UserKnownHostsFile" = "/dev/null";
        };
      };
    };
  };

  imports = [ ./modules ];
}
