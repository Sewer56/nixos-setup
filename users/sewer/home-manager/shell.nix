{config, ...}: let
  colors = config.lib.catppuccin.colors;
in {
  home.shell.enableZshIntegration = true;

  # Zsh configuration with oh-my-zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;

    # Enable syntax highlighting with Catppuccin colors
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
        "globbing" = "fg=${colors.yellow}";
        "history-expansion" = "fg=${colors.mauve}";
        "command-substitution" = "fg=${colors.text}";
        "command-substitution-delimiter" = "fg=${colors.overlay0}";
        "process-substitution" = "fg=${colors.text}";
        "process-substitution-delimiter" = "fg=${colors.overlay0}";
        "single-hyphen-option" = "fg=${colors.yellow}";
        "double-hyphen-option" = "fg=${colors.yellow}";
        "back-quoted-argument" = "fg=${colors.green}";
        "single-quoted-argument" = "fg=${colors.green}";
        "double-quoted-argument" = "fg=${colors.green}";
        "dollar-quoted-argument" = "fg=${colors.green}";
        "rc-quote" = "fg=${colors.green}";
        "dollar-double-quoted-argument" = "fg=${colors.peach}";
        "back-double-quoted-argument" = "fg=${colors.peach}";
        "back-dollar-quoted-argument" = "fg=${colors.peach}";
        "assign" = "fg=${colors.text}";
        "redirection" = "fg=${colors.yellow}";
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
