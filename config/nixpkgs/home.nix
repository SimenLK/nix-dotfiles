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

  xsession.initExtra = ''
    xsetroot -solid '#888888'
    xsetroot -cursor_name left_ptr
    ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
    systemctl --user start gvfs-udisks2-volume-monitor.service
    xset s 1800
    xset +dpms
    xset dpms 1800 2400 3600
    xmodmap $HOME/.dotfiles/Xmodmap
    if xrandr | grep -q "DP-2 connected 1920"; then
      xrandr --output DP-2 --rotate left
    elif xrandr | grep -q "DP-2 connected 2560"; then
      xrandr --output eDP-1 --off
    fi
  '';

  imports = [ ./modules ];
}
