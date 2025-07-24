{
  config = {
    "network#info" = {
      interval = 2;
      format = "󱘖  Offline";
      format-wifi = "{icon} {bandwidthDownBits}";
      format-ethernet = "󰈀 {bandwidthDownBits}";
      min-length = 11;
      tooltip = "{}";
      tooltip-format-wifi = "{ifname}\n{essid}\n{signalStrength}% \n{frequency} GHz\n󰇚 {bandwidthDownBits}\n󰕒 {bandwidthUpBits}";
      tooltip-format-ethernet = "{ifname}\n󰇚 {bandwidthDownBits} \n󰕒 {bandwidthUpBits}";
      on-click = "~/.config/waybar/scripts/launch-wifi-manager.sh";
      format-icons = [
        "󰤫"
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];
      states = {
        normal = 25;
      };
    };

    "network#up" = {
      interval = 4;
      format = " ";
      format-wifi = "󰕒 {bandwidthUpBits}";
      format-ethernet = "󰕒 {bandwidthUpBits}";
      format-disconnected = " ";
      min-length = 11;
    };

    "network#down" = {
      interval = 4;
      format = "󰇚 {bandwidthDownBits}";
      format-wifi = "󰇚 {bandwidthDownBits}";
      format-ethernet = "󰇚 {bandwidthDownBits}";
      min-length = 11;
    };
  };

  style = ''
    #waybar.bar #network {
      color: #f5c2e7;
    }

    #waybar.bar #network.info {
      padding-right: 10px;
      padding-left: 10px;
      color: #45475a;
      background: transparent;
    }

    #waybar.bar #network.info.wifi.normal,
    #waybar.bar #network.info.ethernet {
      color: #f5c2e7;
      padding-right: 15px;
    }

    #waybar.bar #network.info.wifi {
      color: #f38ba8;
      padding-right: 15px;
    }
  '';
}
