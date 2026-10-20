#!/usr/bin/env bash

LANG1="en"
LANG2="uk"

# Step 1: Input query
QUERY=$(rofi -dmenu -p "Translate" -lines 0)
[ -z "$QUERY" ] && exit 0

# Step 2: Fetch detailed JSON from Translate Shell
# Determine pair direction dynamically by testing first
DATA=$(trans -j -no-ansi "$LANG1:$LANG2" "$QUERY" 2>/dev/null)

PRIMARY=$(echo "$DATA" | jq -r '.[0][0][0] // empty')
SRC_LANG=$(echo "$DATA" | jq -r '.[2] // empty')

# Swap target if input matches target language
if [ "$SRC_LANG" = "$LANG2" ]; then
    DATA=$(trans -j -no-ansi "$LANG2:$LANG1" "$QUERY" 2>/dev/null)
    PRIMARY=$(echo "$DATA" | jq -r '.[0][0][0] // empty')
fi

# Step 3: Extract primary translation + dictionary alternatives/synonyms
CANDIDATES=$(echo "$DATA" | jq -r '
  (.[0][0][0] // empty),
  (.[1]?[]?[1]?[]? // empty),
  (.[11]?[]?[1]?[]?[0]? // empty)
' | awk 'NF && !seen[$0]++')

[ -z "$CANDIDATES" ] && exit 0

# Step 4: Show candidate options in dmenu
CHOSEN=$(echo "$CANDIDATES" | rofi -dmenu -p "Select translation" -mesg "Original: $QUERY")
[ -z "$CHOSEN" ] && exit 0

# Step 5: Copy chosen variant to clipboard
echo -n "$CHOSEN" | wl-copy 2>/dev/null || echo -n "$CHOSEN" | xclip -selection clipboard 2>/dev/null