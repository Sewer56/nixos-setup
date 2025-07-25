{
  pkgs,
  config,
  ...
}: let
  colors = config.lib.catppuccin.colors;
  inherit (config.lib.catppuccin.helpers) hexToRgb;
in {
  # Idle management and screen locking for Hyprland
  home.packages = with pkgs; [
    hypridle # Idle daemon for Hyprland
  ];

  # Configure hypridle for automatic locking
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        {
          timeout = 300; # 5 minutes
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      # Lock screen manually
      "$mod, Escape, exec, hyprlock"
    ];
  };

  # Configure hyprlock with Home Manager module
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };

      # Background with screenshot blur
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 1;
        color = hexToRgb colors.base;
      };

      # Time display
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = hexToRgb colors.text;
          font_size = 270;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
        # Date display
        {
          monitor = "";
          text = "cmd[update:43200000] date +'%A, %d %B %Y'";
          color = hexToRgb colors.text;
          font_size = 45;
          font_family = "JetBrains Mono Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];

      # User avatar
      image = {
        monitor = "";
        path = "$HOME/.face";
        size = 100;
        border_color = hexToRgb colors.${config.catppuccin.accent};
        position = "0, 75";
        halign = "center";
        valign = "center";
      };

      # Password input field
      input-field = {
        monitor = "";
        size = "600, 120";
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = hexToRgb colors.${config.catppuccin.accent};
        inner_color = hexToRgb colors.surface0;
        font_color = hexToRgb colors.text;
        fade_on_empty = false;
        placeholder_text = "<span foreground='#${colors.text}cc'><i>󰌾 Logged in as </i><span foreground='#${colors.${config.catppuccin.accent}}cc'>$USER</span></span>";
        hide_input = false;
        check_color = hexToRgb colors.${config.catppuccin.accent};
        fail_color = hexToRgb colors.red;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = hexToRgb colors.yellow;
        position = "0, -94";
        halign = "center";
        valign = "center";
      };
    };
  };
}
