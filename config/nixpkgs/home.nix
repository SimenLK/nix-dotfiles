{pkgs, lib, ...}:
{
  dotfiles = {
    desktop = {
      enable = false;
      dropbox.enable = false;
      polybar = {
        interface = "eno1";
        laptop = false;
      };
    };
    packages = {
      devel = {
        enable = true;
        nix = true;
        db = false;
        dotnet = false;
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
    ];
    sshFiles = false;
    vimDevPlugins = false;
  };

  home.packages = with pkgs; [];

  programs = {
    git = {
      userEmail = "simenlundkirkvik@hotmail.com ";
      userName = "Simen Kirkvik";
    };

    ssh.matchBlocks = {
      uvcluster = {
        user = "ski027";
        hostname = "uvcluster.cs.uit.no";
      };
    };
  };

  imports = [ ./modules ];
}
