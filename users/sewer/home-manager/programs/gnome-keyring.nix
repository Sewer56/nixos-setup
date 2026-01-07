{pkgs, ...}: {
  services.gnome-keyring = {
    enable = true;
    components = ["secrets"]; # Only secrets component, not SSH/GPG agents
  };

  home.packages = with pkgs; [
    gcr # Provides gcr-prompter for unlock dialogs
    seahorse # GUI for managing keyrings
  ];
}
