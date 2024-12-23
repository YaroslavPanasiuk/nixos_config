{ pkgs }:

pkgs.writeShellScriptBin "reload_firefox.sh" '' 
#!/usr/bin/env bash

# Step 1: Save the workspaces of all Firefox windows
# Requires `jq` to parse the Hyprland JSON output
FIREFOX_WINDOWS=$(hyprctl clients -j | jq -c '.[] | select(.class == "firefox")')
if [ -z "$FIREFOX_WINDOWS" ]; then
    echo "No Firefox windows found."
    exit 0
fi

# Create an array to store workspace numbers
declare -A WORKSPACE_MAP

echo "Saving Firefox windows' workspaces..."
while IFS= read -r WINDOW; do
    WINDOW_ADDRESS=$(echo "$WINDOW" | jq -r '.address')
    WORKSPACE_ID=$(echo "$WINDOW" | jq -r '.workspace.id')
    WORKSPACE_MAP["$WINDOW_ADDRESS"]="$WORKSPACE_ID"
    echo "Window $WINDOW_ADDRESS is on workspace $WORKSPACE_ID."
done <<< "$FIREFOX_WINDOWS"

# Step 2: Close all Firefox windows
echo "Closing all Firefox windows..."
pkill -9 firefox

# Wait briefly to ensure all Firefox processes are terminated
sleep 1

# Step 3: Reopen Firefox on the same workspaces
echo "Reopening Firefox windows..."
for WORKSPACE in "''${WORKSPACE_MAP[@]}"; do
    echo "Opening Firefox on workspace $WORKSPACE..."
    # Change workspace and launch Firefox
    hyprctl dispatch exec "[workspace $WORKSPACE silent] firefox"
done
''
