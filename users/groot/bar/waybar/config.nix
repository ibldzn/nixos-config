swayEnabled: {
  mainBar = {
    layer = "top";
    position = "top";
    # height = 30;
    spacing = 4; # (in px)
      modules-left = 
      (if swayEnabled then [ "sway/workspaces" "sway/mode" ] else [ ]);
    modules-center = [ "clock" ];
    modules-right = [ "pulseaudio" "network" "cpu" "memory" "temperature" ];

    cpu = {
      format = "{usage}% ";
    };

    memory = {
      format = "{}% ";
    };

    backlight = {
      format = "{percent}% {icon}";
      format-icons = ["" ""];
    };

    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-charging = "{capacity}% ";
      format-plugged = "{capacity}% ";
      format-alt = "{time} {icon}";
      format-icons = ["" "" "" "" ""];
    };

    network = {
      format-wifi = "{essid} ({signalStrength}%) ";
      format-ethernet = "{ipaddr}/{cidr} ";
      tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      format-linked = "{ifname} (No IP) ";
      format-disconnected = "Disconnected ⚠";
      format-alt = "{bandwidthUpBytes}  {bandwidthDownBytes}  ";
      interval = 1;
    };

    temperature = {
      hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
      critical-threshold = 80;
      format = "{temperatureC}°C {icon}";
      format-icons = ["" "" ""];
    };

    clock = {
      locale = "ja_JP.UTF-8";
      format = "{:%a|%m月%d日|%R}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon}  {format_source}";
      format-bluetooth-muted = " {icon}  {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        phone = "";
        portable = "";
        car = "";
        default = ["" "" ""];
      };
      on-click = "pavucontrol";
    }; 
  };
}
