{
  pkgs,
  config,
  inputs,
  ...
}: let
  opencodeBin = "/home/sewer/Project/opencode/packages/opencode/dist/opencode-linux-x64/bin/opencode";
  opencodeScript = pkgs.writeShellScriptBin "opencode" ''
    if [ "$#" -eq 0 ]; then
      exec ${opencodeBin} .
    else
      exec ${opencodeBin} "$@"
    fi
  '';
  opencodeBuildScript = pkgs.writeShellScriptBin "opencode-build" ''
    set -euo pipefail
    pushd /home/sewer/Project/opencode/packages/opencode > /dev/null
    bun install
    bun run build --single
    popd > /dev/null
    chmod -R +x /home/sewer/Project/opencode/packages/opencode/dist/opencode-linux-x64/bin
  '';
in {
  # Install OpenCode from the dedicated flake
  home.packages = with pkgs; [
    # OpenCode from the flake
    # inputs.opencode-flake.packages.${pkgs.system}.default

    opencodeScript
    opencodeBuildScript
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.coderabbit-cli

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
