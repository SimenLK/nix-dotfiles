{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.desktop;

  configuration = {
    dotfiles.packages.desktop.enable = mkDefault true;

    dotfiles.desktop.xmonad.enable = mkDefault true;
    #dotfiles.desktop.sway.enable = mkDefault true;

    programs = {
      browserpass.enable = true;
      feh.enable = true;
      firefox.enable = true;
      gpg = {
        enable = true;
        settings = {
          use-agent = true;
        };
      };
    };

    home.file = {
      xmodmap = {
        source = ~/.dotfiles/Xmodmap;
        target = ".Xmodmap";
        recursive = false;
      };
    };

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
        # WantedBy = [ "default.target" ];
      };
    };

    services = {
      pasystray.enable = true;
      flameshot.enable =  true;
      clipmenu.enable =  true;

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
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 43200;
        maxCacheTtl = 604800; # 7 days
        maxCacheTtlSsh = 604800;
        extraConfig = ''
          pinentry-program ${pkgs.pinentry-gtk2}/bin/pinentry
        '';
      };
    };

    systemd.user.sessionVariables = {
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    };

    gtk = {
      enable = true;
      font.name = "DejaVu Sans 11";
      iconTheme.name = "Ubuntu-mono-dark";
      theme.name = "Adwaita";
      gtk3.extraConfig = { gtk-application-prefer-dark-theme = 0; };
    };

    xresources.properties = {
      "Xclip.selection" = "clipboard";
      "Xcursor.theme" = "cursor-theme";
      "Xcursor.size" = 16;
    };

    programs.vscode = {
      enable = true;
      extensions = [];
      haskell = {
        enable = false;
        hie.enable = false;
      };
      userSettings = {
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
  };

  dropbox = {
    services.dropbox.enable = true;
    home.packages = with pkgs; [ dropbox-cli ];
  };
in
{
  options.dotfiles.desktop = {
    enable = mkEnableOption "Enable desktop";
    dropbox.enable = mkEnableOption "Enable Dropbox";
  };

  config = mkIf cfg.enable (mkMerge [
      configuration
      (mkIf cfg.dropbox.enable dropbox)
  ]);

  imports = [ ./xmonad.nix ];
}
