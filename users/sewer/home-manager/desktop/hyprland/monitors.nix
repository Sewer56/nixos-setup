{...}: {
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
}
