{
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        name = "main-bar";
        layer = "top";
        position = "bottom";
        height = 36;

        modules-left = [
          "custom/os_button"
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "hyprland/language"
          "temperature"
          "cpu"
          "memory"
          "network"
          "pulseaudio"
          "clock"
        ];

        "custom/os_button" = {
          format = "";
          "on-click" = "${pkgs.rofi-wayland}/bin/rofi -show drun";
          tooltip = false;
        };

        "hyprland/language" = {
          format = "{short} ({variant})";
        };

        cpu = {
          format = "  {usage}%";
        };

        memory = {
          format = "  {percentage}%";
        };

        network = {
          "format-wifi" = "   {signalStrength}%";
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
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
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

        tray = {
          "icon-size" = 18;
          spacing = 3;
        };

        clock = {
          format = "{:%d.%m.%Y %R %z}";
          format-alt = "{:%H:%M}";
          timezone = "Europe/Berlin";
        };
      };
    };
  };
}
