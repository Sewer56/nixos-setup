{pkgs, ...}: {
  # Install nwg-displays for monitor configuration
  home.packages = with pkgs; [
    nwg-displays
  ];

  # Create monitors.conf file for nwg-displays compatibility
  wayland.windowManager.hyprland.settings = {
    # Monitor configuration
    # Samsung Odyssey G95NC ultrawide
    monitor = [
      # Format: name,resolution@rate,position,scale
      "desc:Samsung Electric Company Odyssey G95NC HNTXC00136,7680x2160@120,0x0,1.5"
      # Laptop display - AU Optronics
      "desc:AU Optronics 0x7DB2,2560x1600@240,0x0,1.33333333333"
      # Fallback for any other monitor
      ",preferred,auto,1"
    ];
  };

  # Source the monitors.conf file in Hyprland
  # Allow non-declarative overrides of monitor settings
  wayland.windowManager.hyprland.extraConfig = ''
    source = ~/.config/hypr/monitors.conf
  '';
}
