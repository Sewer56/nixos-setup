{...}: {
  # Hyprland Window Manager (User Configuration)
  #wayland.windowManager.hyprland = {
  #  enable = true;
    # User-specific Hyprland configuration can be added here
  #};

  # Polkit agent for privilege escalation in text editors like vscode
  services.hyprpolkitagent.enable = true;
}
