hl.window_rule({
	match = {
		class = "com.mitchellh.ghostty",
		fullscreen = true,
	},
	opacity = 0.7,
})

hl.window_rule({
	match = {
		class = "Alacritty",
	},
	tag = "+glass",
})

hl.window_rule({
	match = {
		class = "com.nextcloud.desktopclient.nextcloud",
	},
	tag = "+float",
})

hl.window_rule({
	match = {
		class = "blueman-manager",
	},
	tag = "+float",
})

hl.window_rule({
	match = {
		tag = "glass",
	},
	opacity = 0.8,
})

hl.window_rule({
	match = {
		tag = "float",
	},
	float = true,
})

hl.window_rule({
	match = { workspace = "special:notes" },
	opacity = "0.7 override",
})

hl.window_rule({
	match = { workspace = "special:special" },
	opacity = "0.7 override",
})

hl.window_rule({
	match = {
		class = "com.nextcloud.desktopclient.nextcloud",
	},
	size = "430 800",
	move = "2800 50",
})

hl.window_rule({
	match = {
		class = "blueman-manager",
	},
	size = "430 800",
	move = "2800 50",
})

hl.window_rule({
	match = {
		pin = true,
		focus = false,
	},
	opacity = "0.6 override",
})

hl.window_rule({
	match = {
		title = "Picture-in-Picture",
	},
	pin = true,
	float = true,
	size = "720 405",
	move = "2650 960",
})

hl.window_rule({
	match = {
		title = "^nvim.*$",
	},
	opacity = 1.0,
})
