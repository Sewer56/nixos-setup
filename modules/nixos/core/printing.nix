{pkgs, ...}: {
  # Enable CUPS printing service
  services.printing = {
    enable = true;

    # Add printer drivers
    drivers = with pkgs; [
      splix # Samsung M2070 (SPL - Samsung Printer Language)
      gutenprint # Generic drivers for many printer brands
      hplip # HP printers (print, scan, fax)
      cups-filters # Additional filters
    ];
  };

  # Enable printer discovery on the network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable GUI printer management tool
  programs.system-config-printer.enable = true;
}
