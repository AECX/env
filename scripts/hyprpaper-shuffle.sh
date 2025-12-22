#!/usr/bin/env bash

WALLDIR="$HOME/env/wallpapers"

while true; do
    WALL=$(find "$WALLDIR" -type f | shuf -n 1)
    
    hyprctl hyprpaper preload "$WALL"
    hyprctl hyprpaper wallpaper "DP-1,$WALL"
    hyprctl hyprpaper wallpaper "HDMI-A-1,$WALL"

    sleep 10
done
