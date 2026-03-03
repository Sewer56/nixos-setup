{pkgs, ...}: {
  # System-wide font configuration for proper emoji rendering
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      twitter-color-emoji
      noto-fonts-cjk-sans
      inter
      jetbrains-mono
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = ["Twitter Color Emoji"];
        monospace = [
          "JetBrainsMono Nerd Font"
          "JetBrains Mono"
          "Noto Sans CJK"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans CJK"
        ];
        serif = [
          "Noto Serif"
          "Noto Sans CJK"
        ];
      };
    };
  };
}
