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
        "custom/wallpaper-random"
        "custom/wallpaper-favourite"
        "custom/wallpaper-colour"
        "custom/wallpaper-startup"
      ];
    };

    "custom/wallpaper-random" = {
      format = "󰸉";
      tooltip-format = "Random wallpaper from Wallhaven collection";
      on-click = "~/.config/waybar/scripts/wallpaper/random-wallpaper.py";
    };

    "custom/wallpaper-favourite" = {
      format = "󰋩";
      tooltip-format = "Favourite wallpaper (TBD)";
      on-click = "~/.config/waybar/scripts/wallpaper/favourite-wallpaper.py";
    };

    "custom/wallpaper-colour" = {
      format = "󰌈";
      tooltip-format = "Favourite colour wallpaper (TBD)";
      on-click = "~/.config/waybar/scripts/wallpaper/favourite-colour-wallpaper.py";
    };

    "custom/wallpaper-startup" = {
      format = "󰑓";
      tooltip-format = "Sync favourite wallpapers (wallhaven)";
      on-click = "~/.config/waybar/scripts/wallpaper/startup-wallpaper.py";
    };
  };

  style = ''
    #waybar.bar #group-wallpaper,
    #waybar.bar #custom-wallpaper-random,
    #waybar.bar #custom-wallpaper-favourite,
    #waybar.bar #custom-wallpaper-colour,
    #waybar.bar #custom-wallpaper-startup,
    #waybar.bar .wallpaper-drawer {
      color: ${theme.colors.rosewater};
      padding-left: 8pt;
      padding-right: 8pt;
      padding-bottom: 4px;
      padding-top: 4px;
      background: transparent;
    }

    #waybar.bar #custom-wallpaper-random:hover,
    #waybar.bar #custom-wallpaper-favourite:hover,
    #waybar.bar #custom-wallpaper-colour:hover,
    #waybar.bar #custom-wallpaper-startup:hover {
      color: ${theme.colors.yellow};
      background: rgba(255, 229, 196, 0.2);
      border-radius: 4px;
    }
  '';
}
