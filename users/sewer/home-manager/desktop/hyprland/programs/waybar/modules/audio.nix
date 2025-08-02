semantic: {
  config = {
    "group/audio" = {
      orientation = "horizontal";
      drawer = {
        transition-duration = 300;
        children-class = "audio-drawer";
        transition-left-to-right = true;
      };
      modules = [
        "pulseaudio#output"
        "pulseaudio#input"
      ];
    };

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
      scroll-step = 0.1;
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
    #waybar.bar #group-audio,
    #waybar.bar #pulseaudio,
    #waybar.bar .audio-drawer {
      color: ${semantic.audio};
    }

    #waybar.bar #pulseaudio.output.muted,
    #waybar.bar #pulseaudio.input.source-muted {
      color: ${semantic.border};
    }
  '';
}
