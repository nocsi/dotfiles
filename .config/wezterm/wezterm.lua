local wezterm = require("wezterm")
local mappings = require("modules.mappings")

local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

config.unix_domains = {
    {
        name = "mux",
    },
}

config.default_workspace = "default"

local launch_menu = {}

local on_unix = true
local on_macos = false

if wezterm.target_triple == "aarch64-apple-darwin" then
    -- Apple Silicon
    config.set_environment_variables = {
        PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
    }
    table.insert(launch_menu, {
        label = "ZSH",
        args = { "zsh", "--login" },
    })
    on_macos = true
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- Windows
    table.insert(launch_menu, {
        label = "PowerShell",
        args = { "powershell.exe", "-NoLogo" },
    })
    on_unix = false
end
config = {
    front_end = "WebGpu",
    max_fps = 240,
    animation_fps = 240,
    window_background_opacity = 0.85,
    audible_bell = "Disabled",
    check_for_updates = false,
    color_scheme = "Builtin Solarized Dark",
    inactive_pane_hsb = {
        hue = 1.0,
        saturation = 1.0,
        brightness = 1.0,
    },
    font_size = 16.0,
    launch_menu = {},
    leader = mappings.leader,
    disable_default_key_bindings = true,
    keys = mappings.keys,
    key_tables = mappings.key_tables,
    bypass_mouse_reporting_modifiers = "SHIFT",
    mouse_bindings = mappings.mouse_bindings,
    set_environment_variables = {},
}

-- See https://wezfurlong.org/wezterm/config/launch.html?h=launch_menu#the-launcher-menu
-- Note that we've disabled the right-click on the "new tab button"
config.launch_menu = launch_menu

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
if on_unix then
    table.insert(config.keys, { -- quick edit
        key = "e",
        mods = "CMD",
        action = act.SpawnCommandInNewTab({
            args = { os.getenv("SHELL"), "--login", "-c", '"$EDITOR"' },
        }),
    })

    table.insert(config.keys, { -- ChatGPT
        key = "g",
        mods = "CMD",
        action = wezterm.action_callback(function(win, pane)
            local _, new_pane, _ = win:mux_window():spawn_tab({
                args = { os.getenv("SHELL"), "--login", "-c", "nvim" },
            })
            local endTime = os.time() + 1.0
            while os.time() < endTime do
                -- sleep for 1 sec (nvim needs time to initialize)
            end
            new_pane:send_text(":GpChatNew\n")
            -- This very much depends on my configuration using https://github.com/Robitx/gp.nvim
        end),
    })
end

if on_macos then
    table.insert(config.keys, { -- settings
        key = ",",
        mods = "CMD",
        action = act.SpawnCommandInNewWindow({
            cwd = os.getenv("WEZTERM_CONFIG_DIR"),
            args = { os.getenv("SHELL"), "--login", "-c", '"$EDITOR" "$WEZTERM_CONFIG_FILE"' },
        }),
    })
end

config.use_fancy_tab_bar = true
-- config.use_fancy_tab_bar = false
if config.use_fancy_tab_bar then
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_DISABLE_SHADOW"
    --config.window_decorations = "TITLE|RESIZE|MACOS_FORCE_DISABLE_SHADOW"
else
    config.window_decorations = "RESIZE"
end
config.tab_max_width = 20
config.enable_tab_bar = true

wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
    wezterm.log_info("new-tab", window, pane, button, default_action)
    if (button == "Left") and default_action then
        window:perform_action(default_action, pane)
    end
    -- Do not handle right-click. Instead, use CMD-O for a customized launcher
    return false -- Tell WezTerm that we handled the event
end)

config.adjust_window_size_when_changing_font_size = false
config.quit_when_all_windows_are_closed = false
config.window_close_confirmation = "NeverPrompt"

config.audible_bell = "Disabled"

config.window_padding = {
    left = 5,
    right = 5,
    top = 1,
    bottom = 1,
}

wezterm.on("toggle-tabbar", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if overrides.enable_tab_bar then
        overrides.enable_tab_bar = false
        overrides.window_decorations = "RESIZE"
    else
        overrides.enable_tab_bar = true
        overrides.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
    end
    window:set_config_overrides(overrides)
end)

wezterm.on("update-status", function(window, pane)
    if config.enable_tab_bar then
        local right_status = ""
        local domain = pane:get_domain_name()
        if domain then
            if domain ~= "local" then
                right_status = domain .. " "
            end
        end
        local workspace = window:active_workspace()
        if workspace ~= config.default_workspace then
            right_status = right_status .. "(" .. workspace .. ")" .. " "
        end
        local window_id = window:window_id()
        local pane_id_str = "." .. pane:pane_id()
        local dims = pane:get_dimensions()
        local pane_size_str = ": " .. dims.cols .. "x" .. dims.viewport_rows
        if pane:tab() then
            -- only show IDs if pane is associated with a tab. Not for, e.g., the debug pane
            right_status = right_status .. "[" .. window_id .. pane_id_str .. pane_size_str .. "]  "
        end
        if window:leader_is_active() then
            right_status = right_status .. utf8.char(0x1f388) -- balloon
        end
        window:set_right_status(wezterm.format({
            { Foreground = { Color = "#999999" } },
            { Background = { Color = "#333333" } },
            { Text = right_status },
        }))
    end
end)

-- local colors = wezterm.color.load_scheme(wezterm.home_dir .. "/.config/wezterm/colors/light.toml")
local colors = require("colors/cyberdream")
colors.tab_bar = {
    background = "#000000",
    -- The active tab is the one that has focus in the window
    active_tab = {
        bg_color = "#0061df",
        fg_color = "#FFFFFF",
        intensity = "Bold", -- "Half", "Normal" or "Bold" intensity for the
        italic = false,
    },
    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
        bg_color = "#1b1032",
        fg_color = "#FFFFFF",
        intensity = "Half", -- "Half", "Normal" or "Bold" intensity for the
    },
    inactive_tab_hover = {
        bg_color = "#1b1032",
        fg_color = "#FFFFFF",
        italic = false,
        intensity = "Bold",
    },
    -- The new tab button that let you create new tabs
    new_tab = {
        bg_color = "#1b1032",
        fg_color = "#AAAAAA",
        intensity = "Bold", -- "Half", "Normal" or "Bold" intensity for the
    },
}
config.colors = colors

config.inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.7,
}

config.font_dirs = { "fonts" }
config.font = wezterm.font("JuliaMono")
config.font_size = 12
-- no ligatures
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.window_frame = { -- tab bar font
    font = wezterm.font({ family = "Roboto", weight = "Bold" }),
    font_size = 12,
}

config.hyperlink_rules = {
    -- Matches: a URL in parens: (URL)
    -- Markdown: [text](URL title)
    {
        regex = "\\((\\w+://\\S+?)(?:\\s+.+)?\\)",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
        regex = "\\[(\\w+://\\S+?)\\]",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
        regex = "\\{(\\w+://\\S+?)\\}",
        format = "$1",
        highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
        regex = "<(\\w+://\\S+?)>",
        format = "$1",
        highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    -- regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
    {
        regex = "(?<![\\(\\{\\[<])\\b\\w+://\\S+",
        format = "$0",
    },
    -- implicit mailto link
    {
        regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
        format = "mailto:$0",
    },
}

return config
