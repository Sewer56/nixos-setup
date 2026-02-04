{...}: {
  # Hyprsunset configuration for blue light filter
  # Config file location: ~/.config/hypr/hyprsunset.conf
  home.file.".config/hypr/hyprsunset.conf".text = ''
    # Day mode at 6:30 - normal color temperature
    profile {
        time = 6:30
        identity = true
    }

    # Night mode at 23:00 - warmer/darker
    profile {
        time = 23:00
        temperature = 4500
        gamma = 0.85
    }
  '';
}
