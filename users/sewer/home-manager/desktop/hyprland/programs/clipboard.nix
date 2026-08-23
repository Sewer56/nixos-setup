{pkgs, ...}: {
  # Clipboard management for Hyprland
  home.packages = with pkgs; [
    cliphist # Clipboard history manager for Wayland
  ];

  # Clipboard history restore script: cliphist loses the original MIME type,
  # so file:// entries (screenshot uploads) must be re-offered as text/uri-list
  # instead of letting wl-copy sniff them as plain text
  home.file.".local/bin/clipboard_history_pick.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Pick a cliphist entry via rofi and restore it with the right MIME type

      ENTRY=$(cliphist list | rofi -dmenu -theme ~/.config/rofi/themes/clipboard/laptop.rasi) || exit 0

      TMP=$(mktemp)
      cliphist decode <<< "$ENTRY" > "$TMP"

      # After this block: file references restored as uri-list, others sniffed
      if [[ $(wc -l < "$TMP") -eq 1 ]] && grep -q '^file://' "$TMP"; then
        wl-copy -t text/uri-list < "$TMP"
      else
        wl-copy < "$TMP"
      fi
      rm -f "$TMP"
    '';
    executable = true;
  };

  # Clipboard history tracking and SUPER+V binding are in
  # lua/autostart.lua and lua/binds.lua
}
