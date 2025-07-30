{
  pkgs,
  config,
  ...
}: let
  semantic = config.lib.theme.semantic;
  inherit (config.lib.theme.helpers) hexToRgbHyprland;
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
        color = hexToRgbHyprland semantic.background;
      };

      # Time display
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = hexToRgbHyprland semantic.text;
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
          color = hexToRgbHyprland semantic.text;
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
        border_color = hexToRgbHyprland semantic.accent;
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
        outer_color = hexToRgbHyprland semantic.accent;
        inner_color = hexToRgbHyprland semantic.surface0;
        font_color = hexToRgbHyprland semantic.text;
        fade_on_empty = false;
        placeholder_text = "<span foreground='#${semantic.text}cc'><i>󰌾 Logged in as </i><span foreground='#${semantic.accent}cc'>$USER</span></span>";
        hide_input = false;
        check_color = hexToRgbHyprland semantic.accent;
        fail_color = hexToRgbHyprland semantic.error;
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = hexToRgbHyprland semantic.warning;
        position = "0, -94";
        halign = "center";
        valign = "center";
      };
    };
  };
}
