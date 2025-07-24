{
  config = {
    "custom/spacer1" = {
      format = " \\\\ ";
      tooltip = false;
    };

    "custom/spacer2" = {
      format = " ";
      tooltip = false;
    };

    "custom/spacer3" = {
      format = " // ";
      tooltip = false;
    };

    cava = {
      framerate = 45;
      autosens = 1;
      bars = 24;
      lower_cutoff_freq = 50;
      higher_cutoff_freq = 20000;
      method = "pipewire";
      source = "auto";
      stereo = false;
      bar_delimiter = 0;
      noise_reduction = 0.25;
      input_delay = 0;
      hide_on_silence = true;
      format-icons = [
        "▁"
        "▂"
        "▃"
        "▄"
        "▅"
        "▆"
        "▇"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
        "█"
      ];
      actions = {
        on-click-right = "mode";
      };
    };
  };

  style = ''
    #waybar.bar #custom-spacer1,
    #waybar.bar #custom-spacer2,
    #waybar.bar #custom-spacer3 {
      font-size: 10pt;
      font-weight: bold;
      color: #45475a;
      background: transparent;
    }

    #waybar.bar #cava {
      font-size: 18pt;
      margin-bottom: -10px;
      color: #45475a;
    }
  '';
}
