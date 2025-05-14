#!/bin/bash

APP_NAME="KeePass2"
CMD="/etc/profiles/per-user/hannes/bin/keepass"

# Check if it's already running
if pgrep -f "$CMD" > /dev/null; then
    # Find and focus window
    WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_NAME\") | .address")
    if [ -n "$WIN_ID" ]; then
        hyprctl dispatch focuswindow address:$WIN_ID
        hyprctl dispatch bringactivetotop
        hyprctl dispatch togglefloating address:$WIN_ID
        exit 0
    fi
else
    # Launch KeePass
    "$CMD" &
    sleep 1
fi
