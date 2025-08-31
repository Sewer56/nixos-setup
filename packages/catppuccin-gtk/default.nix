{
  lib,
  stdenv,
  fetchFromGitHub,
  jdupes,
  sassc,
  gtk-engine-murrine,
  themeName ? "Catppuccin",
  accent ? ["blue"],
  shade ? "dark",
  size ? "standard",
  tweaks ? [],
}: let
  pname = "catppuccin-gtk-theme";
in
  lib.checkListOfEnum "${pname}: accent variants" ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender" "all"] accent
  lib.checkListOfEnum "${pname}: shade variants" ["light" "dark"] [shade]
  lib.checkListOfEnum "${pname}: size variants" ["standard" "compact"] [size]
  lib.checkListOfEnum "${pname}: tweak variants" ["frappe" "macchiato" "black" "float" "outline" "macos"]
  tweaks
  stdenv.mkDerivation {
    pname = "catppuccin-gtk-theme";
    version = "1.0.3";

    src = fetchFromGitHub {
      owner = "Fausto-Korpsvart";
      repo = "Catppuccin-GTK-Theme";
      rev = "7b94b62bdc15596c0fc0ae1a711d0f733575c64f";
      hash = "sha256-D1RL3WkxJYxZTu/WE0V9Adb9F7ZaPzfFVUtJrwVuc/c=";
    };

    nativeBuildInputs = [
      jdupes
      sassc
    ];

    buildInputs = [
      gtk-engine-murrine
    ];

    dontBuild = true;

    postPatch = ''
      patchShebangs themes/install.sh
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/themes

      themes/install.sh \
        --dest $out/share/themes \
        --name "${themeName}" \
        ${lib.optionalString (accent != []) "--theme " + builtins.concatStringsSep "," accent} \
        --color ${shade} \
        --size ${size} \
        ${lib.optionalString (tweaks != []) "--tweaks " + builtins.concatStringsSep "," tweaks}

      # Use jdupes to link duplicate files
      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel theme for GTK with Catppuccin colour scheme";
      homepage = "https://github.com/Fausto-Korpsvart/Catppuccin-GTK-Theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [icy-thought];
    };
  }
