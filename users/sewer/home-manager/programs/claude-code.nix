{
  inputs,
  config,
  ...
}: {
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
        command = "docker";
        args = [
          "run"
          "-i"
          "--rm"
          "-e"
          "GITHUB_PERSONAL_ACCESS_TOKEN"
          "ghcr.io/github/github-mcp-server"
        ];
        env = {
          # Dangerous!! But there's no other choice for now.
          GITHUB_PERSONAL_ACCESS_TOKEN = "$(cat ${config.age.secrets.github-token.path})";
        };
      };
    };
  };
}
