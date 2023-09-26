{pkgs, ...}:
{
  home = {
    username = "simkir";
    homeDirectory = "/home/simkir";
    stateVersion = "22.11";
  };

  dotfiles = {
    desktop = {
      enable = true;
      dropbox.enable = false;
      i3.enable = true;
      laptop = false;
      fontSize = 14.0;
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
        zoom = false;
        factorio = false;
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
      "ideavimrc"
    ];
    vimDevPlugins = false;
  };

  home.packages = with pkgs; [
    isync
    wally-cli
    tree
    gollum
    vlc
    glab
    lua-language-server
  ];

  programs = {
    git = {
      userEmail = "simen.kirkvik@tromso.serit.no";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
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
