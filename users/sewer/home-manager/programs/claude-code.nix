{inputs, ...}: {
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.x86_64-linux.default;
  };
}
