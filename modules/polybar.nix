{pkgs, config, lib,...}:
with lib;
let
  cfg = config.dotfiles.desktop.polybar;

  configuration = {
    services.polybar = {
      enable = true;
      script = ''
        export MONITOR=DP-2
        polybar main &
      '';
      config = {
        "colors" = {
          background = "#d0303030";
          background-transparent = "#00303030";
          background-alt = "#c0303030";
          background-alt-2 = "#ff5fafcf";
          foreground = "#dddddd";
          foreground-alt = "#c1c2c3";
          red = "#fb4934";
          green = "#b8bb26";
          yellow = "#fabd2f";
          blue = "#83a598";
          purple = "#d3869b";
          aqua = "#8ec07c";
          orange = "#fe8019";
          white = "#dddddd";
          blue_arch = "#83afe1";
          grey = "#5b51c9";
          grey1 = "#5bb1c9";
          grey2 = "#5bf1c9";
          primary = "green";
          secondary = "blue";
          alert = "red";
        };
        "bar/main" = {
          monitor = "\${env:MONITOR:}";
          bottom = true;
          height = 20;
          radius = 0;
          padding = 1;
          module-margin = 2;
          separator = "|";
          font-0 = "NotoSans Regular:size=8;2";
          font-1 = "Termsynu:size=8;-1";
          font-2 = "Material Icons:style=Regular:size=14;2";
          font-3 = "Noto Sans Symbols2:size=10";
          font-4 = "Noto Color Emoji:style=Regular:size=10";
          modules-right =
          if cfg.laptop then
            "fs cpu memory net battery keyboard date powermenu"
          else
            "fs cpu memory net keyboard date powermenu";
          modules-center = "";
          tray-position = "right";
          tray-padding = 2;
          tray-maxsize = 16;
          tray-scale = "1.0";
        };
        "module/date" = {
          type = "internal/date";
          internal = 1;
          date = "%{F#c9aa7c}%d %B %Y%{F-}";
          time = "%H:%M:%S";
          label = "%{A1:${pkgs.gsimplecal}/bin/gsimplecal:}%date% %time% %{A}";
        };
        "module/keyboard" = {
          type = "internal/xkeyboard";
          label-layout = "%number% %layout%";
          blacklist-0 = "caps lock";
          blacklist-1 = "num lock";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = "2";
          format = "<label>";
          format-prefix = "cpu ";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%percentage%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format = "<bar-used>";
          format-prefix = "";
          format-prefix-foreground = "\${colors.foreground}";
          label = "%percentage_used%%";
          bar-used-indicator = "";
          bar-used-width = "10";
          bar-used-foreground-0 = "#55aa55";
          bar-used-foreground-1 = "#557755";
          bar-used-foreground-2 = "#f5a70a";
          bar-used-foreground-3 = "#ff5555";
          bar-used-fill = "▐";
          bar-used-empty = "▐";
          bar-used-empty-foreground = "#444444";
        };
        "module/fs" = {
          type = "internal/fs";
          mount-0 = "/";
        };
        "module/net" = if (cfg.interface != null) then
        {
          type = "internal/network";
          interface = "\${env:DEFAULT_NETWORK_INTERFACE:${cfg.interface}}";
          interval = 1;
          format-connected = "<label-connected>";
          label-connected = "%{F#83a598}↓%{F-}%downspeed% %{F#fb4934}↑%{F-}%upspeed%";
        } else {};
        "module/powermenu" = {
          type = "custom/menu";
          expand-right = "true";
          format-spacing = 1;
          label-open = "⏻";
          label-open-foreground = "\${colors.secondary}";
          label-close = "%{F#fe8019}✕%{F-}";
          label-close-foreground = "\${colors.secondary}";
          label-separator = "/";
          label-separator-foreground = "\${colors.foreground}";

          menu-0-0 = "%{F#999999}reboot%{F-}";
          menu-0-0-exec = "menu-open-1";
          menu-0-1 = "%{F#999999}power off%{F-}";
          menu-0-1-exec = "menu-open-2";

          menu-1-0 = "%{F#ff4000}yes%{F-}";
          menu-1-0-exec = "reboot";
          menu-1-1 = "%{F#999999}no%{F-}";
          menu-1-1-exec = "menu-close";

          menu-2-0 = "%{F#ff4000}yes%{F-}";
          menu-2-0-exec = "poweroff";
          menu-2-1 = "%{F#999999}no%{F-}";
          menu-2-1-exec = "menu-close";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          full-at = "98";
          time-format = "%H:%M";
          format-full-prefix = " ";
          format-full-prefix-foreground = "\${colors.foreground}";
          format-charging = "<label-charging>";
          label-charging = " (%percentage%%)";
          format-discharging = "<label-discharging>";
          label-discharging = " (%percentage%%)";
        };
        "module/volume" = {
          type = "internal/alsa";
          format-volume = "<label-volume>";
          label-muted = "muted";
          label-volume = "%{A1:${pkgs.pavucontrol}/bin/pavucontrol:}%{A} %percentage%%";
          label-muted-foreground = "#66";
        };
      };
    };
  };
in {
  options.dotfiles.desktop.polybar = {
    enable = mkEnableOption "Enable polybar";

    interface = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Interface for network monitor";
    };
  };

  config = mkIf cfg.enable configuration;

}
