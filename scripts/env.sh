#!/usr/bin/env bash

export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_SESSION_DESKTOP="Hyprland"
export XDG_CURRENT_DESKTOP="Hyprland"
export XDG_SESSION_TYPE="wayland"
export XDG_CONFIG_HOME="$HOME/.config"

export GTK3_RC_FILES="$HOME/.config/gtk-3.0/settings.ini"
export GTK4_RC_FILES="$HOME/.config/gtk-4.0/settings.ini"

export CURSOR_THEME=Sweet-cursors-hyprcursor
export CURSOR_THEME_X=Sweet-cursors
export CURSOR_SIZE=32
export CURSOR_SIZE_X=28

hyprctl setcursor $CURSOR_THEME $CURSOR_SIZE

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-black-dark'

gsettings set org.gnome.desktop.interface font-name 'Inter 14'
gsettings set org.gnome.desktop.interface monospace-font-name 'GeistMono Nerd Font Mono 12'

gsettings set org.gnome.desktop.interface cursor-theme "$CURSOR_THEME_X"
gsettings set org.gnome.desktop.interface cursor-size $CURSOR_SIZE_X

dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets
