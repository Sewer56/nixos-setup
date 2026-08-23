-- Key bindings - see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
-- Repeat/lock/mouse are hl.bind options: old binde -> { repeating = true },
-- bindl -> { locked = true }, bindel -> { locked = true, repeating = true },
-- bindm -> { mouse = true } (bindm was removed in Hyprland 0.55).

-- Store paths substituted by home-manager
local layoutToggle = "@layoutToggle@"
local touchpadToggle = "@touchpadToggle@"

-- Applications
hl.bind("SUPER + Return", hl.dsp.exec_cmd("alacritty"))
-- Rofi bindings moved to lua/binds.lua below (rofi section)
-- Toggle bar. NixOS wrapping shenanigans
hl.bind("SUPER + B", hl.dsp.exec_cmd("killall waybar || killall .waybar-wrapped || waybar"))
-- Lock screen binding moved to autostart.lua / idle-lock

-- Window management
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + T", hl.dsp.exec_cmd(layoutToggle)) -- Toggle between master/dwindle layouts

-- Focus movement
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

-- Layout management
hl.bind("SUPER + W", hl.dsp.layout("swapprev noloop")) -- Swap with previous window
hl.bind("SUPER + E", hl.dsp.layout("swapnext noloop")) -- Swap with next window
hl.bind("SUPER + O", hl.dsp.layout("addmaster")) -- Add master window
hl.bind("SUPER + SHIFT + O", hl.dsp.layout("removemaster")) -- Remove master window
hl.bind("SUPER + SHIFT + T", hl.dsp.layout("orientationcycle center bottom")) -- Toggle master orientation (center/bottom)

-- Application pass-through bindings
hl.bind("ALT + 5", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
hl.bind("ALT + 6", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
hl.bind("SUPER + C", hl.dsp.pass({ window = "^(qemu)$" }))

-- Window movement
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Workspace switching / moving
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Screenshot bindings
-- Print = area to clipboard, Shift+Print = full to clipboard
-- Ctrl+Print = area to file, Ctrl+Shift+Print = full to file
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.local/bin/take_screenshot.sh")) -- Region selection
hl.bind("ALT + Print", hl.dsp.exec_cmd("~/.local/bin/take_current_window_screenshot.sh")) -- Current window
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.local/bin/take_full_screenshot.sh")) -- Full screen

-- Window switcher (Alt+Tab) and rofi launcher bindings
hl.bind("SUPER + D", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("rofi -show run -theme ~/.config/rofi/themes/run/laptop.rasi"))
hl.bind("SUPER + period", hl.dsp.exec_cmd("rofi -show emoji -emoji-mode copy -emoji-format '{emoji} <span weight=\"light\">{name}</span>' -theme ~/.config/rofi/themes/emoji/laptop.rasi"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd("rofi -show window"))

-- Clipboard manager (Super+V = open clipboard history)
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/.local/bin/clipboard_history_pick.sh"))

-- Lock screen manually
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("hyprlock"))

-- Suspend
hl.bind("ALT + grave", hl.dsp.exec_cmd("systemctl suspend"))

-- Repeat key bindings (old binde) - resize windows
hl.bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Mouse bindings (old bindm; removed in Hyprland 0.55, now { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys (old bindel: locked + repeating)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
-- Mouse button volume controls
hl.bind("mouse:281", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("mouse:282", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
-- Brightness controls
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Locked binds (old bindl)
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
-- XF86TouchpadToggle . Broken on hyprland.
hl.bind("code:269025193", hl.dsp.exec_cmd(touchpadToggle), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
-- Custom media key bindings
hl.bind("ALT + 1", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("ALT + 2", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("ALT + 3", hl.dsp.exec_cmd("playerctl next"), { locked = true })
