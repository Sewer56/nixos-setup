-- Workspace rules for STANDARD (single monitor) mode
-- Low workspaces (1-5): Common applications
-- High workspaces (8-0): Uncommonly checked applications

hl.workspace_rule({ workspace = "1", persistent = true, default = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })
hl.workspace_rule({ workspace = "7", persistent = true })
hl.workspace_rule({ workspace = "8", persistent = true })
hl.workspace_rule({ workspace = "9", persistent = true })
hl.workspace_rule({ workspace = "10", persistent = true })

-- Workspace 1: Browsers
hl.window_rule({ workspace = "1", match = { class = "^(chromium-browser)$" } })
hl.window_rule({ workspace = "1", match = { class = "^(firefox)$" } })
hl.window_rule({ workspace = "1", match = { class = "^(vivaldi-stable)$" } })

-- Workspace 2: Code editors
hl.window_rule({ workspace = "2", match = { class = "^(Code)$" } })
hl.window_rule({ workspace = "2", match = { class = "^(code)$" } })
hl.window_rule({ workspace = "2", match = { class = "^(code-url-handler)$" } })

-- Workspace 3: Discord
hl.window_rule({ workspace = "3", match = { class = "^(discord)$" } })
hl.window_rule({ workspace = "3", match = { class = "^(vesktop)$" } })

-- Workspace 4: Slack
hl.window_rule({ workspace = "4", match = { class = "^(Slack)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "4", match = { class = "^(slack)$" } })

-- Workspace 5: Communication
hl.window_rule({ workspace = "5", match = { class = "^(telegram-desktop)$" } })
hl.window_rule({ workspace = "5", match = { class = "^(TelegramDesktop)$" } })

-- Workspace 7: Notes
hl.window_rule({ workspace = "7", match = { class = "^(md.Obsidian)$" } })
hl.window_rule({ workspace = "7", match = { class = "^(obsidian)$" } })
hl.window_rule({ workspace = "7", match = { class = "^(electron)$", title = "^(.*Obsidian.*)$" } })

-- Workspace 8: Music
hl.window_rule({ workspace = "8", match = { class = "^(spotify)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "8", match = { class = "^(Spotify)$" } })

-- Workspace 9: Git
hl.window_rule({ workspace = "9", match = { class = "(?i)^(gitkraken)$" } })

-- Workspace 10: Email (bound to '0')
hl.window_rule({ workspace = "10", match = { class = "^(Proton Mail)$" } })
hl.window_rule({ workspace = "10", match = { class = "^(electron)$", title = "^(Proton Mail)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "10", match = { class = "^(proton-mail)$" } })

-- Floating window rules
hl.window_rule({ float = true, match = { title = "^(Picture-in-Picture)$" } })
hl.window_rule({ float = true, match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ float = true, match = { class = "^(nm-connection-editor)$" } })

-- Size rules for floating windows
hl.window_rule({ size = "800 600", match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ size = "800 600", match = { class = "^(nm-connection-editor)$" } })
