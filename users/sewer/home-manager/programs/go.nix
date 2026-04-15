{pkgs, ...}: {
  # Go development environment
  home.packages = with pkgs; [
    go
    gopls
  ];
}
