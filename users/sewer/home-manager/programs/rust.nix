{pkgs, ...}: {
  # Note: Using 'cross' requires 'docker'.

  # User-level Rust development environment
  home.packages = with pkgs; [
    # Rustup for toolchain management and cross-rs compatibility
    rustup

    # Additional development dependencies
    gcc # C compiler for linking (provides `cc`)
    libclang # Required for bindgen and some crates
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
