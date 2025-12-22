#!/usr/bin/env bash

set -u

STATE="$HOME/.stopwatch-state"
SCRIPT="$HOME/env/scripts/stopwatch"

# State format:
#   stopped
#   running
#
# Followed by:
#   elapsed milliseconds
#   started-at milliseconds (only while running)

mkdir -p "$(dirname "$STATE")"

now_ms() {
  date +%s%3N
}

format_time() {
  local total_seconds="$1"
  local minutes=$((total_seconds / 60))
  local seconds=$((total_seconds % 60))

  printf '%02d:%02d' "$minutes" "$seconds"
}

read_state() {
  local status elapsed started

  if [[ ! -f "$STATE" ]]; then
    printf 'stopped\n0\n0\n'
    return
  fi

  {
    read -r status
    read -r elapsed
    read -r started
  } <"$STATE"

  [[ "$status" == "running" || "$status" == "stopped" ]] || status="stopped"
  [[ "$elapsed" =~ ^[0-9]+$ ]] || elapsed=0
  [[ "$started" =~ ^[0-9]+$ ]] || started=0

  printf '%s\n%s\n%s\n' "$status" "$elapsed" "$started"
}

write_state() {
  local status="$1"
  local elapsed="$2"
  local started="$3"
  local tmp

  tmp="$(mktemp)"

  printf '%s\n%s\n%s\n' \
    "$status" \
    "$elapsed" \
    "$started" >"$tmp"

  mv "$tmp" "$STATE"
}

elapsed_ms() {
  local status elapsed started now

  mapfile -t state < <(read_state)

  status="${state[0]}"
  elapsed="${state[1]}"
  started="${state[2]}"

  if [[ "$status" == "running" ]]; then
    now="$(now_ms)"
    elapsed=$((elapsed + now - started))
  fi

  printf '%s\n' "$elapsed"
}

start() {
  local elapsed started

  mapfile -t state < <(read_state)

  elapsed="${state[1]}"
  started="$(now_ms)"

  write_state "running" "$elapsed" "$started"
}

stop() {
  local elapsed started now

  mapfile -t state < <(read_state)

  elapsed="${state[1]}"
  started="${state[2]}"

  now="$(now_ms)"
  elapsed=$((elapsed + now - started))

  write_state "stopped" "$elapsed" 0
}

reset() {
  write_state "stopped" 0 0
}

toggle() {
  mapfile -t state < <(read_state)

  case "${state[0]}" in
  running)
    stop
    ;;
  stopped)
    if ((state[1] > 0)); then
      reset
    else
      start
    fi
    ;;
  esac
}

waybar() {
  local elapsed seconds status

  mapfile -t state < <(read_state)

  status="${state[0]}"
  elapsed="$(elapsed_ms)"
  seconds=$((elapsed / 1000))

  if [[ "$status" == "running" ]]; then
    printf \
      '{"text":"󱎫 %s","class":"active","tooltip":"Stopwatch: %s\\nLeft click: stop\\nRight click: reset"}\n' \
      "$(format_time "$seconds")" \
      "$(format_time "$seconds")"
  elif [[ "$seconds" == "0" ]]; then
    printf \
      '{"text":"󱎫 start","class":"inactive"}'
  else
    printf \
      '{"text":"󱎫 %s","class":"inactive","tooltip":"Stopwatch: %s\\nLeft click: %s\\nRight click: reset"}\n' \
      "$(format_time "$seconds")" \
      "$(format_time "$seconds")" \
      "$([[ "$seconds" -gt 0 ]] && printf 'reset' || printf 'start')"
  fi
}

case "${1:-}" in
--waybar)
  waybar
  ;;

--toggle)
  toggle
  ;;

--reset)
  reset
  ;;

--start)
  start
  ;;

--stop)
  stop
  ;;

*)
  toggle
  ;;
esac
