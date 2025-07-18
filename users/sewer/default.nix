# User Module for Me (sewer)
# This defines my user profile, home-manager setup, and everything else
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Import home-manager, and friends
    inputs.home-manager.nixosModules.default
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sewer = {
    isNormalUser = true;
    description = "sewer";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "sewer" = import ./home-manager/default.nix;
    };
  };
}
