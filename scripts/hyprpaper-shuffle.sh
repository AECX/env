#!/usr/bin/env bash

pkill hyprpaper && hyprpaper &

WALLDIR="$HOME/env/wallpapers"
INTERVAL=10

while true; do
	WALL=$(find "$WALLDIR" -type f \( \
		-iname "*.jpg" -o \
		-iname "*.jpeg" -o \
		-iname "*.png" -o \
		-iname "*.webp" \
		\) | shuf -n 1)

	[ -z "$WALL" ] && {
		echo "No wallpapers found in $WALLDIR"
		exit 1
	}

	hyprctl hyprpaper wallpaper ",$WALL"

	sleep "$INTERVAL"
done
