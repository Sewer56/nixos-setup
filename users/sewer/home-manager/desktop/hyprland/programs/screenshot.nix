{pkgs, ...}: {
  # Screenshot functionality for Hyprland
  home.packages = with pkgs; [
    grim # Screenshot utility for Wayland
    slurp # Region selection for screenshots
    wl-clipboard # Wayland clipboard utilities
    libnotify # Desktop notifications
    jq # For parsing hyprctl JSON output
  ];

  # Screenshot scripts with advanced features
  home.file.".local/bin/take_screenshot.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Advanced region selection screenshot script

      # Try storage paths in order: NAS first, then local fallback
      STORAGE_PATHS=(
        "/mnt/NAS/seagate-pcloud/Images/NonSyncable/ShareX/Screenshots"
        "$HOME/Pictures/Screenshots"
      )

      # Find first available storage path
      SCREENSHOT_DIR=""
      for path in "''${STORAGE_PATHS[@]}"; do
        if [[ -d "$(dirname "$path")" ]]; then
          SCREENSHOT_DIR="$path"
          break
        fi
      done

      # Create year-month subdirectory
      YEAR_MONTH=$(date +"%Y-%m")
      FULL_DIR="$SCREENSHOT_DIR/$YEAR_MONTH"
      mkdir -p "$FULL_DIR"

      # Generate filename with timestamp
      FILENAME="$(date +"%Y%m%d_%Hh%Mm%Ss").png"
      FILEPATH="$FULL_DIR/$FILENAME"

      # Take screenshot with region selection
      grim -l 9 -g "$(slurp)" "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy < "$FILEPATH"
        FILE_SIZE=$(du -h "$FILEPATH" | cut -f1)
        notify-send "Screenshot saved" "File: $FILENAME\nSize: $FILE_SIZE\nLocation: $FULL_DIR" -i "$FILEPATH"
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/take_full_screenshot.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Advanced full screen screenshot script

      # Try storage paths in order: NAS first, then local fallback
      STORAGE_PATHS=(
        "/mnt/NAS/seagate-pcloud/Images/NonSyncable/ShareX/Screenshots"
        "$HOME/Pictures/Screenshots"
      )

      # Find first available storage path
      SCREENSHOT_DIR=""
      for path in "''${STORAGE_PATHS[@]}"; do
        if [[ -d "$(dirname "$path")" ]]; then
          SCREENSHOT_DIR="$path"
          break
        fi
      done

      # Create year-month subdirectory
      YEAR_MONTH=$(date +"%Y-%m")
      FULL_DIR="$SCREENSHOT_DIR/$YEAR_MONTH"
      mkdir -p "$FULL_DIR"

      # Generate filename with timestamp
      FILENAME="$(date +"%Y%m%d_%Hh%Mm%Ss").png"
      FILEPATH="$FULL_DIR/$FILENAME"

      # Take full screenshot
      grim -l 9 "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy < "$FILEPATH"
        FILE_SIZE=$(du -h "$FILEPATH" | cut -f1)
        notify-send "Screenshot saved" "File: $FILENAME\nSize: $FILE_SIZE\nLocation: $FULL_DIR" -i "$FILEPATH"
      fi
    '';
    executable = true;
  };

  home.file.".local/bin/take_current_window_screenshot.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Advanced current window screenshot script with intelligent window detection

      # Try storage paths in order: NAS first, then local fallback
      STORAGE_PATHS=(
        "/mnt/NAS/seagate-pcloud/Images/NonSyncable/ShareX/Screenshots"
        "$HOME/Pictures/Screenshots"
      )

      # Find first available storage path
      SCREENSHOT_DIR=""
      for path in "''${STORAGE_PATHS[@]}"; do
        if [[ -d "$(dirname "$path")" ]]; then
          SCREENSHOT_DIR="$path"
          break
        fi
      done

      # Create year-month subdirectory
      YEAR_MONTH=$(date +"%Y-%m")
      FULL_DIR="$SCREENSHOT_DIR/$YEAR_MONTH"
      mkdir -p "$FULL_DIR"

      # Get active window information
      WINDOW_INFO=$(hyprctl activewindow -j)
      WINDOW_X=$(echo "$WINDOW_INFO" | jq -r '.at[0]')
      WINDOW_Y=$(echo "$WINDOW_INFO" | jq -r '.at[1]')
      WINDOW_WIDTH=$(echo "$WINDOW_INFO" | jq -r '.size[0]')
      WINDOW_HEIGHT=$(echo "$WINDOW_INFO" | jq -r '.size[1]')
      WINDOW_TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')

      # Sanitize window title for filename (replace spaces with underscores, remove special chars)
      CLEAN_TITLE=$(echo "$WINDOW_TITLE" | sed 's/[^a-zA-Z0-9 ]//g' | sed 's/ /_/g')

      # Generate filename with timestamp and window title
      TIMESTAMP="$(date +"%Y%m%d_%Hh%Mm%Ss")"
      if [[ -n "$CLEAN_TITLE" && "$CLEAN_TITLE" != "null" ]]; then
        FILENAME="''${TIMESTAMP}_''${CLEAN_TITLE}.png"
      else
        FILENAME="''${TIMESTAMP}.png"
      fi
      FILEPATH="$FULL_DIR/$FILENAME"

      # Take screenshot of specific window geometry
      grim -l 9 -g "''${WINDOW_X},''${WINDOW_Y} ''${WINDOW_WIDTH}x''${WINDOW_HEIGHT}" "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy < "$FILEPATH"
        FILE_SIZE=$(du -h "$FILEPATH" | cut -f1)
        notify-send "Window Screenshot saved" "Window: $WINDOW_TITLE\nFile: $FILENAME\nSize: $FILE_SIZE\nLocation: $FULL_DIR" -i "$FILEPATH"
      fi
    '';
    executable = true;
  };

  wayland.windowManager.hyprland.settings = {
    bind = [
      # Advanced screenshot bindings matching legacy Arch setup
      "SHIFT, Print, exec, ~/.local/bin/take_screenshot.sh" # Region selection
      "ALT, Print, exec, ~/.local/bin/take_current_window_screenshot.sh" # Current window
      "CTRL, Print, exec, ~/.local/bin/take_full_screenshot.sh" # Full screen
    ];
  };
}
