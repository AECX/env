#!/usr/bin/env bash

out="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"

muted=false
vol=0

if [[ "$out" == *MUTED* ]]; then
    muted=true
else
    # extract volume safely (works with PipeWire formats)
    vol="$(awk '{print int($2 * 100)}' <<< "$out")"
fi

if $muted; then
    printf '󰍭 00%%'
else
    printf '󰍬 %d%%' "$vol"
fi
