{pkgs, ...}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # nix development tools
    nixd # language server
    alejandra # formatter

    # NFS utilities
    nfs-utils
  ];
}
