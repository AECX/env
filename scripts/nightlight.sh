#!/usr/bin/env bash

STATE=/tmp/hyprsunset-nightlight

if [ -f "$STATE" ]; then
    hyprctl hyprsunset identity
    rm "$STATE"
else
    hyprctl hyprsunset temperature 4500
    touch "$STATE"
fi
