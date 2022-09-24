{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.desktop;

  configuration = {
    dotfiles.packages.desktop.enable = mkDefault true;

    dotfiles.desktop.onedrive.enable = mkDefault false;
    dotfiles.desktop.xmonad.enable = mkDefault false;
    dotfiles.desktop.sway.enable = mkDefault false;
    dotfiles.desktop.i3.enable = mkDefault true;

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
      icons = {
        source = ~/.dotfiles/icons;
        target = ".icons";
        recursive = true;
      };
      xmodmap = {
        source = ~/.dotfiles/Xmodmap;
        target = ".Xmodmap";
        recursive = false;
      };
    };

    # systemd.user.services.pa-applet = {
    #   Unit = {
    #     Description = "PulseAudio volume applet";
    #   };
    #   Service = {
    #     ExecStart = "${pkgs.pa_applet}/bin/pa-applet";
    #     Restart = "on-failure";
    #     RestartSec = "10s";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };

    services = {
      pasystray.enable = true;
      flameshot.enable =  true;
      clipmenu.enable =  true;

      screen-locker = {
        enable = false;
        inactiveInterval = 120;
        lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 121212";
        # lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -n -p";
      };

      network-manager-applet.enable = true;
      blueman-applet.enable = false;

      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 43200;
        maxCacheTtl = 604800; # 7 days
        maxCacheTtlSsh = 604800;
        # pinentryFlavor = "gtk2";
        pinentryFlavor = "gnome3";
      };

      gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" ];
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
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 0;
        # gtk-theme-name = "Sierra-compact-light";
        # gtk-icon-theme-name = "ePapirus";
        # gtk-font-name = "Ubuntu 11";
        gtk-cursor-theme-name = "Deepin";
        gtk-cursor-theme-size = 0;
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
        gtk-xft-rgba = "rgb";
        gtk-modules = "gail:atk-bridge";
      };
    };

    xresources.properties = {
      "Xclip.selection" = "clipboard";
      "Xcursor.theme" = "cursor-theme";
      "Xcursor.size" = 16;
    };

    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
        ionide.ionide-fsharp
        vscodevim.vim
      ];
      userSettings = {
        "editor.minimap.enabled" = false;
        "editor.renderControlCharacters" = false;
        "keyboard.dispatch" = "keyCode";
        "window.menuBarVisibility" = "toggle";
        "workbench.editor.enablePreview" = false;
        "workbench.colorCustomizations" = {
            "editorWhitespace.foreground" = "#e0e0e0";
        };
        "vim.textwidth" = 120;
        "vim.leader" = "<space>";
        "vim.normalModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "S-k" ];
            "commands" = [ "editor.action.showHover" ];
          }
          {
            "before" = [ "g" "e" ];
            "commands" = [ "editor.action.marker.next" ];
          }
          {
            "before" = [ "g" "p" ];
            "commands" = [ "editor.action.marker.prev" ];
          }
        ];
        "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace, 'Droid Sans Fallback'";
        "editor.fontLigatures" = true;
        "workbench.activityBar.visible" = true;
        "FSharp.dotnetRoot" = pkgs.dotnet-sdk_6;
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font.size = 11.0;
        colors = {
          primary = {
            background = "#fdf6e3";
            foreground = "#657b83";
          };
          cursor = {
            text = "#fdf6e3";
            cursor = "#657b83";
          };
          normal = {
            black =   "#073642"; # base02
            red =     "#dc322f"; # red
            green =   "#859900"; # green
            yellow =  "#b58900"; # yellow
            blue =    "#268bd2"; # blue
            magenta = "#d33682"; # magenta
            cyan =    "#2aa198"; # cyan
            white =   "#eee8d5"; # base2;
          };
          bright = {
            black =   "#002b36"; # base03
            red =     "#cb4b16"; # orange
            green =   "#586e75"; # base01
            yellow =  "#657b83"; # base00
            blue =    "#839496"; # base0
            magenta = "#6c71c4"; # violet
            cyan =    "#93a1a1"; # base1
            white =   "#fdf6e3"; # base3
          };
        };
      };
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
  options.dotfiles.desktop = {
    enable = mkEnableOption "Enable desktop";
    laptop = mkEnableOption "Enable laptop features";
    dropbox.enable = mkEnableOption "Enable Dropbox";
    onedrive.enable = mkEnableOption "Enable OneDrive";
  };

  config = mkIf cfg.enable (mkMerge [
      configuration
      (mkIf cfg.dropbox.enable dropbox)
      (mkIf cfg.onedrive.enable onedrive)
  ]);

  imports = [ ./wm.nix ];
}
