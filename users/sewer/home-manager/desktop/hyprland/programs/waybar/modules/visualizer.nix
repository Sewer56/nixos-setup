theme: {
  config = {
    cava = {
      framerate = 60;
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
      monstercat = true;
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
    };
  };

  style = ''
    #waybar.bar #cava {
      font-size: 18pt;
      /* Sink the bar into the border, so 100% audio doesn't cover whole bar. */
      margin-bottom: -10px;
      color: ${theme.colors.border};
    }
  '';
}
