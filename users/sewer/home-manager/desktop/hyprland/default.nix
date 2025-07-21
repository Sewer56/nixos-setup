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
    ./programs/rofi/default.nix
    ./programs/notifications.nix
    ./programs/bluetooth.nix
    ./programs/screenshot.nix
    ./programs/idle-lock.nix
    ./programs/clipboard.nix
    ./programs/network.nix
  ];
}
