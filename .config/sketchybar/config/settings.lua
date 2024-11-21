local colors <const> = require("config.colors")
local fonts <const> = require("config.fonts")
local icons <const> = require("config.icons")
local dimens <const> = require("config.dimens")

return {
    paddings = 3,
    group_paddings = 5,

    -- This is a font configuration for SF Pro and SF Mono (installed manually)
    modes = {
        main = {
            icon = icons.text.apple,
            color = colors.rainbow[1],
        },
        service = {
            icon = icons.apple,
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
