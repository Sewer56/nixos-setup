{
  lib,
  stdenvNoCC,
  writeShellApplication,
  imagemagick,
  coreutils,
  liberation_ttf,
}: let
  fontPath = "${liberation_ttf}/share/fonts/truetype/LiberationMono-Regular.ttf";

  textThumbnailerScript = writeShellApplication {
    name = "text-thumbnailer";
    runtimeInputs = [imagemagick coreutils];
    text = ''
      export TUMBLER_TEXT_FONT="${fontPath}"
      ${builtins.readFile ./text-thumbnailer.sh}
    '';
  };
in
  stdenvNoCC.mkDerivation {
    pname = "tumbler-text-thumbnailer";
    version = "1.0.0";

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/thumbnailers
      mkdir -p $out/bin

      # Link the script to bin
      ln -s ${textThumbnailerScript}/bin/text-thumbnailer $out/bin/text-thumbnailer

      # Text thumbnailer
      cat > $out/share/thumbnailers/text.thumbnailer << EOF
      [Thumbnailer Entry]
      Version=1.0
      Encoding=UTF-8
      Type=X-Thumbnailer
      Name=Text Thumbnailer
      MimeType=text/plain;text/x-c;text/x-c++;text/x-java;text/x-python;text/x-script.python;text/x-shellscript;text/x-makefile;text/x-cmake;text/css;text/html;text/xml;text/javascript;application/json;application/x-nix;
      Exec=${textThumbnailerScript}/bin/text-thumbnailer %s %i %o
      EOF

      runHook postInstall
    '';

    meta = with lib; {
      description = "Thumbnailer for text and source code files";
      longDescription = ''
        A thumbnailer plugin for generating thumbnails of text and source code files.
        It renders the first 36 lines of text files as a preview image using ImageMagick
        and the Liberation Mono font. Supports various text formats including plain text,
        C/C++, Java, Python, shell scripts, Makefiles, CSS, HTML, XML, JavaScript, JSON,
        and Nix expressions.
      '';
      license = licenses.mit;
      platforms = platforms.linux;
    };
  }
