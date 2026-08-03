{pkgs, ...}: {
  # User-level Ruby development environment
  home.packages = with pkgs; [
    ruby
  ];

  home.sessionPath = [
    # Ruby gem user-install bin dir (e.g. ruby-lsp, rubocop) isn't on PATH by default.
    "$HOME/.local/share/gem/ruby/${pkgs.ruby.version.libDir}/bin"
  ];
}
