-----------------
----- INPUT -----
-----------------

hl.config({
    input = {
        kb_layout = "latam, us",
        accel_profile = "flat",
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
