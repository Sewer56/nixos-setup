#!/usr/bin/env bash

if [[ $# -lt 3 ]]; then
  echo "$0: size input_file output_file"
  exit 255
fi

SIZE="$1"
INPUT_FILE="$2"
OUTPUT_FILE="$3"

# Use temp file with .png extension - ImageMagick needs the extension to detect output format
# (Tumbler's %o output path has no extension)
if TMP_FILE="$(mktemp --tmpdir tumbler-dds-XXXXXX.png)"; then
  convert -thumbnail "${SIZE}x${SIZE}" "$INPUT_FILE" "$TMP_FILE" && mv "$TMP_FILE" "$OUTPUT_FILE"
else
  exit 1
fi
