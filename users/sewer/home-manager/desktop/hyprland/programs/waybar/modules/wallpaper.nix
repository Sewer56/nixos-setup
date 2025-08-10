semantic: {
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
        "custom/wallpaper-update"
        "custom/wallpaper-cleanup"
      ];
    };

    "custom/wallpaper-download" = {
      format = "";
      tooltip-format = "Download random wallpaper from Wallhaven\nLeft: Similar aspect ratio • Right: Any aspect ratio";
      on-click = "~/.config/waybar/scripts/wallpaper/download-random-wallpaper.py --aspect-ratio-mode=similar";
      on-click-right = "~/.config/waybar/scripts/wallpaper/download-random-wallpaper.py --aspect-ratio-mode=any";
    };

    "custom/wallpaper-save" = {
      format = "󰆓";
      tooltip-format = "Save current wallpaper to collection";
      on-click = "~/.config/waybar/scripts/wallpaper/save-current-wallpaper.py";
    };

    "custom/wallpaper-sync" = {
      format = "󰑓";
      tooltip-format = "Sync wallpaper collection\n(download missing wallpapers from wallpaper_collection.json)";
      on-click = "~/.config/waybar/scripts/wallpaper/sync-collection.py";
    };

    "custom/wallpaper-update" = {
      format = "󰁝";
      tooltip-format = "Update collection from disk\n(add missing wallpapers on disk to wallpaper_collection.json)";
      on-click = "~/.config/waybar/scripts/wallpaper/update-collection.py";
    };

    "custom/wallpaper-cleanup" = {
      format = "󰃢";
      tooltip-format = "Remove untracked wallpapers\n(remove wallpapers on disk not in wallpaper_collection.json)";
      on-click = "~/.config/waybar/scripts/wallpaper/cleanup-collection.py";
    };

    "custom/wallpaper-random" = {
      format = "";
      tooltip-format = "Random favourite wallpaper\nLeft: Similar aspect ratio • Right: Any aspect ratio";
      on-click = "~/.config/waybar/scripts/wallpaper/random-favourite-wallpaper.py --aspect-ratio-mode=similar";
      on-click-right = "~/.config/waybar/scripts/wallpaper/random-favourite-wallpaper.py --aspect-ratio-mode=any";
    };

    "custom/wallpaper-colour" = {
      format = "";
      tooltip-format = "Auto adjust accent colour based on current wallpaper";
      on-click = "~/.config/waybar/scripts/wallpaper/auto-accent-colour.py";
    };
  };

  style = ''
    #waybar.bar #group-wallpaper,
    #waybar.bar #custom-wallpaper-download,
    #waybar.bar #custom-wallpaper-save,
    #waybar.bar #custom-wallpaper-sync,
    #waybar.bar #custom-wallpaper-update,
    #waybar.bar #custom-wallpaper-cleanup,
    #waybar.bar #custom-wallpaper-random,
    #waybar.bar #custom-wallpaper-colour,
    #waybar.bar .wallpaper-drawer {
      color: ${semantic.interactiveHighlight};
      padding-left: 4pt;
      padding-right: 4pt;
      padding-bottom: 2px;
      padding-top: 2px;
      background: transparent;
    }

    #waybar.bar #custom-wallpaper-download:hover,
    #waybar.bar #custom-wallpaper-save:hover,
    #waybar.bar #custom-wallpaper-sync:hover,
    #waybar.bar #custom-wallpaper-update:hover,
    #waybar.bar #custom-wallpaper-cleanup:hover,
    #waybar.bar #custom-wallpaper-random:hover,
    #waybar.bar #custom-wallpaper-colour:hover {
      color: ${semantic.interactive};
      background: rgba(255, 229, 196, 0.2);
      border-radius: 4px;
    }
  '';
}
