{config, ...}: {
  programs.uv.enable = true;

  # Add ~/.local/bin to PATH for tools installed via `uv tool install`
  programs.zsh.initContent = ''
    # Ensure ~/.local/bin is in PATH for uv tool installs
    [[ ":$PATH:" != *":${config.home.homeDirectory}/.local/bin:"* ]] && export PATH="${config.home.homeDirectory}/.local/bin:$PATH"
  '';
}
