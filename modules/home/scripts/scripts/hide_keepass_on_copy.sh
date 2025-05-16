#!/usr/bin/env bash

APP_NAME="org.keepassxc.KeePassXC"
TARGET_WS="9"
LAST_CLIP=""

while true; do
    CLIP=$(wl-paste --no-newline 2>/dev/null)

    # Only react to new clipboard content
    if [[ "$CLIP" != "$LAST_CLIP" && -n "$CLIP" ]]; then
        LAST_CLIP="$CLIP"

        # Check if KeePass2 is focused
        FOCUSED_CLASS=$(hyprctl activewindow -j | jq -r '.class')

        if [ "$FOCUSED_CLASS" = "$APP_NAME" ]; then
            WIN_ID=$(hyprctl clients -j | jq -r ".[] | select(.class==\"$APP_NAME\") | .address")
            if [ -n "$WIN_ID" ]; then
                hyprctl dispatch movetoworkspacesilent "$TARGET_WS,address:$WIN_ID"
            fi
        fi
    fi

    sleep 0.2
done
