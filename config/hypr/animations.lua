hl.curve("easeOut", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("easeInOut", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })
hl.curve("snap", { type = "bezier", points = { { 0.12, 0.9 }, { 0.15, 1 } } })
hl.curve("fast", { type = "bezier", points = { { 0.2, 0.9 }, { 0.1, 1 } } })
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 2,
    bezier = "snap",
    style = "popin 80%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 3,
    bezier = "fast",
    style = "popin 70%",
})
hl.animation({
    leaf = "border",
    enabled = true,
    speed = 4,
    bezier = "easeOut",
})
hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 4,
    bezier = "easeInOut",
})
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1,
    bezier = "easeOut",
    style = "slide",
})
hl.animation({
    leaf = "specialWorkspace",
    enabled = true,
    speed = 4,
    bezier = "snap",
    style = "slidevert",
})
hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 3,
    bezier = "snap",
})

hl.config({
    animations = {
        enabled = true,
        -- Bezier curves
        -- Window open / close
        -- Borders
        -- Fade (used for dialogs, menus)
        -- Workspaces
        -- Layer surfaces (Waybar, notifications)
    },
})

