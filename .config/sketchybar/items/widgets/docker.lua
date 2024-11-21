local constants = require("constants")
local icons = require("config.icons")
local colors = require("config.colors")
local settings = require("config.settings")

local popup_width = 250
local docker_socket = ""
local count = 0

local compose_items = {}

local docker = sbar.add("item", "widgets.docker", 42, {
    socket = "",
    icon = {
        string = settings.icons.apps["Docker"],
        font = settings.fonts.icons(),
    },
    label = {
        align = "right",
    },
    position = "right",
    update_freq = 60,
})

local docker_bracket = sbar.add("bracket", "widgets.docker.bracket", { docker.name }, {
    background = { color = colors.bg1 },
    popup = { align = "center", height = 30 },
})

local hostname = sbar.add("item", {
    position = "popup." .. docker_bracket.name,
    icon = {
        align = "left",
        string = "Hostname:",
        width = popup_width / 2,
    },
    label = {
        max_chars = 20,
        string = "????????????",
        width = popup_width / 2,
        align = "right",
    },
})
local spaces = {}
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
    local should_draw = docker_bracket:query().popup.drawing == "off"

    local COUNTER = 0

    sbar.exec(command, function(result, exit_code)
        for composeName in result:gmatch("[^\r\n]+") do
            local color = colors.grey
            local compose = sbar.add("item", "docker.compose." .. composeName, {
                position = "popup." .. docker_bracket.name,
                width = popup_width,
                align = "center",
                icon = {
                    align = "left",
                    string = "Compose:",
                    width = popup_width / 2,
                },
                label = {
                    color = colors.blue,
                    max_chars = 20,
                    string = composeName,
                    width = popup_width / 2,
                    align = "right",
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
            })

            --addWorkspaceItem(composeName)
        end
    end)
end

local function hide_details()
    docker_bracket:set({ popup = { drawing = false } })
end

local function toggle_details()
    local should_draw = docker_bracket:query().popup.drawing == "off"
    if should_draw then
        docker_bracket:set({ popup = { drawing = true } })
    else
        hide_details()
    end
end

local function update(env)
    local command = "~/.scripts/docker_host.sh"
    sbar.exec(command, function(result, exit_code)
        local docker_host = string.match(result, "Host:%s*(.-)\n")
        local docker_socket = string.match(result, "Socket:%s*(.-)\n")
        local docker_count = string.match(result, "Count:%s*(.-)\n")
        local docker_list = string.match(result, "List:%s*(.-)\n")
        update_docker_compose()
        if result then
            docker:set({
                label = {
                    string = docker_count,
                    color = "0xFFFFFFFF",
                    drawing = true,
                },
                icon = {
                    string = settings.icons.apps["Docker"],
                    font = settings.fonts.icons(),
                    color = "0xff0db7ed",
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
docker:subscribe("mouse.entered", toggle_details)
docker:subscribe("mouse.clicked", toggle_details)
docker:subscribe("mouse.exited", "mouse.exited.global", hide_details)
