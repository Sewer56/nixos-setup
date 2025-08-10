{
  pkgs,
  inputs,
  config,
  ...
}: let
  # Wrapper script to handle GitHub token at runtime instead of using impure builtins.readFile
  githubMcpWrapper = pkgs.writeShellScript "github-mcp-wrapper" ''
    #!/usr/bin/env bash

    # Read the GitHub token from the secret file at runtime
    if [ ! -f "${config.age.secrets.github-token.path}" ]; then
      echo "Error: GitHub token secret file not found at ${config.age.secrets.github-token.path}" >&2
      exit 1
    fi

    # Export the token as environment variable
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat "${config.age.secrets.github-token.path}")"

    # Execute the original docker command with all arguments passed to this script
    exec docker "$@"
  '';
in {
  # https://github.com/Sewer56/claude-code-nix-flake
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.x86_64-linux.default;

    # Basic settings migrated from ~/.claude/settings.json
    settingsJson = {
      model = "sonnet";
      feedbackSurveyState = {
        lastShownTime = 1754711712382;
      };
    };

    # MCP server configurations
    mcpServers = {
      mcp-nixos = {
        type = "stdio";
        command = "nix";
        args = ["run" "github:utensils/mcp-nixos" "--"];
        env = {};
      };
      github = {
        type = "stdio";
        command = "${githubMcpWrapper}";
        args = [
          "run"
          "-i"
          "--rm"
          "-e"
          "GITHUB_PERSONAL_ACCESS_TOKEN"
          "ghcr.io/github/github-mcp-server"
        ];
        env = {};
      };
    };
  };
}
