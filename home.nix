{ pkgs, ... }:
{
  home = {
    username = "simkir";
    homeDirectory = "/home/simkir";
    stateVersion = "22.11";
  };

  dotfiles = {
    desktop = {
      enable = false;
      dropbox.enable = false;
      i3.enable = true;
      laptop = false;
      fontSize = 15.0;
    };
    packages = {
      devel = {
        enable = true;
        android = false;
        cpp = false;
        nix = true;
        db = false;
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
        enable = false;
        gnome = true;
        x11 = true;
        media = true;
        chat = true;
        graphics = true;
        wavebox = false;
        zoom = false;
        factorio = false;
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
      "ideavimrc"
    ];
    vimDevPlugins = false;
  };

  home.packages = with pkgs; [
    isync
    wally-cli
    tree
    glab
    lua-language-server
    marksman
    yubikey-manager-qt
    nodePackages.vscode-langservers-extracted
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
