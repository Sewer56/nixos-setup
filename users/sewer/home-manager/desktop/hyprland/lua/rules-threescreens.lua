-- Workspace rules for THREE SCREEN OFFICE setup

hl.workspace_rule({ workspace = "1", monitor = "DP-4", persistent = true, default = true }) -- Vivaldi - Left screen
hl.workspace_rule({ workspace = "2", monitor = "DP-3", persistent = true }) -- Code - Middle screen
hl.workspace_rule({ workspace = "3", monitor = "eDP-1", persistent = true }) -- Slack + Discord - Right screen (integrated)
hl.workspace_rule({ workspace = "4", monitor = "eDP-1", persistent = true }) -- Other apps - Right screen
hl.workspace_rule({ workspace = "7", monitor = "eDP-1", persistent = true }) -- Other apps - Right screen
hl.workspace_rule({ workspace = "8", monitor = "eDP-1", persistent = true }) -- Other apps - Right screen
hl.workspace_rule({ workspace = "9", monitor = "eDP-1", persistent = true }) -- Other apps - Right screen
hl.workspace_rule({ workspace = "10", monitor = "eDP-1", persistent = true }) -- Other apps - Right screen

-- Workspace 1: Vivaldi - Left screen (DP-4)
hl.window_rule({ workspace = "1", match = { class = "^(vivaldi-stable)$" } })
hl.window_rule({ workspace = "1", match = { class = "^(chromium-browser)$" } })
hl.window_rule({ workspace = "1", match = { class = "^(firefox)$" } })

-- Workspace 2: Code - Middle screen (DP-3)
hl.window_rule({ workspace = "2", match = { class = "^(Code)$" } })
hl.window_rule({ workspace = "2", match = { class = "^(code)$" } })
hl.window_rule({ workspace = "2", match = { class = "^(code-url-handler)$" } })

-- Workspace 3: Slack AND Discord - Right screen (eDP-1)
hl.window_rule({ workspace = "3", match = { class = "^(Slack)$" } })
hl.window_rule({ workspace = "3", match = { class = "^(discord)$" } })
hl.window_rule({ workspace = "3", match = { class = "^(vesktop)$" } })
-- Alternate class names (version-dependent)
hl.window_rule({ workspace = "3", match = { class = "^(slack)$" } })

-- Other workspaces on right screen (eDP-1)
hl.window_rule({ workspace = "4", match = { class = "^(telegram-desktop)$" } })
hl.window_rule({ workspace = "4", match = { class = "^(TelegramDesktop)$" } })
hl.window_rule({ workspace = "7", match = { class = "^(obsidian)$" } })
hl.window_rule({ workspace = "7", match = { class = "^(electron)$", title = "^(.*Obsidian.*)$" } })
hl.window_rule({ workspace = "8", match = { class = "^(spotify)$" } })
hl.window_rule({ workspace = "8", match = { class = "^(Spotify)$" } }) -- Alternate class names (version-dependent)
hl.window_rule({ workspace = "9", match = { class = "(?i)^(gitkraken)$" } })
hl.window_rule({ workspace = "10", match = { class = "^(Proton Mail)$" } })
hl.window_rule({ workspace = "10", match = { class = "^(electron)$", title = "^(Proton Mail)$" } })
hl.window_rule({ workspace = "10", match = { class = "^(proton-mail)$" } }) -- Alternate class names (version-dependent)

-- Floating window rules
hl.window_rule({ float = true, match = { title = "^(Picture-in-Picture)$" } })
hl.window_rule({ float = true, match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ float = true, match = { class = "^(nm-connection-editor)$" } })
hl.window_rule({ size = "800 600", match = { class = "^(pwvucontrol)$" } })
hl.window_rule({ size = "800 600", match = { class = "^(nm-connection-editor)$" } })
