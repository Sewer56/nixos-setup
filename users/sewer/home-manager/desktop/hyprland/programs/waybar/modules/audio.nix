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
      on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      on-click = "~/.config/waybar/scripts/launch-audio-control.sh";
      tooltip = true;
      scroll-step = 5;
    };

    "pulseaudio#input" = {
      format = " {format_source}%";
      format-source = "{volume}";
      format-source-muted = "{volume}";
      on-scroll-up = "~/.config/waybar/scripts/audio-input-volume-up.sh";
      on-scroll-down = "~/.config/waybar/scripts/audio-input-volume-down.sh";
      max-volume = "100";
      on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      on-click = "~/.config/waybar/scripts/launch-audio-control.sh";
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
