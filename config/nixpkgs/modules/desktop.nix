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

    programs.alacritty = {
      enable = true;
      # settings = {
      #   font.size = 11.0;
      #   colors = {
      #     primary = {
      #       background = "";
      #       dim_background = "";
      #     };
      #   };
      # };
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
