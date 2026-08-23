{pkgs, ...}: {
  # Note: Using 'cross' requires 'docker'.

  # User-level Rust development environment
  home.packages = with pkgs; [
    # Rustup for toolchain management and cross-rs compatibility
    rustup
    cargo-public-api

    # Additional development dependencies
    clang_multi # C compiler for linking (provides `cc`)
    # libclang.lib: bindgen only needs the library (LIBCLANG_PATH below).
    # Plain 'libclang' would leak the whole clang toolset (incl. an unwrapped
    # clangd) onto PATH; clangd now comes from clang-tools in packages.nix.
    libclang.lib # Required for bindgen and some crates
    pkg-config # Required for linking system libraries
  ];

  # Environment variables for Rust development
  home.sessionVariables = {
    # Required for bindgen and native dependencies
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    PKG_CONFIG_PATH = "${pkgs.pkg-config}/lib/pkgconfig";
  };

  home.sessionPath = [
    # Add cargo installed binaries to PATH
    "$HOME/.cargo/bin"
  ];
}
