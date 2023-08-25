{ pkgs, config, lib, ...}:
with lib;
let
  cfg = config.dotfiles.desktop;

  xorg = {
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
        if xrandr | grep -q "DP1 connected"; then
            xrandr --output DP1 --mode 2560x1440 --rate 120
            if xrandr | grep -q "DP2 connected"; then
                xrandr --output DP2 --left-of DP1 --auto
            fi
        fi
      '' + cfg.xsessionInitExtra;
      numlock.enable = true;
    };

    home.packages = with pkgs; [
      networkmanager
      networkmanagerapplet
    ];
  };

  i3-sway =
    let
      base00 = "#101218";
      base01 = "#1f222d";
      base02 = "#252936";
      base03 = "#7780a1";
      base04 = "#C0C5CE";
      base05 = "#d1d4e0";
      base06 = "#C9CCDB";
      base07 = "#fffff0";
      base08 = "#ee829f";
      base09 = "#f99170";
      base0A = "#ffefcc";
      base0B = "#a5ffe1";
      base0C = "#97e0ff";
      base0D = "#97bbf7";
      base0E = "#c0b7f9";
      base0F = "#fcc09e";

      battery-block =
        if config.dotfiles.desktop.laptop then [{
          block = "battery";
          format = " $icon $percentage {$time |}";
          device = "DisplayDevice";
          driver = "upower";
        }] else [];

      backlight-block =
        if config.dotfiles.desktop.laptop then [{
          block = "backlight";
          device = "intel_backlight";
        }] else [];

      net-block =
        if !config.dotfiles.desktop.laptop then [{
          block = "net";
          interval = 2;
          inactive_format = " $icon down ";
        }] else [];
    in {
      config = {
        window.titlebar = false;
        window.border = 3;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "alacritty";
        modifier = "Mod4";  # this is the "windows" key
        focus.followMouse = false;
        defaultWorkspace = "workspace number 1";
        gaps = {
          smartGaps = true;
          smartBorders = "on";
          inner = 8;
        };
        assigns = {
          "0" = [
            { class = "^Ferdium$"; }
          ];
          "1" = [
            { class = "^Firefox$"; }
            { class = "^google-chrome$"; }
          ];
        };
        floating.criteria = [
          { title = "^zoom$"; }
          { title = "^GAME$"; }
        ];
        focus.mouseWarping = false;
        bars = [{
          id = "top";
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            style = "Normal";
            size = 9.0;
          };
          colors = {
            separator  = base03;
            background = base07;
            statusline = base05;
            focusedWorkspace  = { background = base01; border = base01; text = base07; };
            activeWorkspace   = { background = base07; border = base02; text = base01; };
            inactiveWorkspace = { background = base07; border = base01; text = base03; };
            urgentWorkspace   = { background = base07; border = base01; text = base08; };
          };
        }];
        modes.resize = {
          Up = "resize shrink height 5 px or 5 ppt";
          Down = "resize grow height 5 px or 5 ppt";
          Left = "resize shrink width 5 px or 5 ppt";
          Right = "resize grow width 5 px or 5 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
        startup = [
          { command = "${pkgs.autotiling}/bin/autotiling"; always = false; }
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
          { command = "ferdium"; }
        ] ++ (if cfg.sway.enable then
           [ { command = "${pkgs.swaybg}/bin/swaybg -c '#444444'"; always = false; }
             { command = ''
                  swayidle timeout 900 'swaylock -c 111111' \
                           timeout 60 'swaymsg "output * dpms off"' \
                           resume 'swaymsg "output * dpms on"' \
                           before-sleep 'swaylock -c 111111' ''; always = false; }
           ] else []);
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${n}";
            # Without a moonlander, i3 registers the hardware key, not the software key
            left  = if config.dotfiles.desktop.laptop then "h" else "n";
            down  = if config.dotfiles.desktop.laptop then "j" else "e";
            up    = if config.dotfiles.desktop.laptop then "k" else "i";
            right = if config.dotfiles.desktop.laptop then "l" else "o";
            switches =
              builtins.foldl' (a: x:
                a // { "${mod}+${x}" = switch x; }
              ) {} (builtins.genList (x: toString x) 10);
          in lib.mkOptionDefault ({
            "${mod}+1" = switch "1";
            "${mod}+2" = switch "2";
            "${mod}+3" = switch "3";
            "${mod}+4" = switch "4";
            "${mod}+5" = switch "5";
            "${mod}+6" = switch "6";
            "${mod}+7" = switch "7";
            "${mod}+8" = switch "8";
            "${mod}+9" = switch "9";
            "${mod}+0" = switch "0";

            "${mod}+Shift+d" = "exec --no-startup-id ${pkgs.pass}/bin/passmenu";

            "${mod}+p" = "layout default";

            "${mod}+${left}" = "focus left";
            "${mod}+${down}" = "focus down";
            "${mod}+${up}" = "focus up";
            "${mod}+${right}" = "focus right";

            "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.i3lock}/bin/i3lock -n -c 111111";
            "${mod}+Ctrl+s" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
            "${mod}+Ctrl+n" = "exec --no-startup-id ${pkgs.gnome3.nautilus}/bin/nautilus";

            # Pulse Audio controls
            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

            # Sreen brightness controls
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

            # Media player controls
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play";
            "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          }
          // (if cfg.sway.enable then
              {
                "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.swaylock}/bin/swaylock -n -c 111111";
                "${mod}+Shift+r" = "exec --no-startup-id ${pkgs.sway}/bin/sway reload";
              }
              else {})
        );
      };

    i3status-rust = {
      enable = true;
      bars = {
        top = {
          blocks = [
            {
              block = "disk_space";
              path = "/boot";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
              info_type = "available";
              format = " /boot $available($percentage) ";
            }
            {
              block = "disk_space";
              path = "/";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
              info_type = "available";
            }
            {
              block = "temperature";
              format = " $icon $max max ";
              format_alt = " $icon $min min, $max max, $average avg ";
              interval = 10;
              chip = "*-isa-*";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents.eng(w:1) ";
              format_alt = " $icon_swap $swap_used.eng(w:3,u:B,p:M)/$swap_total.eng(w:3,u:B,p:M)($swap_used_percents.eng(w:2)) ";
              interval = 30;
              warning_mem = 70;
              critical_mem = 70;
            }
            {
              block = "cpu";
              interval = 1;
              format = " $icon $barchart $utilization ";
              format_alt = " $icon $frequency{ $boost|} ";
            }
            {
              block = "load";
              format = " $icon 1min avg: $1m.eng(w:4) ";
              interval = 1;
            }
            {
              block = "time";
              format = " $icon $timestamp.datetime(f:'%a %d-%m-%Y %R %Z', l:nb_NO) ";
              interval = 60;
            }
          ] ++ battery-block
            ++ backlight-block
            ++ net-block;
          settings = {
            icons =  {
              icons = "awesome6";
            };
            theme = {
              theme = "solarized-light";
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      dmenu
      gtk-engine-murrine
      gtk_engines
      gsettings-desktop-schemas
      lxappearance
    ];

    programs.qt5ct.enable = true;
  };

  i3 = {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = i3-sway.config;
    };

    programs.i3status-rust = i3-sway.i3status-rust;

    home.packages = with pkgs; [
      i3-gaps
      i3lock
    ];
  };

  sway = {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true ;
      config = i3-sway.config;
    };

    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      alacritty
      wf-recorder
      wofi
      clipman
      swaybg
      networkmanager
      networkmanagerapplet
    ];
  };

in {
  options.dotfiles.desktop = {
    i3 = {
      enable = mkEnableOption "Enable i3";
    };

    sway = {
      enable = mkEnableOption "Enable sway";
    };

    xsessionInitExtra = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.i3.enable) xorg)
    (mkIf cfg.i3.enable i3)
    (mkIf cfg.sway.enable sway)
  ];

  imports = [ ./polybar.nix ];
}

