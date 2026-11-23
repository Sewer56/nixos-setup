-- Key bindings - see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- Store paths substituted by home-manager
local layoutToggle = "@layoutToggle@"
local touchpadToggle = "@touchpadToggle@"

-- Applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd("alacritty")) -- Terminal
-- Toggle bar. NixOS wrapping shenanigans
hl.bind("SUPER + B", hl.dsp.exec_cmd("killall waybar || killall .waybar-wrapped || waybar"))

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close()) -- Close window
hl.bind("SUPER + F", hl.dsp.window.fullscreen()) -- Fullscreen
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" })) -- Toggle floating
hl.bind("SUPER + P", hl.dsp.window.pseudo()) -- Pseudo-tile
hl.bind("SUPER + T", hl.dsp.exec_cmd(layoutToggle)) -- Toggle between master/dwindle layouts

-- Focus movement
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" })) -- Focus left
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" })) -- Focus right
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" })) -- Focus up
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" })) -- Focus down

-- Layout management
hl.bind("SUPER + W", hl.dsp.layout("swapprev noloop")) -- Swap with previous window
hl.bind("SUPER + E", hl.dsp.layout("swapnext noloop")) -- Swap with next window
hl.bind("SUPER + O", hl.dsp.layout("addmaster")) -- Add master window
hl.bind("SUPER + SHIFT + O", hl.dsp.layout("removemaster")) -- Remove master window
hl.bind("SUPER + SHIFT + T", hl.dsp.layout("orientationcycle center bottom")) -- Toggle master orientation (center/bottom)

-- Application pass-through bindings (OBS hotkeys: Alt+numpad 1-6)
hl.bind("ALT + code:87", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:87", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD1
hl.bind("ALT + code:88", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:88", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD2
hl.bind("ALT + code:89", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:89", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD3
hl.bind("ALT + code:83", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:83", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD4
hl.bind("ALT + code:84", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:84", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD5
hl.bind("ALT + code:85", hl.dsp.send_shortcut({ mods = "ALT MOD2", key = "code:85", window = "class:^(com\\.obsproject\\.Studio)$" })) -- ALT+NUMPAD6
hl.bind("SUPER + C", hl.dsp.pass({ window = "^(qemu)$" })) -- Lock/unlock virt-manager/QEMU mouse capture

-- Window movement
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" })) -- Move window left
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" })) -- Move window right
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" })) -- Move window up
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" })) -- Move window down

-- Workspace switching / moving
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i })) -- Go to workspace
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- Move window to workspace
end

-- Scroll through workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" })) -- Next workspace
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" })) -- Previous workspace

-- Screenshot bindings (WebP; add SUPER for PNG)
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot.sh")) -- Region selection
hl.bind("ALT + Print", hl.dsp.exec_cmd("~/.local/bin/take_current_window_screenshot.sh")) -- Current window
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.local/bin/take_full_screenshot.sh")) -- Full screen
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot.sh --png")) -- Region selection (PNG)
hl.bind("SUPER + ALT + Print", hl.dsp.exec_cmd("~/.local/bin/take_current_window_screenshot.sh --png")) -- Current window (PNG)
hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd("~/.local/bin/take_full_screenshot.sh --png")) -- Full screen (PNG)

-- Window switcher (Alt+Tab) and rofi launcher bindings
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun")) -- App launcher
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show run -theme ~/.config/rofi/themes/run/laptop.rasi")) -- Run command
hl.bind("SUPER + period", hl.dsp.exec_cmd("rofi -show emoji -emoji-mode copy -emoji-format '{emoji} <span weight=\"light\">{name}</span>' -theme ~/.config/rofi/themes/emoji/laptop.rasi")) -- Emoji picker
hl.bind("ALT + Tab", hl.dsp.exec_cmd("rofi -show window")) -- Window switcher

-- Clipboard manager (Super+V = open clipboard history)
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/.local/bin/clipboard_history_pick.sh"))

-- Lock screen manually
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("hyprlock"))

-- Suspend
hl.bind("ALT + grave", hl.dsp.exec_cmd("systemctl suspend"))

-- Repeat key bindings (old binde) - resize windows
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true }) -- Wider
hl.bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true }) -- Narrower
hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true }) -- Shorter
hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true }) -- Taller

-- Mouse bindings (old bindm; removed in Hyprland 0.55, now { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true }) -- Left drag: move window
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true }) -- Right drag: resize window

-- Media keys (old bindel: locked + repeating)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true }) -- Volume up
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true }) -- Volume down
-- Mouse button volume controls
hl.bind("mouse:281", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true }) -- Volume up
hl.bind("mouse:282", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true }) -- Volume down
-- Brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true }) -- Brightness up
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true }) -- Brightness down

-- Locked binds (old bindl)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true }) -- Toggle speaker mute
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true }) -- Toggle mic mute
-- XF86TouchpadToggle . Broken on hyprland.
hl.bind("code:269025193", hl.dsp.exec_cmd(touchpadToggle), { locked = true }) -- Toggle touchpad
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- Play/pause
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true }) -- Next track
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true }) -- Previous track
-- Custom media key bindings
hl.bind("ALT + 1", hl.dsp.exec_cmd("playerctl previous"), { locked = true }) -- Previous track
hl.bind("ALT + 2", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true }) -- Play/pause
hl.bind("ALT + 3", hl.dsp.exec_cmd("playerctl next"), { locked = true }) -- Next track
