final: prev: {
  # hplip pulls python3Packages.pyqt5, which fails to build on python 3.14
  # ("ABI v12 is being targeted but the PyQt5.QtCore module doesn't support it").
  # withQt5 only gates the hp-toolbox GUI; printing/scanning/fax CLI is unaffected.
  hplip = prev.hplip.override {withQt5 = false;};
  hplipWithPlugin = prev.hplipWithPlugin.override {withQt5 = false;};

  # Override heaptrack with rustc-demangle support for Rust symbol demangling
  # rustc_demangle is a runtime dependency loaded via dlopen()
  # - Qt apps (heaptrack_gui, heaptrack_print) are wrapped via qtWrapperArgs
  # - heaptrack_interpret (non-Qt) must be wrapped separately in postFixup
  heaptrack = prev.heaptrack.overrideAttrs (oldAttrs: {
    qtWrapperArgs =
      (oldAttrs.qtWrapperArgs or [])
      ++ [
        "--prefix LD_LIBRARY_PATH : ${prev.rustc-demangle}/lib"
      ];
    postFixup =
      (oldAttrs.postFixup or "")
      + ''
        wrapProgram $out/lib/heaptrack/libexec/heaptrack_interpret \
          --prefix LD_LIBRARY_PATH : ${prev.rustc-demangle}/lib
      '';
  });

  # Carry a pending grim fractional-scaling fix from grim-dev.
  # Original patch: https://lists.sr.ht/~emersion/grim-dev/patches/56912
  grim = prev.grim.overrideAttrs (oldAttrs: {
    patches =
      (oldAttrs.patches or [])
      ++ [
        ./patches/grim-render-geometry-space.patch
      ];
  });

  # Override magnetic-catppuccin-gtk with our updated local package
  magnetic-catppuccin-gtk = final.callPackage ../packages/catppuccin-gtk {
    inherit (prev) lib stdenv fetchFromGitHub jdupes sassc;
  };

  # Worktree manager
  wt = final.callPackage ../packages/wt/default.nix {};

  # Thumbnailer packages
  tumbler-dds-thumbnailer = final.callPackage ../packages/thumbnailers/tumbler-dds-thumbnailer/default.nix {};
  tumbler-text-thumbnailer = final.callPackage ../packages/thumbnailers/tumbler-text-thumbnailer/default.nix {};
  tumbler-folder-thumbnailer = final.callPackage ../packages/thumbnailers/tumbler-folder-thumbnailer/default.nix {};

  pythonPackagesExtensions =
    prev.pythonPackagesExtensions
    ++ [
      (python-final: python-prev: {
        # Workaround for bug #437058
        i3ipc = python-prev.i3ipc.overridePythonAttrs (oldAttrs: {
          doCheck = false;
          checkPhase = ''
            echo "Skipping pytest in Nix build"
          '';
          installCheckPhase = ''
            echo "Skipping install checks in Nix build"
          '';
        });
      })
    ];
}
