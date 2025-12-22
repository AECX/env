#!/usr/bin/env bash
hyprctl switchxkblayout all next
CURRENT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')
notify-send -u normal "Keyboard" "Switched to $CURRENT"
