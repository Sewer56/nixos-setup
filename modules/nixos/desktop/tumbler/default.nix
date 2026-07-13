{pkgs, ...}: {
  # Thumbnail support.
  # Enable Tumbler D-Bus thumbnailer service for file manager thumbnails
  services.tumbler.enable = true;

  # Thumbnail plugins and dependencies
  environment.systemPackages = with pkgs; [
    # Image format loaders
    webp-pixbuf-loader # WebP image thumbnails
    libheif # HEIC/HEIF image thumbnails (iPhone photos)

    # Thumbnailer backends
    ffmpegthumbnailer # Video thumbnails
    poppler # PDF thumbnails (includes glib bindings)
    freetype # Font rendering for PDFs
    # f3d # 3D model thumbnails - disabled 2026-01-19, broken (VTK/openturns build failure)

    # Custom thumbnailers (from overlay)
    tumbler-dds-thumbnailer # DDS texture files
    tumbler-text-thumbnailer # Text and source code files
    tumbler-folder-thumbnailer # Folders with cover images
  ];
}
