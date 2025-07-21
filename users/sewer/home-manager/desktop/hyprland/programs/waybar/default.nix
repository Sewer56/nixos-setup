{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  xdg.configFile = {
    "waybar/config.jsonc".source = ./waybar.jsonc;
    "waybar/style.css".source = ./waybar.css;
    "waybar/bat-pp.sh" = {
      source = ./bat-pp.sh;
      executable = true;
    };
    "waybar/nvidia.sh" = {
      source = ./nvidia.sh;
      executable = true;
    };
  };
}
