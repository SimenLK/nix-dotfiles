{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.dotfiles.desktop;

  configuration = {
    dotfiles.packages.desktop.enable = mkDefault true;

    dotfiles.desktop.onedrive.enable = mkDefault false;
    dotfiles.desktop.xmonad.enable = mkDefault false;
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
        enable = true;
        inactiveInterval = 120;
        lockCmd = "${pkgs.i3lock}/bin/i3lock -n -c 121212";
        # lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -n -p";
      };

      network-manager-applet.enable = true;
      blueman-applet.enable = true;

      lorri.enable = true;

      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        defaultCacheTtl = 43200; # 12 hours
        defaultCacheTtlSsh = 43200;
        maxCacheTtl = 604800; # 7 days
        maxCacheTtlSsh = 604800;
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
      "Xcursor.size" = 11;
    };

    programs.vscode = {
      enable = true;
      extensions = [];
      userSettings = {
        "editor.minimap.enabled" = false;
        "editor.renderWhitespace" = "trailing";
        "editor.renderControlCharacters" = true;
        "editor.rulers" = [ 80 120 ];
        "editor.lineNumbers" = "relative";
        "editor.renderLineHighlight" = "all";
        "editor.smoothScrolling" = true;
        "editor.cursorBlinking" = "smooth";
        "editor.guides.indentation" = true;
        "editor.guides.highlightActiveIndentation" = false;
        "window.menuBarVisibility" = "toggle";
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.settings.editor" = "json";
        "files.trimTrailingWhitespace" = true;
        "FSharp.dotnetRoot" = pkgs.dotnet-sdk_6;
        "vim.leader" = "<space>";
        "vim.normalModeKeyBindings" = [
          {
            "before" = [ "C-n" ];
            "commands" = [
              { "command" = "workbench.action.toggleSidebarVisibility"; }
            ];
          }
          {
          "before" = [ "<leader>" "r" ];
          "commands" = [
              { "command" = "editor.action.rename"; }
            ];
          }
          {
            "before" = [ "<leader>" "n" ];
            "commands" = [
              { "command" = "editor.action.goToReferences"; }
            ];
          }
          {
            "before" = [ "<leader>" "r" "g" ];
            "commands" = [
              { "command" = "workbench.action.findInFiles"; }
            ];
          }
          {
            "before" = [ "<leader>" "g" "e" ];
            "commands" = [
              { "command" = "editor.action.marker.nextInFiles"; }
            ];
          }
        ];
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
