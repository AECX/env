#!/usr/bin/env bash

if [[ "$1" == "toggle" ]]; then
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  exit 0
fi

out="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"

muted=false
vol=0

if [[ "$out" == *MUTED* ]]; then
  muted=true
else
  vol="$(awk '{print int($2 * 100)}' <<<"$out")"
fi

if $muted; then
  printf '{"text":"󰍭 Muted","class":"muted"}'
else
  printf '{"text":"󰍬 %d%%","class":""}' "$vol"
fi
