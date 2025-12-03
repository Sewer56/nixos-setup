{
  lib,
  stdenvNoCC,
  writeShellApplication,
  imagemagick,
  coreutils,
}: let
  ddsThumbnailerScript = writeShellApplication {
    name = "dds-thumbnailer";
    runtimeInputs = [imagemagick coreutils];
    text = builtins.readFile ./dds-thumbnailer.sh;
  };
in
  stdenvNoCC.mkDerivation {
    pname = "tumbler-dds-thumbnailer";
    version = "1.0.0";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/thumbnailers
      mkdir -p $out/share/mime/packages
      mkdir -p $out/bin

      # Link the script to bin
      ln -s ${ddsThumbnailerScript}/bin/dds-thumbnailer $out/bin/dds-thumbnailer

      # DDS thumbnailer
      cat > $out/share/thumbnailers/dds.thumbnailer << EOF
      [Thumbnailer Entry]
      Version=1.0
      Encoding=UTF-8
      Type=X-Thumbnailer
      Name=DDS Thumbnailer
      MimeType=image/x-dds;image/vnd-ms.dds;
      Exec=${ddsThumbnailerScript}/bin/dds-thumbnailer %s %i %o
      EOF

      # DDS MIME type registration
      cat > $out/share/mime/packages/dds.xml << EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
        <mime-type type="image/x-dds">
          <comment>DirectDraw Surface image</comment>
          <icon name="image"/>
          <glob-deleteall/>
          <glob pattern="*.dds"/>
          <glob pattern="*.DDS"/>
        </mime-type>
      </mime-info>
      EOF

      runHook postInstall
    '';

    meta = with lib; {
      description = "Thumbnailer for DirectDraw Surface (DDS) images";
      longDescription = ''
        A thumbnailer plugin for generating thumbnails of DDS (DirectDraw Surface)
        image files. DDS is a container format commonly used for textures in games
        and 3D applications. This thumbnailer uses ImageMagick for conversion and
        includes MIME type registration for DDS files.
      '';
      license = licenses.mit;
      platforms = platforms.linux;
    };
  }
