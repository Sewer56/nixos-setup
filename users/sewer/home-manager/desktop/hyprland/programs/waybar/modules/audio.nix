{
  config = {
    "pulseaudio#output" = {
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}%";
      format-source-muted = "{volume}";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
        ];
      };
      on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
      on-click = "pwvucontrol & aplay ~/.config/sounds/interact.wav";
      tooltip = true;
      scroll-step = 5;
    };

    "pulseaudio#input" = {
      format = " {format_source}%";
      format-source = "{volume}";
      format-source-muted = "{volume}";
      on-scroll-up = "sh -c 'vol=$(pactl get-source-volume @DEFAULT_SOURCE@ | grep -oP \"\\d+(?=%)\" | head -1); if [ \"$vol\" -lt 100 ]; then pactl set-source-volume @DEFAULT_SOURCE@ +5%; fi'";
      on-scroll-down = "pactl set-source-volume @DEFAULT_SOURCE@ -5%";
      max-volume = "100";
      on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      on-click = "pwvucontrol & aplay ~/.config/sounds/interact.wav";
      tooltip-format = "{source_desc}";
    };
  };

  style = ''
    #waybar.first #pulseaudio {
      color: #cba6f7;
    }

    #waybar.first #pulseaudio.output.muted,
    #waybar.first #pulseaudio.input.source-muted {
      color: #45475a;
    }
  '';
}
