{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.desktop;

  configuration = {
    dotfiles.packages.desktop.enable = lib.mkDefault true;

    dotfiles.desktop.onedrive.enable = lib.mkDefault false;
    dotfiles.desktop.sway.enable = lib.mkDefault false;
    dotfiles.desktop.i3.enable = lib.mkDefault false;
    dotfiles.desktop.hyprland.enable = lib.mkDefault true;

    dotfiles.desktop.fontSize = lib.mkDefault 12.0;

    qt = {
      enable = true;
      platformTheme = {
        name = "gtk3";
      };
    };

    programs = {
      browserpass.enable = true;

      feh.enable = true;

      firefox.enable = true;

      chromium = {
        enable = true;
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform-hint=wayland"
          "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder"
        ];
      };

      gpg = {
        enable = true;
        settings = {
          use-agent = true;
        };
      };

      alacritty = {
        enable = false;
        settings = {
          window = {
            opacity = 0.8;
          };
          font = {
            normal = {
              family = "JetBrains Mono Nerd Font";
              style = "Regular";
            };
            size = cfg.fontSize;
          };
        };
      };

      ghostty = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          font-size = cfg.fontSize;
          cursor-style = "block";
          shell-integration-features = "no-cursor";
          keybind = [
            "ctrl+shift+space=write_screen_file:open"
          ];
          link-url = false;
        };
      };
    };

    home.file = {
      xmodmap = {
        source = /home/simkir/.dotfiles/adhoc/Xmodmap;
        target = ".Xmodmap";
        recursive = false;
      };
    };

    services = {
      flameshot.enable = true;
      pasystray.enable = false;
      clipmenu.enable = false;

      dunst.enable = true;

      screen-locker = {
        enable = false;
        inactiveInterval = 120;
        lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 121212";
        # lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -n -p";
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
        pinentry.package = pkgs.pinentry-gnome3;
      };

      gnome-keyring = {
        enable = true;
        components = [
          "pkcs11"
          "secrets"
        ];
      };
    };

    systemd.user.sessionVariables = {
      GIO_EXTRA_MODULES = "${pkgs.gvfs}/lib/gio/modules";
    };

    xresources.properties = {
      "Xclip.selection" = "clipboard";
      "Xcursor.theme" = "cursor-theme";
      "Xcursor.size" = 12;
    };

    xdg.desktopEntries = {
    };
  };

  dropbox = {
    services.dropbox.enable = true;
    home.packages = with pkgs; [ dropbox-cli ];
  };

  onedrive = {
    systemd.user.services.onedrive = {
      Unit = {
        Description = "OneDrive sync";
      };
      Service = {
        ExecStart = "${pkgs.onedrive}/bin/onedrive --monitor";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
in
{
  options.dotfiles.desktop = with lib; {
    enable = mkEnableOption "Enable desktop";
    laptop = mkEnableOption "Enable laptop features";
    fontSize = mkOption {
      type = types.float;
      default = 12.0;
    };
    dropbox.enable = mkEnableOption "Enable Dropbox";
    onedrive.enable = mkEnableOption "Enable OneDrive";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      configuration
      (lib.mkIf cfg.dropbox.enable dropbox)
      (lib.mkIf cfg.onedrive.enable onedrive)
    ]
  );

  imports = [
    ./wm.nix
    ./stylix.nix
  ];
}
