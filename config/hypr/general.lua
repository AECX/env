
terminal = "ghostty"
filebrowser = "nautilus"
browser = "librewolf"
menu = "rofi -show drun -theme ~/.config/rofi/theme.rasi -show-icons -drun-show-actions"
cyclekeyboard = "hyprctl switchxkblayout all next"
mainMod = "SUPER"

require("monitor")
require("input")
require("keybinds")
require("decoration")
require("windowrules")
require("autostart")
require("animations")

hl.config({
    general = {
        layout = "dwindle",
    },
    dwindle = {
        preserve_split = true,
        permanent_direction_override = true,
        split_width_multiplier = 1.0
    },
})

