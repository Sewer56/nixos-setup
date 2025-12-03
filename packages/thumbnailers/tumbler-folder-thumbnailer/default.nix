{
  lib,
  stdenvNoCC,
  writeShellApplication,
  imagemagick,
  glib,
}: let
  folderThumbnailerScript = writeShellApplication {
    name = "folder-thumbnailer";
    runtimeInputs = [imagemagick glib]; # glib provides gdbus
    text = builtins.readFile ./folder-thumbnailer.sh;
  };
in
  stdenvNoCC.mkDerivation {
    pname = "tumbler-folder-thumbnailer";
    version = "1.0.0";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/thumbnailers
      mkdir -p $out/bin

      # Link the script to bin
      ln -s ${folderThumbnailerScript}/bin/folder-thumbnailer $out/bin/folder-thumbnailer

      # Folder thumbnailer (shows cover.jpg/folder.jpg as folder icon)
      cat > $out/share/thumbnailers/folder.thumbnailer << EOF
      [Thumbnailer Entry]
      Version=1.0
      Encoding=UTF-8
      Type=X-Thumbnailer
      Name=Folder Thumbnailer
      MimeType=inode/directory;
      Exec=${folderThumbnailerScript}/bin/folder-thumbnailer %s %i %o %u
      EOF

      runHook postInstall
    '';

    meta = with lib; {
      description = "Thumbnailer for folders with cover images";
      longDescription = ''
        A thumbnailer plugin for generating thumbnails of folders that contain
        cover images. It searches for cover.jpg, cover.png, cover.svg, folder.jpg,
        folder.png, or folder.svg (including hidden variants with dot prefix) in
        the folder and uses it as the folder's thumbnail. This is useful for
        music albums, photo collections, or any folder with representative cover art.
      '';
      license = licenses.mit;
      platforms = platforms.linux;
      maintainers = [];
    };
  }
