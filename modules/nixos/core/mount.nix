{...}: {
  # Automatic USB mounting services
  services.udisks2 = {
    enable = true;
    mountOnMedia = false; # Use default /run/media/$USER/ for better ACL support
  };

  # Virtual filesystem support for desktop integration
  services.gvfs.enable = true;
}
