semantic: {
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
  };

  style = ''
    #waybar.bar #network {
      color: ${semantic.performance};
    }

    #waybar.bar #network.info {
      padding-right: 10px;
      padding-left: 10px;
      color: ${semantic.border};
      background: transparent;
    }

    #waybar.bar #network.info.wifi.normal,
    #waybar.bar #network.info.ethernet {
      color: ${semantic.performance};
      padding-right: 15px;
    }

    #waybar.bar #network.info.wifi {
      color: ${semantic.warning};
      padding-right: 15px;
    }
  '';
}
