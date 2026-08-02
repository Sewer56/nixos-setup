-- Autostart applications - see https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  -- System services
  hl.exec_cmd("waybar")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  -- Startup applications
  hl.exec_cmd("code")
  hl.exec_cmd("vesktop")
  hl.exec_cmd("gitkraken")
  hl.exec_cmd("slack --ozone-platform=wayland")
  hl.exec_cmd("telegram-desktop")
  hl.exec_cmd("spotify")
  hl.exec_cmd("proton-mail")
  hl.exec_cmd("vivaldi")
  hl.exec_cmd("obsidian")
end)

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprsunset")
end)

-- Wallpaper: set random wallpaper and sync collection in background
hl.on("hyprland.start", function()
  hl.exec_cmd("~/.config/waybar/scripts/wallpaper/startup-wrapper.py")
  hl.exec_cmd("hyprctl setcursor @cursorTheme@ 32")
  hl.exec_cmd("~/.config/waybar/scripts/wallpaper/sync-wallpapers.py")
  hl.exec_cmd("~/.config/waybar/scripts/wallpaper/startup-sync.py")
end)

-- Clipboard history tracking
hl.on("hyprland.start", function()
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
