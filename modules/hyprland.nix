{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dotfiles.desktop;

  hyprland = {
    home.packages = with pkgs; [
      wev
      wl-clipboard
      nm-tray
      grimblast
    ];

    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.settings = {
        # TODO: Move out to home.nix
        monitor = cfg.hyprland.monitors;

        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";
        "$menu" = "${pkgs.rofi-wayland}/bin/rofi -show drun";

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

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

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

        input = {
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_model = "";
          kb_options = "";
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
          "$mainMod, V, togglefloating,"
          "$mainMod, F, fullscreen,"
          "$mainMod, D, exec, $menu"
          "$mainMod, W, togglegroup, "
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod SHIFT, D, exec, ${pkgs.rofi-pass-wayland}/bin/rofi-pass"
          "$mainMod CTRL, L, exec, hyprlock --immediate"
          # TODO: Screenshot
          "$mainMod CTRL, S, exec, grimblast copy area"
          "$mainMod CTRL, N, exec, $fileManager"

          # "focus with mainMod + vim keys"
          "$mainMod, N, movefocus, l"
          "$mainMod, E, movefocus, d"
          "$mainMod, I, movefocus, u"
          "$mainMod, O, movefocus, r"

          # Move in and out of groups
          "$mainMod SHIFT, N, movewindoworgroup, l"
          "$mainMod SHIFT, E, movewindoworgroup, d"
          "$mainMod SHIFT, I, movewindoworgroup, u"
          "$mainMod SHIFT, O, movewindoworgroup, r"

          # Master
          "$mainMod, P, layoutmsg, swapwithmaster"
          "$mainMod, SPACE, layoutmsg, orientationnext"

          # Window cycling
          "$mainMod, Tab, cyclenext, "
          "$mainMod, Tab, changegroupactive, f"

          "$mainMod SHIFT, return, movecurrentworkspacetomonitor, +1"


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
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

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

          ", XF86AudioMute,         exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ", XF86AudioRaiseVolume,  exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%"
          ", XF86AudioLowerVolume,  exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%"
        ];

        bindl = [
          ", switch:Lid Switch, exec, hyprlock"

          # Audio
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ];

        windowrulev2 = "suppressevent maximize, class:.*"; # You'll probably like this.
      };
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            grace = 5;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          label = {
            text = ''
              cmd[update:1000] echo "$(date +"%T")"
            '';
            font_size = 90;
            position = "-130, -100";
            halign = "right";
            valign = "top";
          };

          input-field = [
            {
              size = "400, 50";
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
            }
          ];
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
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }

            {
              timeout = 3600;
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

            wallpaper = [ ",${nix-black}" ];
          };
        };
    };
  };
in
{
  options.dotfiles.desktop = with lib; {
    hyprland = {
      enable = mkEnableOption "Enable hyprland";
      monitors = mkOption {
        type = types.listOf types.str;
        default = [ ", preferred, auto, 1.0" ];
      };
    };
  };

  config =
    with lib;
    mkMerge [
      (mkIf cfg.hyprland.enable hyprland)
    ];
}
