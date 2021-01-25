{ pkgs, options, ... }:
{
  programs = {
    browserpass.enable = true;
    feh.enable = true;
    firefox.enable = true;
  };

  home.file = {
    xmobarrc = {
      source = ~/.xmonad/xmobarrc;
      target = ".xmobarrc";
      recursive = false;
    };
    xmodmap = {
      source = ~/.dotfiles/Xmodmap;
      target = ".Xmodmap";
      recursive = false;
    };
  };

  systemd.user.services.dropbox =
    if options.desktop.dropbox then
      {
        Unit = {
          Description = "Dropbox";
        };
        Service = {
          ExecStart = "${pkgs.dropbox}/bin/dropbox";
          Restart = "on-failure";
          RestartSec = "10s";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      }
    else {};

  systemd.user.services.pa-applet = {
      Unit = {
        Description = "PulseAudio volume applet";
      };
      Service = {
        ExecStart = "${pkgs.pa_applet}/bin/pa-applet";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
  };

  services = {
    polybar = import ./polybar.nix { inherit pkgs options; };

    flameshot.enable =  true;

    screen-locker = {
      enable = true;
      inactiveInterval = 45;
      lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 000000";
    };

    network-manager-applet.enable = true;
    blueman-applet.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 64800; # 18 hours
      defaultCacheTtlSsh = 64800;
      maxCacheTtl = 64800;
      maxCacheTtlSsh = 64800;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
      '';
    };
  };

  gtk = {
    enable = true;
    font.name = "DejaVu Sans 11";
    iconTheme.name = "Ubuntu-mono-dark";
    theme.name = "Adwaita";
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 0; };
  };

  xdg.dataFile = {
    xmonad-desktop = {
      source = ~/.xmonad/Xmonad.desktop;
      target = "applications/Xmonad.desktop";
    };
  };

  xresources.properties = {
    "Xclip.selection" = "clipboard";
    "Xcursor.theme" = "cursor-theme";
    "Xcursor.size" = 16;
  };

  xsession = {
    enable = true;
    initExtra = ''
      xsetroot -solid '#888888'
      xsetroot -cursor_name left_ptr
      ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
      systemctl --user start gvfs-udisks2-volume-monitor.service
      xset s 1800
      xset +dpms
      xset dpms 1800 2400 3600
      xmodmap $HOME/.dotfiles/Xmodmap
      if xrandr | grep -q "DP-2-2 connected"; then
          xrandr --output DP-2-2 --auto --rotate left --right-of DP-2-1
      fi
    '';
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = self: [
        self.yeganesh
        self.xmobar
        pkgs.dmenu
        pkgs.xmonad-log
        self.string-conversions
      ];
    };
  };

  programs.termite = {
    enable = true;
    clickableUrl = false;
    font = "Monospace 10";
    foregroundColor         = "#586e75";
    foregroundBoldColor     = "#586e75";
    cursorColor             = "#586e75";
    cursorForegroundColor   = "#fdf6e3";
    backgroundColor         = "#fdf6e3";
    colorsExtra = ''
      # Base16 Solarized Light
      # Author: Ethan Schoonover (modified by aramisgithub)
      # 16 color space

      # Black, Gray, Silver, White
      color0  = #fdf6e3
      color8  = #839496
      color7  = #586e75
      color15 = #002b36

      # Red
      color1  = #dc322f
      color9  = #dc322f

      # Green
      color2  = #859900
      color10 = #859900

      # Yellow
      color3  = #b58900
      color11 = #b58900

      # Blue
      color4  = #268bd2
      color12 = #268bd2

      # Purple
      color5  = #6c71c4
      color13 = #6c71c4

      # Teal
      color6  = #2aa198
      color14 = #2aa198

      # Extra colors
      color16 = #cb4b16
      color17 = #d33682
      color18 = #eee8d5
      color19 = #93a1a1
      color20 = #657b83
      color21 = #073642
    '';
  };

}
