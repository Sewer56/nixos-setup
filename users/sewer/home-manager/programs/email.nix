{pkgs, ...}: {
  # Email client package
  home.packages = with pkgs; [
    protonmail-desktop
  ];
}
