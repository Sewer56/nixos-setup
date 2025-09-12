{pkgs, ...}: {
  home.packages = with pkgs; [
    tidal-hifi
    spotify
  ];
}
