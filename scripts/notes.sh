#!/usr/bin/env bash

set -u

NOTES_DIR="$HOME/.notes"
NOTES_THEME="$HOME/env/config/rofi/notes.rasi"
INPUT_THEME="$HOME/env/config/rofi/notes-input.rasi"

mkdir -p "$NOTES_DIR"

add_note() {
	local notes_file="$1"
	local note

	note="$(
		rofi \
			-dmenu \
			-p "New note" \
			-theme "$INPUT_THEME"
	)" || return 0

	[[ -z "$note" ]] && return 0

	printf '%s\n' "- [ ] $note" >>"$notes_file"
}

toggle_task() {
	local notes_file="$1"
	local task_index="$2"
	local tmp

	tmp="$(mktemp)" || return 1

	if ! awk -v target="$task_index" '
    /^- \[ \] / {
        task++

        if (task == target) {
            sub(/^- \[ \] /, "- [x] ")
        }
    }

    {
        print
    }
  ' "$notes_file" >"$tmp"; then
		rm -f "$tmp"
		return 1
	fi

	if ! mv "$tmp" "$notes_file"; then
		rm -f "$tmp"
		return 1
	fi
}

add_category() {
	local category

	category="$(
		rofi \
			-dmenu \
			-p "New category" \
			-theme "$INPUT_THEME"
	)" || return 0

	[[ -z "$category" ]] && return 0

	# Category names become filenames, so reject path separators
	# and names that could escape the notes directory.
	[[ "$category" == "." || "$category" == ".." ]] && return 0
	[[ "$category" == */* ]] && return 0

	# Avoid accidentally overwriting an existing category.
	if [[ -e "$NOTES_DIR/$category.md" ]]; then
		rofi -e "Category already exists: $category"
		return 0
	fi

	touch "$NOTES_DIR/$category.md"
}

open_category() {
	local category="$1"
	local notes_file="$NOTES_DIR/$category.md"
	local menu task_count selected_index task_index

	touch "$notes_file"

	while true; do
		menu="$(
			awk '
        /^- \[ \] / {
            line = $0
            sub(/^- \[ \] /, "", line)
            print "○  " line
        }
      ' "$notes_file"

			printf '%s\n' "＋  New note..."
			printf '%s\n' "←  Back to categories"
		)"

		task_count="$(
			awk '
        /^- \[ \] / { count++ }
        END { print count + 0 }
      ' "$notes_file"
		)"

		selected_index="$(
			printf '%s\n' "$menu" |
				rofi \
					-dmenu \
					-no-custom \
					-format i \
					-p "$category" \
					-theme "$NOTES_THEME" \
					-kb-row-down "j" \
					-kb-row-up "k" \
					-kb-accept-entry "Return,space"
		)" || return 0

		[[ -z "$selected_index" ]] && return 0

		# New note is the first entry after all open tasks.
		if ((selected_index == task_count)); then
			add_note "$notes_file"
			continue
		fi

		# Back is the final entry.
		if ((selected_index == task_count + 1)); then
			return 0
		fi

		# Convert Rofi's zero-based index to the one-based task index.
		task_index=$((selected_index + 1))

		toggle_task "$notes_file" "$task_index"
	done
}

while true; do
	# Build the category list from *.md filenames.
	# The temporary array keeps category indices aligned with Rofi.
	categories=()

	while IFS= read -r -d '' file; do
		categories+=("${file##*/}")
	done < <(
		find "$NOTES_DIR" \
			-maxdepth 1 \
			-type f \
			-name '*.md' \
			-print0 |
			sort -z
	)

	menu=""

	for file in "${categories[@]}"; do
		category="${file%.md}"

		# Show the number of open tasks beside each category.
		count="$(
			awk '/^- \[ \] / { count++ } END { print count + 0 }' \
				"$NOTES_DIR/$file"
		)"

		menu+=$(printf '%s\n' "▸  $category ($count)")
		menu+=$'\n'
	done

	menu+="＋  New category..."

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

	# Last entry is New category.
	if ((selected_index == ${#categories[@]})); then
		add_category
		continue
	fi

	category="${categories[$selected_index]%.md}"
	open_category "$category"
done
