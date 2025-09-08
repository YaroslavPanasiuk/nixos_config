{ pkgs }:

pkgs.writeShellScriptBin "update_songs_presentation.sh" '' 
#!/bin/sh
set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 file.pptx"
  exit 1
fi

INPUT="$1"
BASENAME="''${INPUT%.pptx}"
FODP="''${BASENAME}.fodp"

# 1. Convert PPTX → FODP
libreoffice --headless --convert-to fodp "$INPUT" --outdir "$(dirname "$INPUT")"

# 2. Replace page size and font size in FODP
sed -i \
  -e 's/stroke-width="0cm/stroke-width="0.1cm/g' \
  -e 's/font-size="48pt"/font-size="72pt"/g' \
  "$FODP"

# 3. Convert modified FODP → PPTX
libreoffice --headless --convert-to pptx "$FODP" --outdir "$(dirname "$INPUT")"

# 4. Replace original file with the new one
rm -f "$FODP"

echo "✅ Updated presentation saved as $INPUT"

''
