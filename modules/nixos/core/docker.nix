{...}: {
  # Enable Docker
  virtualisation.docker.enable = true;
  
  # Add user to docker group
  users.users.sewer.extraGroups = ["docker"];
}