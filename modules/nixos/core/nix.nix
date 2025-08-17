{pkgs, ...}: {
  # Enable Flakes and nix commands
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Set trusted users
  nix.settings.trusted-users = ["root" "sewer"];

  # Auto-optimise store to save disk space
  nix.settings.auto-optimise-store = true;

  # Disable sandbox for builds
  # Needed temporarily for broken claude code package.
  nix.settings.sandbox = false;

  # Allow unsafe native code during evaluation for agenix secrets
  nix.extraOptions = ''
    allow-unsafe-native-code-during-evaluation = true
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable nix-ld for running unpatched binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;
    [
      # Needed for electron/playwright based plugins in VSCode.
      glib
      nspr
      nss
      dbus
      at-spi2-atk
      cups
      expat
      libxkbcommon
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libxcb
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      cairo
      pango
      alsa-lib

      # ld-linux-x86-64-linux.so.2 and others
      glibc

      # dotnet
      curl
      icu
      libunwind
      libuuid
      lttng-ust
      openssl
      zlib

      # mono
      krb5

      # avalonia
      fontconfig
    ]
    # Common game related binaries
    ++ (steam-run.args.multiPkgs pkgs);
}
