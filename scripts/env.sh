#!/usr/bin/env bash

export XDG_DATA_DIRS="/usr/local/share:/usr/share"
export XDG_SESSION_TYPE="wayland"
export XDG_SESSION_DESKTOP="hyprland"

export GTK3_RC_FILES="$HOME/.config/gtk-3.0/settings.ini"
export GTK4_RC_FILES="$HOME/.config/gtk-4.0/settings.ini"
export XDG_CURRENT_DESKTOP="GNOME"

export HYPRCURSOR_THEME="Bibata-Modern-Ice"
export HYPRCURSOR_SIZE=30

export XCURSOR_THEME="Bibata-Modern-Ice"
export XCURSOR_SIZE=30

hyprctl setcursor Bibata-Modern-Ice 34

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Tela-black-dark'

gsettings set org.gnome.desktop.interface font-name 'Geist 14'
gsettings set org.gnome.desktop.interface monospace-font-name 'Agave Nerd Font Mono 12'

gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface cursor-size 24
