{...}: {
  imports = [
    ./settings.nix
    ./bindings.nix
    ./workspaces.nix
    ./theme.nix
    ./plugins.nix
    ./monitors.nix
    ./input.nix
    ./programs/waybar.nix
    ./programs/rofi.nix
    ./programs/notifications.nix
  ];
}
