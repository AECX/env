#!/usr/bin/env bash

set -u

NOTES_FILE="$HOME/.notes"
NOTES_THEME="$HOME/env/config/rofi/notes.rasi"
INPUT_THEME="$HOME/env/config/rofi/notes-input.rasi"

mkdir -p "$(dirname "$NOTES_FILE")"
touch "$NOTES_FILE"

add_note() {
  local note

  note="$(
    rofi \
      -dmenu \
      -p "New note" \
      -theme "$INPUT_THEME"
  )" || return 0

  [[ -z "$note" ]] && return 0

  printf '%s\n' "- [ ] $note" >>"$NOTES_FILE"
}

toggle_task() {
  local task_index="$1"
  local tmp

  tmp="$(mktemp)"

  awk -v target="$task_index" '
    /^- \[ \] / {
        task++

        if (task == target) {
            sub(/^- \[ \] /, "- [x] ")
        }
    }

    {
        print
    }
  ' "$NOTES_FILE" >"$tmp"

  mv "$tmp" "$NOTES_FILE"
}

while true; do

  menu="$(
    awk '
      /^- \[ \] / {
          line = $0
          sub(/^- \[ \] /, "", line)
          print "○  " line
      }
    ' "$NOTES_FILE"

    printf '%s\n' "＋  New note..."
  )"

  task_count="$(
    awk '
      /^- \[ \] / {
          count++
      }

      END {
          print count + 0
      }
    ' "$NOTES_FILE"
  )"

  selected_index="$(
    printf '%s\n' "$menu" |
      rofi \
        -dmenu \
        -no-custom \
        -format i \
        -p "Notes" \
        -theme "$NOTES_THEME" \
        -kb-row-down "j" \
        -kb-row-up "k" \
        -kb-accept-entry "Return,space"
  )" || exit 0

  [[ -z "$selected_index" ]] && exit 0

  # Last entry is "New note..."
  if ((selected_index == task_count)); then
    add_note
    continue
  fi

  # Convert Rofi's zero-based index to our one-based task index.
  task_index=$((selected_index + 1))

  toggle_task "$task_index"

done
