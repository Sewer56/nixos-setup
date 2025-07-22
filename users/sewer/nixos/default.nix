# NixOS-specific user configuration for sewer
# This file contains settings that only apply when running on NixOS
# For portable home-manager configuration, see ../home-manager/
{pkgs, lib, ...}: {
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.sewer = {
    isNormalUser = true;
    description = "sewer";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # Enable zsh system-wide (required for user shell)
  programs.zsh.enable = true;
  xdg.autostart.enable = lib.mkForce false;
}
