local constants = require("constants")
local icons = require("config.icons")
local colors = require("config.colors")
local settings = require("config.settings")

local docker = sbar.add("item", "widgets.docker", 42, {
    icon = {
        padding_right = 0,
        font = {
            style = "Black",
            size = 12.0,
        },
    },
    label = {
        width = 45,
        align = "right",
    },
    position = "right",
    update_freq = 15,
})

local composes = sbar.add("item", "docker.compose", {
    position = "right",
    background = {
        height = 22,
        color = { alpha = 0 },
        border_width = 0,
        drawing = true,
    },
    icon = {
        string = icons.brew,
        color = colors.green,
    },
    label = {
        string = "Docker Composes: ",
        color = colors.white,
    },
})

local spaces = {}

sbar.add("bracket", "widgets.docker.bracket", { composes.name }, {
    background = { color = colors.bg1 },
})

local function addWorkspaceItem(composeName)
    local spaceId = "workspace_" .. composeName

    if not spaces[spaceId] then
        local space_item = sbar.add("item", spaceId, {
            icon = {
                font = { family = settings.font.numbers },
                string = composeName,
                padding_left = 10,
                padding_right = 2,
                color = colors.grey,
                highlight_color = colors.yellow,
            },
            label = {
                padding_right = 12,
                color = colors.grey,
                highlight_color = colors.yellow,
                font = "sketchybar-app-font:Regular:12.0",
                y_offset = -1,
            },
            padding_left = 2,
            padding_right = 2,
            background = {
                color = colors.bg2,
                border_width = 1,
                height = 24,
                border_color = colors.bg1,
                corner_radius = 9,
            },
            click_script = "aerospace workspace " .. composeName,
        })

        -- Create bracket for double border effect
        local space_bracket = sbar.add("bracket", { spaceId }, {
            background = {
                color = colors.transparent,
                border_color = colors.transparent,
                height = 26,
                border_width = 1,
                corner_radius = 9,
            },
        })

        -- Subscribe to mouse events for changing workspace
        space_item:subscribe("mouse.clicked", function()
            sbar.exec("aerospace workspace " .. composeName)
        end)

        -- Store both the item and its bracket in the spaces table
        spaces[spaceId] = { item = space_item, bracket = space_bracket }
    end
end

local function update_docker_compose()
    local command = "~/.scripts/docker_composes.sh"
    sbar.exec(command, function(result)
        for composeName in result:gmatch("[^\r\n]+") do
            addWorkspaceItem(composeName)
        end
    end)
end

local function update()
    local date = os.date("%a. %d %b.")
    local time = os.date("%H:%M")
    docker:set({ icon = date, label = time })

    local command = "~/.scripts/docker_host.sh"
    sbar.exec(command, function(result)
        local docker_host = string.match(result, "Host:%s*(.-)\n")
        local docker_count = string.match(result, "Count:%s*(.-)\n")
        local docker_list = string.match(result, "List:%s*(.-)\n")
        update_docker_compose()
        if result then
            docker:set({
                label = {
                    string = docker_host .. "abc",
                    color = "0xFFFFFFFF",
                },
                icon = {
                    color = "0xFFFFFFFF",
                },
            })
            print(result)
        else
            print("Weather data extraction failed")
        end
    end)
end

docker:subscribe("routine", update)
docker:subscribe("forced", update)
