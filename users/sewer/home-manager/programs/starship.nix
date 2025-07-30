{config, ...}: let
  colors = config.lib.theme.colors;
  semantic = config.lib.theme.semantic;
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Main prompt format
      format = "$all$character";

      # Right prompt format
      right_format = "$cmd_duration$time";

      # Add a new line before each prompt
      add_newline = false;

      # Character prompt
      character = {
        success_symbol = "[❯](${colors.green})";
        error_symbol = "[❯](${colors.red})";
        vimcmd_symbol = "[❮](${colors.lavender})";
      };

      # Directory
      directory = {
        style = "bold ${colors.blue}";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      # Git branch
      git_branch = {
        style = "bold ${colors.mauve}";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
      };

      # Git status
      git_status = {
        style = "bold ${semantic.command}";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = "!";
        staged = "+";
        untracked = "?";
        deleted = "✘";
        renamed = "»";
        stashed = "\\$";
      };

      # Time
      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "bold ${colors.overlay0}";
        time_format = "%H:%M";
      };

      # Command duration
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bold ${semantic.command}";
        min_time = 500;
        show_milliseconds = true;
      };

      # Programming languages with theme colors
      nix_shell = {
        symbol = "❄️ ";
        style = "bold ${colors.blue}";
        format = "[$symbol$state( \\($name\\))]($style) ";
      };

      python = {
        symbol = "🐍 ";
        style = "bold ${colors.green}";
        format = "[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style) ";
      };

      nodejs = {
        symbol = "⬢ ";
        style = "bold ${colors.green}";
        format = "[$symbol($version)]($style) ";
      };

      rust = {
        symbol = "🦀 ";
        style = "bold ${colors.red}";
        format = "[$symbol($version)]($style) ";
      };

      # Package
      package = {
        symbol = "📦 ";
        style = "bold ${semantic.contentHighlight}";
        format = "[$symbol$version]($style) ";
      };

      # Memory usage
      memory_usage = {
        disabled = false;
        threshold = 70;
        style = "bold ${colors.red}";
        format = "[$symbol\${ram_pct}]($style) ";
        symbol = "🐏 ";
      };

      # Battery
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "🪫 ";
        display = [
          {
            threshold = 10;
            style = "bold ${colors.red}";
          }
          {
            threshold = 20;
            style = "bold ${semantic.warning}";
          }
        ];
      };

      # Container
      container = {
        symbol = "⬢ ";
        style = "bold ${colors.red} dimmed";
        format = "[$symbol\\[$name\\]]($style) ";
      };

      # Username
      username = {
        show_always = false;
        style_user = "bold ${colors.lavender}";
        style_root = "bold ${colors.red}";
        format = "[$user]($style) ";
      };

      # Hostname
      hostname = {
        ssh_only = true;
        style = "bold ${colors.green}";
        format = "[@$hostname]($style) ";
      };
    };
  };
}
