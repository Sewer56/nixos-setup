theme: {
  config = {
    "group/wallpaper" = {
      orientation = "horizontal";
      drawer = {
        transition-duration = 300;
        children-class = "wallpaper-drawer";
        transition-left-to-right = true;
      };
      modules = [
        "custom/wallpaper-download"
        "custom/wallpaper-save"
        "custom/wallpaper-random"
        "custom/wallpaper-colour"
        "custom/wallpaper-sync"
      ];
    };

    "custom/wallpaper-download" = {
      format = "󰇚";
      tooltip-format = "Download random wallpaper from Wallhaven";
      on-click = "~/.config/waybar/scripts/wallpaper/download-random-wallpaper.py";
    };

    "custom/wallpaper-save" = {
      format = "󰆓";
      tooltip-format = "Save current wallpaper to collection";
      on-click = "~/.config/waybar/scripts/wallpaper/save-current-wallpaper.py";
    };

    "custom/wallpaper-random" = {
      format = "";
      tooltip-format = "Random favourite wallpaper";
      on-click = "~/.config/waybar/scripts/wallpaper/random-favourite-wallpaper.py";
    };

    "custom/wallpaper-colour" = {
      format = "";
      tooltip-format = "Random wallpaper matching accent color";
      on-click = "~/.config/waybar/scripts/wallpaper/random-colour-wallpaper.py";
    };

    "custom/wallpaper-sync" = {
      format = "󰑓";
      tooltip-format = "Sync favourite wallpapers collection";
      on-click = "~/.config/waybar/scripts/wallpaper/sync-wallpapers.py";
    };
  };

  style = ''
    #waybar.bar #group-wallpaper,
    #waybar.bar #custom-wallpaper-download,
    #waybar.bar #custom-wallpaper-save,
    #waybar.bar #custom-wallpaper-random,
    #waybar.bar #custom-wallpaper-colour,
    #waybar.bar #custom-wallpaper-sync,
    #waybar.bar .wallpaper-drawer {
      color: ${theme.colors.rosewater};
      padding-left: 8pt;
      padding-right: 8pt;
      padding-bottom: 4px;
      padding-top: 4px;
      background: transparent;
    }

    #waybar.bar #custom-wallpaper-download:hover,
    #waybar.bar #custom-wallpaper-save:hover,
    #waybar.bar #custom-wallpaper-random:hover,
    #waybar.bar #custom-wallpaper-colour:hover,
    #waybar.bar #custom-wallpaper-sync:hover {
      color: ${theme.colors.yellow};
      background: rgba(255, 229, 196, 0.2);
      border-radius: 4px;
    }
  '';
}
