final: prev: {
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
}
