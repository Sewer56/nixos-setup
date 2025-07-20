{pkgs, ...}: {
  # Install nwg-displays for monitor configuration
  home.packages = with pkgs; [
    nwg-displays
  ];

  # Create empty monitors.conf if it doesn't exist
  # This allows for non-declarative monitor configuration
  home.activation.createMonitorsConf = ''
    MONITORS_CONF="$HOME/.config/hypr/monitors.conf"
    if [ ! -f "$MONITORS_CONF" ]; then
      run echo "Creating empty monitors.conf at $MONITORS_CONF"
      run mkdir -p "$(dirname "$MONITORS_CONF")"
      run touch "$MONITORS_CONF"
    fi
  '';

  # Source the monitors.conf file in Hyprland
  # Allow non-declarative overrides of monitor settings
  wayland.windowManager.hyprland.extraConfig = ''
    source = ~/.config/hypr/monitors.conf
  '';
}
