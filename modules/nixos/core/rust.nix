{pkgs, ...}: {
  # System-wide Rust toolchain with nightly channel
  environment.systemPackages = with pkgs; [
    # Rust nightly toolchain with comprehensive components
    (rust-bin.selectLatestNightlyWith (toolchain:
      toolchain.default.override {
        # Essential Rust components
        extensions = [
          "rust-src" # Source code for rust-analyzer and documentation
          "rust-analyzer" # Language server for IDE support
          "rustfmt" # Code formatter
          "clippy" # Linter and additional checks
          "rust-docs" # Offline documentation
        ];

        # Cross-compilation targets
        targets = [
          "x86_64-unknown-linux-gnu" # Default Linux target
          "aarch64-unknown-linux-gnu" # ARM64 Linux
          "wasm32-unknown-unknown" # WebAssembly
        ];
      }))

    # Rustup for toolchain management and cross-rs compatibility
    rustup

    # Additional development dependencies
    gcc # C compiler for linking (provides `cc`)
    libclang # Required for bindgen and some crates
    pkg-config # Required for linking system libraries
  ];

  # Environment variables for Rust development
  environment.variables = {
    # Required for bindgen and native dependencies
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
    PKG_CONFIG_PATH = "${pkgs.pkg-config}/lib/pkgconfig";
  };
}
