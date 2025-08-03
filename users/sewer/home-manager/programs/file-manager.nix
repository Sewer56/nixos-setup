{pkgs, lib, ...}: {
  home.packages = with pkgs; [
    nemo-with-extensions
  ];

  # Set nemo as the default.
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["nemo.desktop"];
    "application/x-gnome-saved-search" = ["nemo.desktop"];
  };

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = false;
      thumbnail-limit = lib.hm.gvariant.mkUint64 68719476736; # 64GB
    };

    "org/nemo/search" = {
      search-files-recursively = false;
      search-reverse-sort = false;
      search-sort-column = "name";
    };

    "org/nemo/window-state" = {
      maximized = true;
      sidebar-bookmark-breakpoint = 0;
      sidebar-width = 183;
      start-with-menu-bar = false;
      start-with-sidebar = true;
      start-with-status-bar = false;
    };

    "org/cinnamon/desktop/applications/terminal" = {
      exec = "alacritty";
    };
  };
}
