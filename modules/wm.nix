{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.dotfiles.desktop;

  xorg = {
    xsession = {
      enable = true;
      initExtra =
        ''
          xsetroot -solid '#888888'
          xsetroot -cursor_name left_ptr
          ${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-xsettings &
          systemctl --user start gvfs-udisks2-volume-monitor.service
          xset s 1800
          xset +dpms
          xset dpms 1800 2400 3600
          xmodmap $HOME/.dotfiles/adhoc/Xmodmap
          if xrandr | grep -q "DP1 connected"; then
              xrandr --output DP1 --mode 2560x1440 --rate 120
              if xrandr | grep -q "DP2 connected"; then
                  xrandr --output DP2 --left-of DP1 --auto
              fi
          fi
        ''
        + cfg.xsessionInitExtra;
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
        if config.dotfiles.desktop.laptop then
          [
            {
              block = "battery";
              format = " $icon $percentage {$time |}";
              device = "DisplayDevice";
              driver = "upower";
            }
          ]
        else
          [ ];

      backlight-block =
        if config.dotfiles.desktop.laptop then
          [
            {
              block = "backlight";
              device = "intel_backlight";
            }
          ]
        else
          [ ];

      net-block =
        if !config.dotfiles.desktop.laptop then
          [
            {
              block = "net";
              interval = 2;
              inactive_format = " $icon down ";
            }
          ]
        else
          [ ];
    in
    {
      config = {
        window.titlebar = false;
        window.border = 3;
        # terminal = "alacritty --working-directory $($HOME/nixos-configuration/get-last-location.sh)";
        terminal = "alacritty";
        modifier = "Mod4"; # this is the "windows" key
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
            { class = "^rssguard$"; }
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
        bars = [
          {
            id = "main";
            position = "bottom";
            statusCommand = ''
              ${pkgs.i3status-rust}/bin/i3status-rs \
                ~/.config/i3status-rust/config-main.toml
            '';
            fonts = {
              names = [
                "DejaVu Sans Mono"
                "FontAwesome5Free"
              ];
              style = "Normal";
              size = 9.0;
            };
            colors = {
              separator = base03;
              background = base07;
              statusline = base05;
              focusedWorkspace = {
                background = base01;
                border = base01;
                text = base07;
              };
              activeWorkspace = {
                background = base07;
                border = base02;
                text = base01;
              };
              inactiveWorkspace = {
                background = base07;
                border = base01;
                text = base03;
              };
              urgentWorkspace = {
                background = base07;
                border = base01;
                text = base08;
              };
            };
          }
        ];
        modes.resize = {
          Up = "resize shrink height 5 px or 5 ppt";
          Down = "resize grow height 5 px or 5 ppt";
          Left = "resize shrink width 5 px or 5 ppt";
          Right = "resize grow width 5 px or 5 ppt";
          Escape = "mode default";
          Return = "mode default";
        };
        startup =
          [
            {
              command = "${pkgs.autotiling}/bin/autotiling";
              always = false;
            }
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
            { command = "ferdium"; }
            { command = "rssguard"; }
          ]
          ++ (
            if cfg.sway.enable then
              [
                {
                  command = "${pkgs.swaybg}/bin/swaybg -c '#444444'";
                  always = false;
                }
                {
                  command = ''
                    swayidle timeout 900 'swaylock -c 111111' \
                             timeout 60 'swaymsg "output * dpms off"' \
                             resume 'swaymsg "output * dpms on"' \
                             before-sleep 'swaylock -c 111111' '';
                  always = false;
                }
              ]
            else
              [ ]
          );
        keybindings =
          let
            mod = config.xsession.windowManager.i3.config.modifier;
            switch = n: "exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch ${n}";
            # Without a moonlander, i3 registers the hardware key, not the software key
            left = if config.dotfiles.desktop.laptop then "h" else "n";
            down = if config.dotfiles.desktop.laptop then "j" else "e";
            up = if config.dotfiles.desktop.laptop then "k" else "i";
            right = if config.dotfiles.desktop.laptop then "l" else "o";
            switches = builtins.foldl' (a: x: a // { "${mod}+${x}" = switch x; }) { } (
              builtins.genList (x: toString x) 10
            );
          in
          lib.mkOptionDefault (
            {
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
            // (
              if cfg.sway.enable then
                {
                  "${mod}+Ctrl+l" = "exec --no-startup-id ${pkgs.swaylock}/bin/swaylock -n -c 111111";
                  "${mod}+Shift+r" = "exec --no-startup-id ${pkgs.sway}/bin/sway reload";
                }
              else
                { }
            )
          );
      };

      i3status-rust = {
        enable = true;
        bars = {
          main = {
            blocks = [
              {
                block = "disk_space";
                path = "/boot";
                interval = 60;
                warning = 90.0;
                alert = 95.0;
                info_type = "used";
                format = " /boot $used($percentage) ";
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
            ] ++ battery-block ++ backlight-block ++ net-block;
            settings = {
              icons.icons = "awesome6";
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
      wrapperFeatures.gtk = true;
      config = i3-sway.config;
      xwayland = false;
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

  hyprland = {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      wofi
      wofi-pass
    ];

    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.settings = {
        monitor = ",preferred,auto,1";

        "$terminal" = "alacritty";
        "$fileManager" = "nautilus";
        "$menu" = "wofi --show drun";

        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "master";
        };

        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 0.8;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.4696;
          };
        };

        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          pseudotile = true;
          preserve_split = true; # You probably want this
        };

        master = {
          new_status = "slave";
        };

        misc = {
          force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "ctrl:swapcaps";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = false;
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, return, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod SHIFT, N, exec, $fileManager"
          "$mainMod, V, togglefloating,"
          "$mainMod, F, fullscreen,"
          "$mainMod, D, exec, $menu"
          "$mainMod SHIFT, D, exec, wofi-pass -c -s"
          "$mainMod, W, togglegroup, "

          "CTRL SHIFT, L, exec, hyprlock"

          # "focus with mainMod + vim keys"
          "$mainMod, H, movefocus, l"
          "$mainMod, J, movefocus, d"
          "$mainMod, K, movefocus, u"
          "$mainMod, L, movefocus, r"

          # Move in and out of groups
          "$mainMod SHIFT, H, movewindoworgroup, l"
          "$mainMod SHIFT, J, movewindoworgroup, d"
          "$mainMod SHIFT, K, movewindoworgroup, u"
          "$mainMod SHIFT, L, movewindoworgroup, r"

          # Window cycling
          "$mainMod, Tab, layoutmsg, swapwithmaster"
          "$mainMod, Tab, changegroupactive, f"

          # "h workspaces with mainMod + [0-9]"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 0, movetoworkspace, 0"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"

          # le special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # l through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        binde = [
          ", XF86MonBrightnessUp,   exec, brightnessctl set +10%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"

          ", XF86AudioMute,         exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioRaiseVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ +10%"
          ", XF86AudioLowerVolume,  exec, pactl set-sink-volume @DEFAULT_SINK@ -10%"
        ];

        bindl = [
          ", switch:Lid Switch, exec, hyprlock"
        ];

        windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
      };
    };

    programs = {
      hyprlock = {
        enable = false;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = ''
                <span foreground="##cad3f5">Password...</span>
              '';
              shadow_passes = 2;
            }
          ];
        };
      };

      waybar = {
        enable = true;
        systemd.enable = true;
        style = builtins.readFile ./style.css;
        settings = {
          mainBar = {
            name = "main-bar";
            layer = "top";
            position = "bottom";
            height = 30;
            output = [
              "eDP-1"
              "HDMI-A-1"
            ];

            modules-left = [
              "custom/os_button"
              "hyprland/workspaces"
            ];

            modules-center = [ "hyprland/window" ];

            modules-right = [
              "mpd"
              "custom/mymodule#with-css-id"
              "temperature"
              "cpu"
              "memory"
              "network"
              "pulseaudio"
              "backlight"
              "battery"
              "clock"
            ];

            "hyprland/workspaces" = {
              all-outputs = true;
            };

            "custom/os_button" = {
              format = "";
              "on-click" = "wofi --show drun";
              tooltip = false;
            };

            cpu = {
              format = "  {usage}%";
            };

            memory = {
              format = "  {percentage}%";
            };

            network = {
              "format-wifi" = "{essid} ({signalStrength}%) ";
              "format-ethernet" = " {ifname}";
              "tooltip-format" = " {ifname} via {gwaddr}";
              "format-linked" = " {ifname} (No IP)";
              "format-disconnected" = "Disconnected ⚠ {ifname}";
              "format-alt" = " {ifname}: {ipaddr}/{cidr}";
            };

            pulseaudio = {
              "format" = "{icon}   {volume}% ";
              "format-icons" = {
                "headphone" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  ""
                  ""
                  ""
                ];
              };
              "on-click" = "pavucontrol";
            };

            backlight = {
              "device" = "intel_backlight";
              "format" = "{icon}   {percent}% ";
              "format-icons" = [
                ""
                ""
              ];
            };

            battery = {
              "states" = {
                "warning" = 30;
                "critical" = 15;
              };
              "format" = "{icon}   {capacity}%";
              "format-charging" = " {capacity}%";
              "format-plugged" = " {capacity}%";
              "format-alt" = "{icon} {time}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
              ];
            };
          };
        };
      };
    };

    services = {
      # Notification engine using gnome
      swaync.enable = true;

      # For sleeping Zzz
      hypridle = {
        enable = true;
        settings = {
          general = {
            ignore_dbus_inhibit = false;
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "loginctl lock-session";
            }

            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };

      hyprpaper =
        # TODO: Expose wallpapers as option
        let
          root = "/home/simkir/code/nixos-artwork/wallpapers/";
          nix-black = root + "nix-wallpaper-binary-black.png";
        in
        {
          enable = true;
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2.0;

            preload = [ nix-black ];

            wallpaper = [ "eDP-1,${nix-black}" ];
          };
        };
    };
  };
in
{
  options.dotfiles.desktop = {
    i3 = {
      enable = lib.mkEnableOption "Enable i3";
    };

    sway = {
      enable = lib.mkEnableOption "Enable sway";
    };

    hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
    };

    xsessionInitExtra = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.i3.enable) xorg)
    (lib.mkIf cfg.i3.enable i3)
    (lib.mkIf cfg.sway.enable sway)
    (lib.mkIf cfg.hyprland.enable hyprland)
  ];

  imports = [ ./polybar.nix ];
}
