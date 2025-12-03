#!/usr/bin/env bash

FONT_PATH="${TUMBLER_TEXT_FONT:-Liberation-Mono}"

if [[ $# -lt 3 ]]; then
  echo "$0: size input_file_name output_file_name"
  exit 255
fi

SIZE="$1"
INPUT_FILE_NAME="$2"
OUTPUT_FILE_NAME="$3"

# Cleanup function
cleanup() {
  [[ -n "${TMP_FILE:-}" && -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
}
trap cleanup EXIT

POINTSIZE=$((SIZE / 8))
[[ $POINTSIZE -lt 4 ]] && POINTSIZE=4

CHOPPED_FILE_CONTENT="$(head --lines=36 "$INPUT_FILE_NAME")"

# Use temp file with .png extension - ImageMagick needs the extension to detect output format
# (Tumbler's %o output path has no extension)
if TMP_FILE="$(mktemp --tmpdir tumbler-text-XXXXXX.png)"; then
  convert -size "${SIZE}x${SIZE}" \
    -background "#fffaed" \
    -fill black \
    -border 1x1 -bordercolor "#00aaff" \
    -font "$FONT_PATH" -pointsize "$POINTSIZE" \
    label:"$CHOPPED_FILE_CONTENT" \
    "$TMP_FILE" && cp "$TMP_FILE" "$OUTPUT_FILE_NAME"
else
  exit 1
fi
