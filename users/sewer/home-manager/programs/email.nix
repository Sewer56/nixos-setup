{pkgs, ...}: {
  # Email client package
  home.packages = with pkgs; [
    protonmail-desktop
  ];

  # Enable email account management infrastructure
  accounts.email = {
    # Email accounts are stored in Proton Mail desktop app
    # This section enables the email infrastructure in Home Manager
    accounts = {
      # Placeholder - accounts will be managed by Proton Mail desktop
    };
  };

  # Note: Proton Mail desktop app handles email account management directly
  # Accounts are stored within the desktop app, not in Home Manager configuration
}