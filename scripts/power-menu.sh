#!/usr/bin/env bash

dir="$HOME/.config/rofi"
theme="power-menu"

uptime=$(uptime -p | sed 's/up //')
host=$(hostname)

shutdown=''
reboot='󰜉'
lock='󰌾'
suspend='󰤄'
logout='󰍃'

rofi_cmd() {
    rofi -dmenu \
        -i \
        -normal-window \
        -hover-select \
        -me-select-entry MousePrimary \
        -no-click-to-exit \
        -theme "${dir}/${theme}.rasi" \
        -p "Goodbye $USER" \
        -mesg "Uptime: $uptime"
}

chosen="$(printf "%s\n%s\n%s\n%s\n%s\n" \
    "$lock" \
    "$suspend" \
    "$logout" \
    "$reboot" \
    "$shutdown" | rofi_cmd)"

case "$chosen" in
    "$shutdown")
        pkill rofi
        systemctl poweroff
        ;;

    "$reboot")
        pkill rofi
        systemctl reboot
        ;;

    "$lock")
	rofi_pid=$(pgrep -x rofi)
	[ -n "$rofi_pid" ] && kill "$rofi_pid"

	hyprctl dispatch exec "sleep .5 && hyprlock"
        ;;

    "$suspend")
        pkill rofi
        mpc -q pause 2>/dev/null
        amixer set Master mute 2>/dev/null
        systemctl suspend
        ;;

    "$logout")
        pkill rofi
        hyprctl dispatch exit
        ;;
esac
