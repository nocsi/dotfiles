local constants = require("constants")
local settings = require("config.settings")
local icons = require("config.icons")
local colors = require("config.colors")

local currentAudioDevice = "None"
local compose_items = {}
local popup_width = 250

local docker = sbar.add("item", constants.items.DOCKER, 42, {
    socket = "",
    width = 0,
    position = "right",
    update_freq = 60,
    popup = {
        align = "center",
        height = 25,
        padding_right = 10,
    },
    label = {
        align = "right",
        padding_left = 0,
        padding_right = 0,
    },
    icon = {
        string = settings.icons.apps["Docker"],
        font = settings.fonts.icons(),
    },
    background = {
        padding_left = 0,
        padding_right = 0,
    },
})

local dockerBracket = sbar.add("bracket", constants.items.DOCKER .. ".bracket", { docker.name }, {
    popup = { align = "center", height = 30 },
    width = "dynamic",
    label = {
        padding_right = settings.dimens.padding.label,
        padding_left = settings.dimens.padding.label,
    },
    icon = {
        padding_left = 0,
        padding_right = 0,
    },
})

local function hideDocker()
    docker:set({ popup = { drawing = false } })
    dockerBracket:set({ popup = { drawing = false } })
end

local function showDocker(content, hold)
    hideDocker()

    docker:set({ popup = { drawing = true } })
    dockerBracket:set({ label = { string = content } })
    dockerBracket:set({ popup = { drawing = true } })

    if hold == false then
        sbar.delay(5, function()
            if hold then
                return
            end
            hideDocker()
        end)
    end
end

local function update_docker_compose()
    local command = "~/.scripts/docker_composes.sh"

    local COUNTER = 0

    sbar.exec(command, function(result, exit_code)
        local counter = 0
        for composeName in result:gmatch("[^\r\n]+") do
            local color = colors.blue
            sbar.add("item", constants.items.DOCKER .. ".compose." .. counter, {
                position = "popup." .. dockerBracket.name,
                width = popup_width,
                align = "center",
                icon = {
                    align = "left",
                    string = "Compose:",
                },
                label = {
                    color = color,
                    max_chars = 20,
                    string = composeName,
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
            counter = counter + 1
        end
    end)
end

local function hide_details()
    local drawing = dockerBracket:query().popup.drawing == "on"
    if not drawing then
        return
    end
    dockerBracket:set({ popup = { drawing = false } })
    sbar.remove("/" .. constants.items.Docker .. ".compose\\.*/")
end

local function toggle_details()
    local should_draw = dockerBracket:query().popup.drawing == "off"
    if should_draw then
        dockerBracket:set({ popup = { drawing = true } })

        local command = "~/.scripts/docker_host.sh"
        sbar.exec(command, function(result, exit_code)
            local docker_host = string.match(result, "Host:%s*(.-)\n")
            local docker_socket = string.match(result, "Socket:%s*(.-)\n")
            local docker_count = string.match(result, "Count:%s*(.-)\n")
            local docker_list = string.match(result, "List:%s*(.-)\n")
            update_docker_compose()
            if result then
                dockerBracket:set({
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
    else
        hide_details()
    end
end

local function update(env)
    local command = "~/.scripts/docker_host.sh"
    sbar.set(env.DOCKER, {
        label = {
            string = "abc",
            align = "center",
        },
    })
    sbar.exec(command, function(result, exit_code)
        local docker_host = string.match(result, "Host:%s*(.-)\n")
        local docker_socket = string.match(result, "Socket:%s*(.-)\n")
        local docker_count = string.match(result, "Count:%s*(.-)\n")
        local docker_list = string.match(result, "List:%s*(.-)\n")
        update_docker_compose()
        if result then
            dockerBracket:set({
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
docker:subscribe(constants.events.UPDATE_DOCKER, function(env)
    local content = env.DOCKER
    local hold = env.HOLD ~= nil and env.HOLD == "true" or false
    --showDocker(content, true)
end)
docker:subscribe("mouse.entered", toggle_details)
docker:subscribe("mouse.clicked", toggle_details)
docker:subscribe("mouse.exited", "mouse.exited.global", hide_details)
