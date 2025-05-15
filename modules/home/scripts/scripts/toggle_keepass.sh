#!/usr/bin/env bash

APP_NAME="KeePass2"
CMD="/etc/profiles/per-user/hannes/bin/keepass"

# Get the current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Check if it's already running
if pgrep -f "$CMD" > /dev/null; then
    # Find and manipulate window
    
    if [ -n "$WIN_ID" ]; then
        # Move KeePass to the active workspace (instead of moving focus)
        hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$WIN_ID"
        # Make it floating
        hyprctl dispatch focuswindow address:$WIN_ID
        toggle_float
        exit 0
    fi
else
    # Launch KeePass
    "$CMD" &
    sleep 1
    # Wait a bit for window to spawn
    for i in {1..10}; do
        WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_NAME\") | .address")
        if [ -n "$WIN_ID" ]; then
            hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$WIN_ID"
            # Make it floating
            hyprctl dispatch focuswindow address:$WIN_ID
            toggle_float
            break
        fi
        sleep 0.2
    done
fi
