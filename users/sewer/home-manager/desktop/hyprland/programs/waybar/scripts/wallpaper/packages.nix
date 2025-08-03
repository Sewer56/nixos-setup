{pkgs, ...}: {
  # Wallpaper-specific packages
  home.packages = with pkgs; [
    # Python environment for wallpaper color analysis
    (python3.withPackages (ps:
      with ps; [
        pillow
        scikit-image
        colormath
        scikit-learn
        numpy
      ]))
  ];
}
