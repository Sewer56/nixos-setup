{config, ...}: let
  colors = config.lib.theme.colors;
  semantic = config.lib.theme.semantic;
in {
  home.shell.enableZshIntegration = true;

  # Zsh configuration with oh-my-zsh
  programs.zsh = {
    enable = true;

    # Enable syntax highlighting with theme colors
    syntaxHighlighting = {
      enable = true;
      styles = {
        # Main syntax highlighting styles
        "default" = "fg=${colors.text}";
        "unknown-token" = "fg=${colors.red}";
        "reserved-word" = "fg=${colors.mauve}";
        "suffix-alias" = "fg=${colors.green}";
        "global-alias" = "fg=${colors.green}";
        "precommand" = "fg=${colors.green}";
        "commandseparator" = "fg=${colors.overlay0}";
        "autodirectory" = "fg=${colors.blue}";
        "path" = "fg=${colors.blue}";
        "path_pathseparator" = "fg=${colors.overlay0}";
        "path_prefix" = "fg=${colors.blue}";
        "globbing" = "fg=${semantic.command}";
        "history-expansion" = "fg=${colors.mauve}";
        "command-substitution" = "fg=${colors.text}";
        "command-substitution-delimiter" = "fg=${colors.overlay0}";
        "process-substitution" = "fg=${colors.text}";
        "process-substitution-delimiter" = "fg=${colors.overlay0}";
        "single-hyphen-option" = "fg=${semantic.command}";
        "double-hyphen-option" = "fg=${semantic.command}";
        "back-quoted-argument" = "fg=${colors.green}";
        "single-quoted-argument" = "fg=${colors.green}";
        "double-quoted-argument" = "fg=${colors.green}";
        "dollar-quoted-argument" = "fg=${colors.green}";
        "rc-quote" = "fg=${colors.green}";
        "dollar-double-quoted-argument" = "fg=${semantic.contentHighlight}";
        "back-double-quoted-argument" = "fg=${semantic.contentHighlight}";
        "back-dollar-quoted-argument" = "fg=${semantic.contentHighlight}";
        "assign" = "fg=${colors.text}";
        "redirection" = "fg=${semantic.command}";
        "comment" = "fg=${colors.overlay0}";
        "named-fd" = "fg=${colors.text}";
        "numeric-fd" = "fg=${colors.text}";
        "arg0" = "fg=${colors.text}";
      };
    };

    oh-my-zsh = {
      enable = true;
      # Use minimal theme since Starship will handle the prompt
      theme = "";
      plugins = [
        "history-substring-search"
        "colored-man-pages"
        "command-not-found"
      ];
    };

    # Configure autosuggestion colors
    autosuggestion = {
      enable = true;
      highlight = "fg=${colors.overlay0}";
    };

    # Configure history substring search colors and completion colors
    sessionVariables = {
      # History substring search highlighting
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND = "bg=${colors.surface1},fg=${semantic.highlight},bold";
      HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND = "bg=${colors.surface1},fg=${colors.red},bold";

      # Zsh completion colors - make them more visible
      LS_COLORS = "di=${colors.blue}:ln=${colors.teal}:ex=${colors.green}";
    };

    # Additional zsh configuration for better completion colors
    localVariables = {
      # Configure completion list colors
      ZLS_COLORS = "\${LS_COLORS}";
    };

    # Custom initialization for completion styling
    initContent = ''
      # Configure zsh completion menu colors
      zstyle ':completion:*' list-colors "\''${(s.:.)LS_COLORS}"
      zstyle ':completion:*:default' list-colors "\''${(s.:.)LS_COLORS}"

      # Highlight the current selection in completion menu
      zstyle ':completion:*' menu select
      zstyle ':completion:*:*:*:*:*' menu select

      # Use Catppuccin colors for completion menu
      zstyle ':completion:*:matches' group 'yes'
      zstyle ':completion:*:options' description 'yes'
      zstyle ':completion:*:options' auto-description '%d'
      zstyle ':completion:*:corrections' format ' %F{${colors.green}}-- %d (errors: %e) --%f'
      zstyle ':completion:*:descriptions' format ' %F{${semantic.highlight}}-- %d --%f'
      zstyle ':completion:*:messages' format ' %F{${colors.mauve}}-- %d --%f'
      zstyle ':completion:*:warnings' format ' %F{${colors.red}}-- no matches found --%f'
      zstyle ':completion:*:default' list-prompt '%S%M matches%s'

      # Highlight selected completion with contrasting colors
      zstyle ':completion:*' list-colors 'ma=48;5;67;38;5;15'  # Use surface2 background with text foreground

      # Fix history substring search colors
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=8,fg=11,bold'     # surface1 bg, yellow fg
      export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=8,fg=9,bold'  # surface1 bg, red fg

    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sewer/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
