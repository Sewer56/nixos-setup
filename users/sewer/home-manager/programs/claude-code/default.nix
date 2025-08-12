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
  # Link hooks directory using home-manager
  home.file.".claude/hooks".source = ./.claude/hooks;

  # https://github.com/Sewer56/claude-code-nix-flake
  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.x86_64-linux.default;
    skipBackup = true;

    # Custom commands directory
    commandsDir = ./.claude/commands;

    # Custom agents directory
    agentsDir = ./.claude/agents;

    # Settings configuration migrated from .claude/settings.json
    settingsJson = {
      model = "sonnet";

      permissions = {
        allow = [
          "WebFetch(domain:docs.anthropic.com)"
          "Bash(rm:*)"
          "WebFetch(domain:github.com)"
          "mcp__context7__resolve-library-id"
          "mcp__context7__get-library-docs"
          "mcp__filesystem__list_directory"
          "Bash(grep:*)"
          "Bash(git add:*)"
          "mcp__filesystem__edit_file"
          "mcp__filesystem__search_files"
          "Bash(mv:*)"
          "Bash(sed:*)"
          "Bash(git push:*)"
          "Bash(find:*)"
          "Bash(rg:*)"
          "Bash(git commit:*)"
          "Bash(git status:*)"
          "Bash(git diff:*)"
          "Bash(git log:*)"
          "WebFetch(domain:api.github.com)"
          "WebFetch"
          "Bash(chmod:*)"
          "Bash(mkdir:*)"
          "Bash(cp:*)"
          "Bash(ls:*)"
          "Bash(cd:*)"
          "Bash(pwd:*)"
          "Bash(echo:*)"
          "Bash(cat:*)"
          "Bash(head:*)"
          "Bash(tail:*)"
          "mcp__deepwiki__search_articles"
          "mcp__deepwiki__get_article_content"
          "mcp__deepwiki__get_article_sections"
        ];
        deny = [];
      };

      enableAllProjectMcpServers = true;

      enabledMcpjsonServers = [
        "context7"
        "mcp-deepwiki"
      ];

      hooks = {
        PreToolUse = [];
        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "python3 .claude/hooks/task_hard_prep_hook.py";
              }
            ];
          }
        ];
      };

      statusLine = {
        type = "command";
        command = "bun x ccusage statusline";
      };
    };

    # MCP server configurations
    mcpServers = {
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
