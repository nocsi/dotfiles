-- ┌──────────────────────────────┐
-- │******************************│██
-- │******************************│██     _  _  ____  ____  ____  ____  ____  _  _
-- │*******██████*███████████*****│██    / )( \(  __)(__  )(_  _)(  __)(  _ \( \/ )
-- │*****███*****██******██*******│██    \ /\ / ) _)  / _/   )(   ) _)  )   // \/ \
-- │****██********██*█***██*******│██    (_/\_)(____)(____) (__) (____)(__\_)\_)(_/
-- │****██***********██████*******│██      ___  __   __ _  ____  __  ___
-- │****██***********█***██*******│██     / __)/  \ (  ( \(  __)(  )/ __)
-- │****██********██*█***██*******│██    ( (__(  O )/    / ) _)  )(( (_ \
-- │*****███*****██******██*******│██     \___)\__/ \_)__)(__)  (__)\___/
-- │*******███████****███████*****│██
-- │******************************│██     Official docs:
-- │******************************│██     https://wezfurlong.org/wezterm/config/lua/general.html
-- └──────────────────────────────┘██
--   ████████████████████████████████
--
--
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local mappings = require("modules.mappings")
-- local ui = require("ui")
-- integration with neovim
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local constants = require("constants")
local utils = require("utils")
--
-- fonts
local desired_font = constants.fonts[1]
local font_metrics = utils.get_font_config(desired_font.family)

local act = wezterm.action
local mux = wezterm.mux

local launch_menu = {}

local on_unix = true
local on_macos = false

config = {
	automatically_reload_config = true,
	-- appearance

	font = wezterm.font_with_fallback(constants.fonts[1]),
	font_size = 12.0,
	-- font_size = font_metrics.font_size,
	line_height = font_metrics.line_height,
	freetype_load_target = "Light",
	freetype_render_target = "HorizontalLcd",
	hide_mouse_cursor_when_typing = false,

	color_scheme = utils.scheme_for_appearance(constants.color_schemes[1], constants.color_schemes[2]),

	unix_domains = {
		{
			name = "mux",
			connect_automatically = true,
		},
	},

	default_gui_startup_args = { "connect", "mux" },

	default_workspace = "default",
	native_macos_fullscreen_mode = true,

	initial_cols = 120,
	initial_rows = 50,
	inactive_pane_hsb = {
		hue = 1.0,
		saturation = 0.7,
		brightness = 0.3,
	},

	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	window_frame = {
		-- font = wezterm.font({ family = "Roboto", weight = "Bold" }),
		-- font = config.font,
		font_size = 12,
		active_titlebar_bg = "#333333",
		inactive_titlebar_bg = "#333333",
		border_bottom_height = "0px",
	},

	window_padding = {
		left = 0,
		right = 0,
		-- left = "1cell",
		-- right = "1cell",
		top = "0.5cell",
		bottom = "0px",
	},

	-- ssh_domains = {
	-- 	{
	-- 		multiplexing = "WezTerm",
	-- 		name = "studio",
	-- 		remote_address = "studio",
	-- 		username = "locnguyen",
	-- 	},
	-- },
	--
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",
	default_cursor_style = "BlinkingUnderline",
	max_fps = 120,
	animation_fps = 120,
	cursor_blink_rate = 1500,
	cursor_blink_ease_in = "Linear",
	cursor_blink_ease_out = "EaseOut",

	window_background_opacity = 0.80,
	macos_window_background_blur = 30,
	audible_bell = "Disabled",
	check_for_updates = false,

	pane_focus_follows_mouse = true,

	launch_menu = launch_menu,
	leader = mappings.leader,
	disable_default_key_bindings = true,
	keys = mappings.keys,
	key_tables = mappings.key_tables,
	bypass_mouse_reporting_modifiers = "SHIFT",
	mouse_bindings = mappings.mouse_bindings,

	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,

	use_fancy_tab_bar = true,
}

-- See https://wezfurlong.org/wezterm/config/launch.html?h=launch_menu#the-launcher-menu
-- Note that we've disabled the right-click on the "new tab button"

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

if config.use_fancy_tab_bar then
	config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
else
	config.window_decorations = "RESIZE"
end
config.tab_max_width = 32
config.enable_tab_bar = true

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

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

-- https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

return config
