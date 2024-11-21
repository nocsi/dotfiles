local constants = require("constants")

local timemachine = sbar.add("item", constants.items.TIMEMACHINE, {
    position = "right",
    update_freq = 30,
    icon = { padding_left = 0, padding_right = 0 },
})

local function update()
    local command = "~/.scripts/timemachine.sh"
    sbar.exec(command, function(result)
        local label = string.match(result, "Label:%s*(.-)\n")
        local color = string.match(result, "Color:%s*(.-)\n")

        local icon = "default"

        timemachine:set({
            label = {
                string = label,
                color = color,
            },
            icon = icon,
        })
    end)
end

timemachine:subscribe({ "forced", "routine" }, update)

timemachine:subscribe("mouse.clicked", function(env)
    sbar.exec("open -a 'Calendar'")
end)
