{...}: {
  imports = [
    ./settings.nix
    ./bindings.nix
    ./workspaces.nix
    ./theme.nix
    ./monitors.nix
    ./programs/waybar.nix
    ./programs/rofi.nix
    ./programs/notifications.nix
  ];
}
