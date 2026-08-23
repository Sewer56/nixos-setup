{pkgs, ...}: {
  # Screenshot functionality for Hyprland
  home.packages = with pkgs; [
    grim # Screenshot utility for Wayland
    libwebp # cwebp encoder for lossless WebP screenshots
    slurp # Region selection for screenshots
    hyprpicker # Freeze screen during interactive captures
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
      FILENAME="$(date +"%Y%m%d_%Hh%Mm%Ss").webp"
      FILEPATH="$FULL_DIR/$FILENAME"

      # Freeze the current frame while selecting a region
      FREEZE_PID=""
      TMP_PPM=""
      cleanup() {
        if [[ -n "$FREEZE_PID" ]]; then
          kill "$FREEZE_PID" 2>/dev/null || true
          wait "$FREEZE_PID" 2>/dev/null || true
          FREEZE_PID=""
        fi
      }
      trap 'cleanup; [[ -n "$TMP_PPM" ]] && rm -f "$TMP_PPM"' EXIT

      hyprpicker -r -z >/dev/null 2>&1 &
      FREEZE_PID=$!
      # Give hyprpicker time to map the frozen overlay before slurp starts.
      sleep 0.2

      REGION=$(slurp) || exit 0

      # Capture raw (instant), then encode lossless WebP
      TMP_PPM=$(mktemp /tmp/screenshot.XXXXXX.ppm)
      grim -t ppm -g "$REGION" "$TMP_PPM"
      cleanup
      cwebp -quiet -lossless -q 100 -m 4 -mt "$TMP_PPM" -o "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy -t image/webp < "$FILEPATH"
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
      FILENAME="$(date +"%Y%m%d_%Hh%Mm%Ss").webp"
      FILEPATH="$FULL_DIR/$FILENAME"

      # Capture raw (instant), then encode lossless WebP
      TMP_PPM=$(mktemp /tmp/screenshot.XXXXXX.ppm)
      trap 'rm -f "$TMP_PPM"' EXIT
      grim -t ppm "$TMP_PPM"
      cwebp -quiet -lossless -q 100 -m 4 -mt "$TMP_PPM" -o "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy -t image/webp < "$FILEPATH"
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
        FILENAME="''${TIMESTAMP}_''${CLEAN_TITLE}.webp"
      else
        FILENAME="''${TIMESTAMP}.webp"
      fi
      FILEPATH="$FULL_DIR/$FILENAME"

      # Capture raw (instant), then encode lossless WebP
      TMP_PPM=$(mktemp /tmp/screenshot.XXXXXX.ppm)
      trap 'rm -f "$TMP_PPM"' EXIT
      grim -t ppm -g "''${WINDOW_X},''${WINDOW_Y} ''${WINDOW_WIDTH}x''${WINDOW_HEIGHT}" "$TMP_PPM"
      cwebp -quiet -lossless -q 100 -m 4 -mt "$TMP_PPM" -o "$FILEPATH"

      # Copy to clipboard and show notification
      if [[ -f "$FILEPATH" ]]; then
        wl-copy -t image/webp < "$FILEPATH"
        FILE_SIZE=$(du -h "$FILEPATH" | cut -f1)
        notify-send "Window Screenshot saved" "Window: $WINDOW_TITLE\nFile: $FILENAME\nSize: $FILE_SIZE\nLocation: $FULL_DIR" -i "$FILEPATH"
      fi
    '';
    executable = true;
  };
}
