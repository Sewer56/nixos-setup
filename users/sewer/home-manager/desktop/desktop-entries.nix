{
  xdg.desktopEntries.feh = {
    name = "Feh";
    genericName = "Image viewer";
    comment = "Image viewer and cataloguer";
    exec = "feh -. --start-at %u";
    terminal = false;
    type = "Application";
    icon = "feh";
    categories = ["Graphics" "2DGraphics" "Viewer"];
    mimeType = [
      "image/bmp"
      "image/gif"
      "image/jpeg"
      "image/jpg"
      "image/pjpeg"
      "image/png"
      "image/tiff"
      "image/webp"
      "image/x-bmp"
      "image/x-pcx"
      "image/x-png"
      "image/x-portable-anymap"
      "image/x-portable-bitmap"
      "image/x-portable-graymap"
      "image/x-portable-pixmap"
      "image/x-tga"
      "image/x-xbitmap"
      "image/heic"
    ];
    noDisplay = true;
  };
}
