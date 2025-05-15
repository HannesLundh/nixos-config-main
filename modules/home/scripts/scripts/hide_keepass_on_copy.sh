#!/usr/bin/env bash

# This script watches for clipboard changes and moves KeePass2 to workspace 9 if it was the active window.

APP_NAME="KeePass2"
TARGET_WS="9"

wl-paste --watch --no-newline --type text/plain --infinite | while read -r new_clip; do
    # Get the currently focused window class
    FOCUSED_CLASS=$(hyprctl activewindow -j | jq -r '.class')

    if [ "$FOCUSED_CLASS" = "$APP_NAME" ]; then
        # Get the window address
        WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_NAME\") | .address")
        if [ -n "$WIN_ID" ]; then
            # Move it to workspace 9
            hyprctl dispatch movetoworkspacesilent "$TARGET_WS,address:$WIN_ID"
        fi
    fi
done
