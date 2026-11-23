{pkgs, ...}: {
  # Clipboard management for Hyprland
  home.packages = with pkgs; [
    cliphist # Clipboard history manager for Wayland
  ];

  # SUPER+V: pick from clipboard history with rofi
  home.file.".local/bin/clipboard_history_pick.sh" = {
    text = ''
      #!/usr/bin/env bash

      ENTRY=$(cliphist list | rofi -dmenu -theme ~/.config/rofi/themes/clipboard/laptop.rasi) || exit 0

      TMP=$(mktemp)
      cliphist decode <<< "$ENTRY" > "$TMP"

      # cliphist forgets the type, so a copied file comes back as plain text.
      # Mark file:// links as files again, so pasting a screenshot uploads the image.
      if [[ $(wc -l < "$TMP") -eq 1 ]] && grep -q '^file://' "$TMP"; then
        wl-copy -t text/uri-list < "$TMP"
      else
        wl-copy < "$TMP"
      fi
      rm -f "$TMP"
    '';
    executable = true;
  };
}
