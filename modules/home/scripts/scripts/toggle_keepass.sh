#!/usr/bin/env bash

APP_NAME="KeePassXC"
CMD="/etc/profiles/per-user/hannes/bin/keepassxc"

# Get the current workspace
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

# Check if it's already running
if pgrep -af $APP_NAME > /dev/null; then
    # Find and manipulate window
    WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_NAME\") | .address")
    if [ -n "$WIN_ID" ]; then
        # Move KeePass to the active workspace (instead of moving focus)
        hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$WIN_ID"
        # Make it floating
        IS_FLOATING=$(hyprctl clients -j | jq -r ".[] | select(.address==\"$WIN_ID\") | .floating")
        hyprctl dispatch focuswindow address:$WIN_ID
        if [ "$IS_FLOATING" = "false" ]; then
            hyprctl dispatch togglefloating
            hyprctl dispatch resizeactive exact 500 500
            hyprctl dispatch centerwindow
        fi
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
            hyprctl dispatch togglefloating
            hyprctl dispatch resizeactive exact 500 500
            hyprctl dispatch centerwindow
            break
        fi
        sleep 0.2
    done
fi
