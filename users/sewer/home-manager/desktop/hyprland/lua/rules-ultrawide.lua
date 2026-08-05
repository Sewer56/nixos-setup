-- Workspace rules for ULTRAWIDE mode
-- Ultrawide workspaces (1-4): Layout-optimized for ultrawide display
-- High workspaces (7-10): Uncommonly checked applications

hl.workspace_rule({ workspace = "0", layout = "master", default = true })
hl.workspace_rule({ workspace = "1", layout = "master" })
hl.workspace_rule({ workspace = "2", layout = "dwindle" })
hl.workspace_rule({ workspace = "3", layout = "master" })
hl.workspace_rule({ workspace = "4", layout = "dwindle" })

-- Workspace 1: Code/Browsers (master layout optimized for ultrawide)
hl.window_rule({ workspace = "1 silent", match = { class = "^(chromium-browser)$" } })
hl.window_rule({ workspace = "1 silent", match = { class = "^(vivaldi-stable)$" } })
hl.window_rule({ workspace = "1 silent", match = { class = "^(code)$" } })
hl.window_rule({ workspace = "1 silent", match = { class = "^(Code)$" } })
hl.window_rule({ workspace = "1 silent", match = { class = "^(vesktop)$" } })

-- Workspace 2: Secondary development tools (master layout)
hl.window_rule({ workspace = "2 silent", match = { class = "(?i)^(gitkraken)$" } })
hl.window_rule({ workspace = "2 silent", match = { class = "^(md.Obsidian)$" } })
hl.window_rule({ workspace = "2 silent", match = { class = "^(obsidian)$" } })
hl.window_rule({ workspace = "2 silent", match = { class = "^(electron)$", title = "^(.*Obsidian.*)$" } })

-- Workspace 3: Communications (master layout)
hl.window_rule({ workspace = "3 silent", match = { class = "^(Slack)$" } })
hl.window_rule({ workspace = "3 silent", match = { class = "^(telegram-desktop)$" } })
hl.window_rule({ workspace = "3 silent", match = { class = "^(TelegramDesktop)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "3 silent", match = { class = "^(slack)$" } })

-- Workspace 4: Miscellaneous apps (dwindle layout)
hl.window_rule({ workspace = "4 silent", match = { class = "^(spotify)$" } })
hl.window_rule({ workspace = "4 silent", match = { class = "^(Proton Mail)$" } })
hl.window_rule({ workspace = "4 silent", match = { class = "^(electron)$", title = "^(Proton Mail)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "4 silent", match = { class = "^(Spotify)$" } })
hl.window_rule({ workspace = "4 silent", match = { class = "^(proton-mail)$" } })

-- Floating window rules
hl.window_rule({ float = true, match = { title = "^(Picture-in-Picture)$" } })
hl.window_rule({ float = true, match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ float = true, match = { class = "^(nm-connection-editor)$" } })
hl.window_rule({ size = "800 600", match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ size = "800 600", match = { class = "^(nm-connection-editor)$" } })
