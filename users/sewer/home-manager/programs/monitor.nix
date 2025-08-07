{pkgs, ...}: {
  programs.btop = {
    enable = true;
    package = pkgs.btop.override {
      cudaSupport = true;
    };
    settings = {
      update_ms = 500;
    };
  };
}
