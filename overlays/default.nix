final: prev: {
  # Override magnetic-catppuccin-gtk with our updated local package
  magnetic-catppuccin-gtk = final.callPackage ../packages/catppuccin-gtk {
    inherit (prev) lib stdenv fetchFromGitHub jdupes sassc gtk-engine-murrine;
  };

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
