#!/usr/bin/env bash

set -u

STATE="$HOME/.timer-state"
ROFI_THEME="$HOME/env/config/rofi/timer.rasi"
SCRIPT="$HOME/env/scripts/timer.sh"

# System alarm sound.
ALARM_SOUND="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"

mkdir -p "$(dirname "$STATE")"

remaining_seconds() {
  [[ -f "$STATE" ]] || return 1

  local end now remaining

  end="$(cat "$STATE" 2>/dev/null || true)"
  [[ "$end" =~ ^[0-9]+$ ]] || return 1

  now="$(date +%s)"
  remaining=$((end - now))

  if ((remaining <= 0)); then
    rm -f "$STATE"
    return 1
  fi

  printf '%s\n' "$remaining"
}

format_time() {
  local total="$1"
  local hours=$((total / 3600))
  local minutes=$(((total % 3600) / 60))
  local seconds=$((total % 60))

  if ((hours > 0)); then
    printf '%d:%02d:%02d' "$hours" "$minutes" "$seconds"
  else
    printf '%02d:%02d' "$minutes" "$seconds"
  fi
}

play_alarm() {
  # Play the alarm for approximately 3 seconds.
  #
  # paplay blocks until the sound finishes, so we run it in
  # the background and stop it after 3 seconds.

  if ! command -v paplay >/dev/null 2>&1; then
    notify-send \
      -u critical \
      -a "Timer" \
      "Timer finished" \
      "Your timer is complete, but paplay was not found."
    return
  fi

  if [[ ! -f "$ALARM_SOUND" ]]; then
    notify-send \
      -u critical \
      -a "Timer" \
      "Timer finished" \
      "Your timer is complete, but the alarm sound was not found."
    return
  fi

  paplay "$ALARM_SOUND" >/dev/null 2>&1 &
  local sound_pid=$!

  sleep 3

  kill "$sound_pid" 2>/dev/null || true
  wait "$sound_pid" 2>/dev/null || true
}

start_timer() {
  local minutes="$1"
  local end

  end=$(($(date +%s) + minutes * 60))

  printf '%s\n' "$end" >"$STATE"

  # Start an alarm tied to this exact end timestamp.
  #
  # setsid makes the alarm independent from the Rofi process.
  setsid "$SCRIPT" --alarm "$end" >/dev/null 2>&1 &

  pkill -RTMIN+8 waybar 2>/dev/null || true

  notify-send \
    -a "Timer" \
    "Timer started" \
    "$(format_time $((minutes * 60)))"
}

cancel_timer() {
  rm -f "$STATE"

  pkill -RTMIN+8 waybar 2>/dev/null || true

  notify-send \
    -a "Timer" \
    "Timer cancelled" \
    "The timer has been cancelled."
}

alarm() {
  local expected_end="$1"
  local remaining current_end

  while true; do
    [[ -f "$STATE" ]] || exit 0

    current_end="$(cat "$STATE" 2>/dev/null || true)"

    # A new timer replaced this alarm.
    [[ "$current_end" == "$expected_end" ]] || exit 0

    remaining="$(remaining_seconds 2>/dev/null || true)"

    if [[ -z "$remaining" ]]; then
      exit 0
    fi

    sleep "$remaining"

    [[ -f "$STATE" ]] || exit 0

    current_end="$(cat "$STATE" 2>/dev/null || true)"

    # Timer was replaced while we were sleeping.
    [[ "$current_end" == "$expected_end" ]] || exit 0

    remaining="$(remaining_seconds 2>/dev/null || true)"

    if [[ -z "$remaining" ]]; then
      rm -f "$STATE"

      notify-send \
        -u critical \
        -a "Timer" \
        "Timer finished" \
        "Your timer is complete."

      pkill -RTMIN+8 waybar 2>/dev/null || true

      # Ring for 3 seconds.
      play_alarm

      exit 0
    fi
  done
}

picker() {
  local current_seconds
  local current_minutes
  local selected_row
  local result
  local minutes
  local prompt
  local menu
  local exit_code

  current_seconds="$(remaining_seconds 2>/dev/null || true)"

  if [[ -n "$current_seconds" ]]; then
    current_minutes=$(((current_seconds + 59) / 60))

    ((current_minutes < 1)) && current_minutes=1
    ((current_minutes > 120)) && current_minutes=120
  else
    current_minutes=15
  fi

  # Descending order is intentional:
  #
  # scroll UP   -> previous row -> MORE minutes
  # scroll DOWN -> next row     -> FEWER minutes
  #
  # Range: 1–120 minutes.

  menu="$(
    for minutes in $(seq 120 -1 1); do
      if ((minutes >= 60)); then
        printf '%d:%02d\n' \
          $((minutes / 60)) \
          $((minutes % 60))
      else
        printf '%d min\n' "$minutes"
      fi
    done

    printf '%s\n' "Cancel timer"
  )"

  # Map current minute value to the descending list.
  selected_row=$((120 - current_minutes))

  if [[ -n "$current_seconds" ]]; then
    prompt="Timer  $(format_time "$current_seconds")"
  else
    prompt="Timer"
  fi

  result="$(
    printf '%s\n' "$menu" |
      rofi \
        -dmenu \
        -no-custom \
        -p "$prompt" \
        -format i \
        -selected-row "$selected_row" \
        -mesg "↑ / scroll up  +1 min     ↓ / scroll down  −1 min     Enter  start" \
        -theme "$ROFI_THEME"
  )"

  exit_code=$?

  # Escape / closing Rofi.
  if ((exit_code != 0)); then
    exit 0
  fi

  [[ "$result" =~ ^[0-9]+$ ]] || exit 0

  # Row 120 is "Cancel timer".
  if ((result == 120)); then
    cancel_timer
    exit 0
  fi

  # Convert descending row index back to minutes.
  minutes=$((120 - result))

  ((minutes < 1)) && minutes=1
  ((minutes > 120)) && minutes=120

  start_timer "$minutes"
}

waybar() {
  local remaining formatted

  remaining="$(remaining_seconds 2>/dev/null || true)"

  if [[ -z "$remaining" ]]; then
    printf '{"text":"No Timer","class":"inactive"}'
    exit 0
  fi

  formatted="$(format_time "$remaining")"

  printf \
    '{"text":"󰥔 %s","class":"active","tooltip":"Timer: %s\\nLeft click: adjust\\nRight click: cancel"}' \
    "$formatted" \
    "$formatted"
}

case "${1:-}" in
--alarm)
  alarm "${2:?missing end timestamp}"
  ;;

--waybar)
  waybar
  ;;

--cancel)
  cancel_timer
  ;;

*)
  picker
  ;;
esac
