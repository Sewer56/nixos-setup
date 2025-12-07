{
  pkgs,
  config,
  inputs,
  ...
}: {
  # Install OpenCode from the dedicated flake
  home.packages = with pkgs; [
    # OpenCode from the flake
    # inputs.opencode-flake.packages.${pkgs.system}.default

    # Dependencies for MCP servers
    nodejs
    yarn
    docker
    # TypeScript for plugin development
    typescript
    # Bun for local development
    bun
    # Go for local development
    go
  ];

  # Symlink our configuration files to OpenCode's expected locations
  home.file = {
    ".config/opencode/opencode.json".source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/opencode/config/opencode.json";
    ".config/opencode/command".source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/opencode/config/command";
    ".config/opencode/agent".source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/opencode/config/agent";
    ".config/opencode/plugin".source = config.lib.file.mkOutOfStoreSymlink "/home/sewer/nixos/users/sewer/home-manager/programs/opencode/config/plugin";
  };
}
