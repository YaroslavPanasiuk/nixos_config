#!/usr/bin/env bash

# Check if any media player is playing
if playerctl status --all-players 2>/dev/null | grep -q "Playing"; then
    echo "Media is playing, preventing sleep/lock."
    exit 1  # Exit with non-zero status to prevent sleep/lock
else
    echo "No media playing, allowing sleep/lock."
    exit 0  # Exit with zero status to allow sleep/lock
fi