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
  # Ensure hooks dependencies are always available
  home.packages = with pkgs; [
    nodejs
    # and python, but that fails my build due to conflict with some OS thing
  ];

  # Link ccstatusline config from our managed location
  home.file.".config/ccstatusline".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/users/sewer/home-manager/programs/claude-code/.config/ccstatusline";

  programs.claude-code = {
    enable = true;
    package = inputs.claude-code.packages.x86_64-linux.default;

    commandsDir = ./.claude/commands;
    agentsDir = ./.claude/agents;
    hooksDir = ./.claude/hooks;

    # Settings configuration migrated from .claude/settings.json
    settings = {
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
          "mcp__deepwiki__read_wiki_structure"
          "mcp__deepwiki__read_wiki_contents"
          "mcp__deepwiki__ask_question"
        ];
        deny = [];
      };

      enableAllProjectMcpServers = true;

      enabledMcpjsonServers = [
        "context7"
        "deepwiki"
      ];

      hooks = {
        PreToolUse = [];
        UserPromptSubmit = [
          {
            hooks = [
              {
                type = "command";
                command = "python3 /home/sewer/.claude/hooks/task_hard_prep_hook.py";
              }
            ];
          }
        ];
      };

      statusLine = {
        type = "command";
        command = "npx ccstatusline@latest";
        padding = 0;
      };
    };

    # MCP server configurations
    mcpServers = {
      # github = {
      #   type = "stdio";
      #   command = "${githubMcpWrapper}";
      #   args = [
      #     "run"
      #     "-i"
      #     "--rm"
      #     "-e"
      #     "GITHUB_PERSONAL_ACCESS_TOKEN"
      #     "ghcr.io/github/github-mcp-server"
      #   ];
      #   env = {};
      # };

      context7 = {
        type = "stdio";
        command = "npx";
        args = ["-y" "@upstash/context7-mcp"];
        env = {};
      };
    };
  };
}
