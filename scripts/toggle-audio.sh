#!/usr/bin/env bash

MODE="$1"

SINK_A="alsa_output.usb-SMSL_SMSL_USB_AUDIO-00.analog-stereo"
SINK_B="alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output"

CURRENT=$(pactl get-default-sink)


if [[ "$CURRENT" == "$SINK_A" ]]; then
    NEXT="$SINK_B"
    NAME="Speakers"
    CURRENT_NAME="Headphones"
else
    NEXT="$SINK_A"
    NAME="Headphones"
    CURRENT_NAME="Speakers"
fi
if [[ "$MODE" == "toggle" ]]; then
    pactl set-default-sink "$NEXT"
    
    for INPUT in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$INPUT" "$NEXT"
    done
    echo "$NAME"
else
    echo "$CURRENT_NAME"
fi
