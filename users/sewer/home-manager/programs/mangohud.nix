{pkgs, ...}: {
  home.packages = with pkgs; [
    goverlay
    mangohud
  ];
}
