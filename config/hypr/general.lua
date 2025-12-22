terminal = "foot"
filebrowser = "nautilus"
browser = "librewolf"
menu = "~/env/scripts/launcher.sh"
powermenu = "~/env/scripts/power-menu.sh"
screenshot = 'grim -g "$(slurp)" - | wl-copy'
nightlight = "~/env/scripts/nightlight.sh toggle"
cyclekeyboard = "~/env/scripts/cycle-kb.sh"
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
		split_width_multiplier = 1.0,
	},
})
