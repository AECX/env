#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="$SCRIPT_DIR/config"
BACKUP_DIR="$SCRIPT_DIR/backup"
TARGET_DIR="$HOME/.config"

# Packages available from the regular Arch repositories.
PACKAGES=(
  hyprlock
  grim
  slurp
  wl-clipboard
  rofi
  waybar
  dunst
)

usage() {
  echo "Usage: $0 {activate|remove|install}"
  echo
  echo "Commands:"
  echo "  activate   Activate config symlinks"
  echo "  remove     Remove config symlinks and restore backups"
  echo "  install    Install required packages"
}

activate_configs() {
  echo "==> Installing config files..."

  mkdir -p "$TARGET_DIR" "$BACKUP_DIR"

  shopt -s nullglob

  for source in "$CONFIG_DIR"/*; do
    [[ -d "$source" ]] || continue

    name="$(basename "$source")"
    target="$TARGET_DIR/$name"
    backup="$BACKUP_DIR/$name"

    echo "-> $name"

    # Already correctly linked.
    if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
      echo "   already linked"
      continue
    fi

    # Back up an existing config.
    if [[ -e "$target" || -L "$target" ]]; then
      if [[ -e "$backup" || -L "$backup" ]]; then
        echo "   backup already exists: $backup"
        echo "   refusing to overwrite it"
        continue
      fi

      echo "   backing up $target -> $backup"
      mv "$target" "$backup"
    fi

    echo "   linking $target -> $source"
    ln -s "$source" "$target"
  done

  echo "==> Done."
}

remove_configs() {
  echo "==> Removing config symlinks and restoring backups..."

  if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "No backup directory found."
    return 0
  fi

  shopt -s nullglob

  for backup in "$BACKUP_DIR"/*; do
    [[ -d "$backup" ]] || continue

    name="$(basename "$backup")"
    target="$TARGET_DIR/$name"

    echo "-> $name"

    # Only remove a symlink. Never delete a real config here.
    if [[ -L "$target" ]]; then
      echo "   removing symlink $target"
      rm "$target"
    elif [[ -e "$target" ]]; then
      echo "   WARNING: $target exists and is not a symlink"
      echo "   refusing to remove it"
      continue
    fi

    echo "   restoring $backup -> $target"
    mv "$backup" "$target"
  done

  # Remove the backup directory if it is now empty.
  if [[ -d "$BACKUP_DIR" ]] && [[ -z "$(find "$BACKUP_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]]; then
    rmdir "$BACKUP_DIR"
  fi

  echo "==> Done."
}

install_packages() {
  echo "==> Installing packages..."

  if ! command -v pacman >/dev/null 2>&1; then
    echo "ERROR: This package installer currently supports Arch Linux/pacman."
    exit 1
  fi

  sudo pacman -Syu --needed "${PACKAGES[@]}"

  # hyprshade is available through the AUR.
  if command -v paru >/dev/null 2>&1; then
    echo "==> Installing hyprshade with paru..."
    paru -S --needed hyprshade
  elif command -v yay >/dev/null 2>&1; then
    echo "==> Installing hyprshade with yay..."
    yay -S --needed hyprshade
  else
    echo
    echo "WARNING: hyprshade is an AUR package."
    echo "Install an AUR helper (e.g. paru/yay), then run:"
    echo "  paru -S hyprshade"
    echo
  fi

  echo "==> Package installation done."
}

main() {
  case "${1:-}" in
  activate)
    activate_configs
    ;;

  remove)
    remove_configs
    ;;

  install)
    install_packages
    ;;

  *)
    usage
    exit 1
    ;;
  esac
}

main "$@"
