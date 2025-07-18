# User Module for Me (sewer)
# This defines my user profile, home-manager setup, and everything else
{inputs, ...}: {
  imports = [
    # Import home-manager, and friends
    inputs.home-manager.nixosModules.default
    ./packages.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sewer = {
    isNormalUser = true;
    description = "sewer";
    extraGroups = ["networkmanager" "wheel"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "sewer" = import ./home.nix;
    };
  };
}
