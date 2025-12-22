#!/usr/bin/env bash

MODE="$1"

declare -A ALIAS=(
	["alsa_output.usb-SMSL_SMSL_USB_AUDIO-00.analog-stereo"]="Headphone"
	["alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output"]="Speaker"
	["bluez_output.EC_73_79_43_3F_68.1"]="AirPods"
)

mapfile -t SINKS < <(pactl list short sinks | awk '{print $2}')

CURRENT=$(pactl get-default-sink)

CURRENT_INDEX=0
for i in "${!SINKS[@]}"; do
	if [[ "${SINKS[$i]}" == "$CURRENT" ]]; then
		CURRENT_INDEX=$i
		break
	fi
done

CURRENT_NAME="${ALIAS[$CURRENT]:-$CURRENT}"

if [[ "$MODE" == "toggle" ]]; then
	NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#SINKS[@]}))
	NEXT="${SINKS[$NEXT_INDEX]}"

	pactl set-default-sink "$NEXT"

	while read -r INPUT; do
		pactl move-sink-input "$INPUT" "$NEXT"
	done < <(pactl list short sink-inputs | awk '{print $1}')

	echo "${ALIAS[$NEXT]:-$NEXT}"
else
	echo "$CURRENT_NAME"
fi
