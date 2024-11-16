local colors <const> = require("config.colors")
local fonts <const> = require("config.fonts")
local icons <const> = require("config.icons")
local dimens <const> = require("config.dimens")

return {
    modes = {
        main = {
            icon = icons.rebel,
            color = colors.rainbow[1],
        },
        service = {
            icon = icons.nuke,
            color = 0xffff9e64,
        },
    },
    items = {
        height = 26,
        gap = 5,
        padding = {
            right = 16,
            left = 12,
            top = 0,
            bottom = 0,
        },
        default_color = function(workspace)
            return colors.rainbow[workspace + 1]
        end,
        highlight_color = function(workspace)
            return colors.yellow
        end,
        colors = {
            background = colors.bg1,
        },
        corner_radius = 6,
    },

    fonts = fonts,
    dimens = dimens,
    colors = colors,
    icons = icons,
}
