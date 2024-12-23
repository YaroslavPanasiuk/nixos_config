#!/bin/sh

SOURCE_FILE="$1"
FILENAME=$(basename "$SOURCE_FILE")
FILENAME_WITHOUT_EXTENSION="${SOURCE_FILE%.*}"
DEST_FILE="$FILENAME_WITHOUT_EXTENSION.nix"

touch $DEST_FILE

# Check if the source .sh file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Source file $SOURCE_FILE does not exist."
    exit 1
fi

# Read the content of the .sh file
FILE_CONTENT=$(<"$SOURCE_FILE")

# Write the content into the .nix file with the desired wrapping
cat > "$DEST_FILE" << EOF
{ pkgs }:

pkgs.writeShellScriptBin "$FILENAME" '' 
$FILE_CONTENT
''
EOF

echo "Successfully wrapped the content and saved to $DEST_FILE"
