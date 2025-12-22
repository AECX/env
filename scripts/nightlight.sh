#!/usr/bin/env bash

STATE=/tmp/hyprsunset-nightlight

if [[ "$1" == "toggle" ]]; then
    if [[ -f "$STATE" ]]; then
        hyprctl hyprsunset identity
        rm "$STATE"
    else
        hyprctl hyprsunset temperature 4500
        touch "$STATE"
    fi
    exit 0
fi

if [[ -f "$STATE" ]]; then
    printf '{"text":"󰖨","tooltip":"Night light on (click to disable)","alt":"on"}\n'
else
    printf '{"text":"󰛨","tooltip":"Night light off (click to enable)","alt":"off"}\n'
fi
