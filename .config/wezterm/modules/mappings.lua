local vars = require("../vars")

local wezterm = require("wezterm")
local act = wezterm.action

local function activate_pane(window, pane, pane_direction, vim_direction)
	local isViProcess = pane:get_foreground_process_name():find("n?vim") ~= nil
	if isViProcess then
		window:perform_action(act.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
	else
		window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
	end
end

function make_mouse_binding(dir, streak, button, mods, action)
	return {
		event = { [dir] = { streak = streak, button = button } },
		mods = mods,
		action = action,
	}
end

wezterm.on("activate_pane_r", function(window, pane)
	activate_pane(window, pane, "Right", "l")
end)
wezterm.on("activate_pane_l", function(window, pane)
	activate_pane(window, pane, "Left", "h")
end)
wezterm.on("activate_pane_u", function(window, pane)
	activate_pane(window, pane, "Up", "k")
end)
wezterm.on("activate_pane_d", function(window, pane)
	activate_pane(window, pane, "Down", "j")
end)

return {
	disable_default_key_bindings = true,
	leader = {
		key = "a",
		mods = "CMD",
		timeout_milliseconds = 5000,
	},

	keys = {
		{
			key = "\u{f746}", -- Match the logged value
			mods = "NONE",
			action = act.SendKey({ key = "Insert" }),
		},
		-- { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
		{ key = "q", mods = "SUPER", action = act.QuitApplication },
		{ key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
		{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
		{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
		{ key = "z", mods = "CMD", action = act.TogglePaneZoomState },
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "c",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter new tab name:",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						local tab = window:mux_window():spawn_tab({
							cwd = wezterm.home_dir .. "/me",
						})
						tab:set_title(line)
						tab:activate()
					end
				end),
			}),
		},
		{
			key = "r",
			mods = "LEADER",
			action = act.PromptInputLine({
				description = "Enter tab name:",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
		{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
		{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
		{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
		{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
		{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
		{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
		{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
		{ key = "9", mods = "LEADER", action = act.ActivateCommandPalette },

		-- its like '+' but to avoid pressing shift
		{ key = "=", mods = "LEADER", action = act.IncreaseFontSize },
		{ key = "-", mods = "LEADER", action = act.DecreaseFontSize },

		{ -- add new panes
			key = "\\",
			mods = "LEADER",
			action = act.SplitHorizontal({
				domain = "CurrentPaneDomain",
			}),
		},
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({
				domain = "CurrentPaneDomain",
			}),
		},

		-- Launch commands in a new pane
		{
			key = "g",
			mods = "CMD",
			action = act.SplitHorizontal({
				args = { os.getenv("SHELL"), "-c", "lg" },
			}),
		},
		{
			key = "w",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				local isViProcess = pane:get_foreground_process_name():find("n?vim") ~= nil
				wezterm.log_info("leader+w pressed, isViProcess=[" .. tostring(isViProcess) .. "]")
				if not isViProcess then
					vars.is_resize_mode = true
				end
			end),
		},

		{
			key = "Escape",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("Escape pressed, is_resize_mode=[" .. tostring(vars.is_resize_mode) .. "]")
				if vars.is_resize_mode then
					vars.is_resize_mode = false
				else
					return window:perform_action(act.SendKey({ key = "Escape" }), pane)
				end
			end),
		},
		{
			key = "l",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("l pressed, is_resize_mode=[" .. tostring(vars.is_resize_mode) .. "]")
				return window:perform_action(
					vars.is_resize_mode and act.AdjustPaneSize({ "Left", 5 }) or act.SendKey({ key = "l" }),
					pane
				)
			end),
		},
		{
			key = "r",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("r pressed, is_resize_mode=[" .. tostring(vars.is_resize_mode) .. "]")
				return window:perform_action(
					vars.is_resize_mode and act.AdjustPaneSize({ "Right", 5 }) or act.SendKey({ key = "r" }),
					pane
				)
			end),
		},
		{
			key = "u",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("u pressed, is_resize_mode=[" .. tostring(vars.is_resize_mode) .. "]")
				return window:perform_action(
					vars.is_resize_mode and act.AdjustPaneSize({ "Up", 5 }) or act.SendKey({ key = "u" }),
					pane
				)
			end),
		},
		{
			key = "d",
			action = wezterm.action_callback(function(window, pane)
				wezterm.log_info("d pressed, is_resize_mode=[" .. tostring(vars.is_resize_mode) .. "]")
				return window:perform_action(
					vars.is_resize_mode and act.AdjustPaneSize({ "Down", 5 }) or act.SendKey({ key = "d" }),
					pane
				)
			end),
		},

		{ key = "h", mods = "CTRL", action = act.EmitEvent("activate_pane_l") },
		{ key = "j", mods = "CTRL", action = act.EmitEvent("activate_pane_d") },
		{ key = "k", mods = "CTRL", action = act.EmitEvent("activate_pane_u") },
		{ key = "l", mods = "CTRL", action = act.EmitEvent("activate_pane_r") },

		-- { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
		{
			key = "H",
			mods = "LEADER",
			action = act.Search({ Regex = "[a-f0-9]{6,}" }),
		},

		{
			key = "r",
			mods = "LEADER",
			action = act.ActivateKeyTable({
				name = "resize_pane",
				one_shot = false,
			}),
		}, -- focus panes
		{
			key = "h",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = act.ActivatePaneDirection("Down"),
		},
		{
			key = "[",
			mods = "CMD",
			action = act.ActivatePaneDirection("Prev"),
		},

		{
			key = "]",
			mods = "CMD",
			action = act.ActivatePaneDirection("Next"),
		},
		{
			key = "{",
			mods = "CMD|SHIFT",
			action = wezterm.action.ActivateTabRelative(-1),
		},

		{
			key = "}",
			mods = "CMD|SHIFT",
			action = wezterm.action.ActivateTabRelative(1),
		},
		{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
		{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
		{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
		{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
		{
			key = "s",
			mods = "CMD|SHIFT",
			action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
		},
		{
			mods = "LEADER",
			key = "c",
			action = wezterm.action.SpawnTab("CurrentPaneDomain"),
		},

		{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "w", mods = "CMD|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
		{ -- open launcher
			key = "o",
			mods = "CMD",
			action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS|DOMAINS" }),
		},
		{ -- attach to domain
			key = "a",
			mods = "LEADER",
			action = act.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
		},
		{ -- detach from current domain
			key = "d",
			mods = "LEADER",
			action = act.DetachDomain("CurrentPaneDomain"),
		},
		{ -- toggle tab bar
			key = "t",
			mods = "LEADER",
			action = act.EmitEvent("toggle-tabbar"),
		},
		{ -- Activate copy mode (cf. `tmux`, in addition to the default ctr-shift-x)
			key = "Enter",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		{ -- Paste (like in tmux)
			key = "]",
			mods = "LEADER",
			action = act.PasteFrom("Clipboard"),
		},
		{
			key = "E",
			mods = "CMD|SHIFT",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
						-- mux.rename_workspace(
						-- 	window:mux_window():get_workspace(), -- rename workspace
						-- 	line
						-- )
					end
				end),
			}),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.ShowLauncherArgs({ flags = "WORKSPACES" }), -- show workspaces
		},
		{
			key = "r",
			mods = "CMD",
			action = act.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},

		{
			key = "t",
			mods = "SHIFT|CTRL",
			action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		},
		{
			key = "t",
			mods = "SUPER",
			action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir }),
		},
		{ -- Move tab (pane) interactively
			key = "t",
			mods = "CMD|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				local function get_tab_title(t)
					if t:get_title() == "" then
						local p = t:active_pane()
						return p:get_title()
					else
						return t:get_title()
					end
				end

				local choices = {}
				for _, w in ipairs(wezterm.mux.all_windows()) do
					local window_width = 0
					local window_height = 0
					local tabs = {}
					for _, t in ipairs(w:tabs()) do
						table.insert(tabs, get_tab_title(t))
						if t:get_size().rows > window_height then
							window_height = t:get_size().rows
						end
						if t:get_size().cols > window_width then
							window_width = t:get_size().cols
						end
					end
					local tab_titles = table.concat(tabs, ", ")
					table.insert(choices, {
						id = tostring(w:window_id()),
						label = "window "
							.. tostring(w:window_id())
							.. " ("
							.. window_width
							.. "x"
							.. window_height
							.. ") with "
							.. tostring(#w:tabs())
							.. " tabs: "
							.. tab_titles,
					})
				end
				table.insert(choices, { id = "new", label = "new window" })

				window:perform_action(
					act.InputSelector({
						action = wezterm.action_callback(function(window, pane, id, label)
							if id then
								local orig_tab = pane:tab()
								local tab_title = nil
								if orig_tab then
									tab_title = orig_tab:get_title()
								end
								local wezterm_bin = wezterm.executable_dir .. "/wezterm"
								if id == "new" then
									wezterm.log_info("CMD-SHIFT-T: you selected ", label)
									local tab, _ = pane:move_to_new_window()
									if tab_title then
										tab.set_title(tab_title)
									end
								else
									local cmd = {
										wezterm_bin,
										"cli",
										"move-pane-to-new-tab",
										"--pane-id",
										pane:pane_id(),
										"--window-id",
										id,
									}
									wezterm.log_info(
										"CMD-SHIFT-T: you selected ",
										label,
										"->",
										wezterm.shell_join_args(cmd)
									)
									local success, stdout, stderr = wezterm.run_child_process(cmd)
									wezterm.log_info(success, stdout, stderr)
									if tab_title then
										pane:tab():set_title(tab_title)
									end
								end
							end
						end),
						title = "Choose target window",
						choices = choices,
						description = "Move pane "
							.. pane:pane_id()
							.. " (tab title '"
							.. get_tab_title(pane:tab())
							.. "') from window "
							.. pane:window():window_id()
							.. " to…",
					}),
					pane
				)
			end),
		},
		{
			key = "m",
			mods = "CMD",
			action = act.PaneSelect({
				show_pane_ids = true,
			}),
		},
		{
			key = "p",
			mods = "CMD|SHIFT",
			action = act.ActivateCommandPalette,
		},
		{
			key = "LeftArrow",
			mods = "CMD",
			action = act.ActivateTabRelative(-1),
		},
		{
			key = "RightArrow",
			mods = "CMD",
			action = act.ActivateTabRelative(1),
		},
		{
			key = "LeftArrow",
			mods = "CMD|SHIFT",
			action = act.MoveTabRelative(-1),
		},
		{
			key = "RightArrow",
			mods = "CMD|SHIFT",
			action = act.MoveTabRelative(1),
		},
	},

	key_tables = {
		resize_pane = {
			{
				key = "LeftArrow",
				action = act.AdjustPaneSize({ "Left", 5 }),
			},
			{
				key = "k",
				action = act.AdjustPaneSize({ "Left", 5 }),
			},
			{
				key = "RightArrow",
				action = act.AdjustPaneSize({ "Right", 5 }),
			},
			{
				key = "i",
				action = act.AdjustPaneSize({ "Right", 5 }),
			},
			{
				key = "UpArrow",
				action = act.AdjustPaneSize({ "Up", 2 }),
			},
			{
				key = "e",
				action = act.AdjustPaneSize({ "Up", 2 }),
			},
			{
				key = "DownArrow",
				action = act.AdjustPaneSize({ "Down", 2 }),
			},
			{
				key = "n",
				action = act.AdjustPaneSize({ "Down", 2 }),
			},
			{
				key = "Escape",
				action = "PopKeyTable",
			},
		},
	},
	search_mode = {
		{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
	},

	copy_mode = {
		{ key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
		{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
		{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
		{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
		{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
		{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
		{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
		{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
		{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "c", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
		{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "g", mods = "CTRL", action = act.CopyMode("Close") },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
		{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
		{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
		{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
		{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
		{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
	},

	mouse_bindings = {
		make_mouse_binding(
			"Up",
			1,
			"Left",
			"NONE",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),

		make_mouse_binding(
			"Up",
			1,
			"Left",
			"SHIFT",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),
		make_mouse_binding("Up", 1, "Left", "ALT", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
		make_mouse_binding(
			"Up",
			1,
			"Left",
			"SHIFT|ALT",
			wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor("ClipboardAndPrimarySelection")
		),
		make_mouse_binding("Up", 2, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),
		make_mouse_binding("Up", 3, "Left", "NONE", wezterm.action.CompleteSelection("ClipboardAndPrimarySelection")),

		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
				end
			end),
		},
		-- -- Change the default click behavior so that it only selects
		-- -- text and doesn't open hyperlinks
		-- {
		-- 	event = { Up = { streak = 1, button = "Left" } },
		-- 	mods = "NONE",
		-- 	action = act.CompleteSelection("PrimarySelection"),
		-- },
		--
		-- -- and make CMD-Click open hyperlinks
		-- {
		-- 	event = { Up = { streak = 1, button = "Left" } },
		-- 	mods = "CMD",
		-- 	action = act.OpenLinkAtMouseCursor,
		-- },
		-- { -- also with SHIFT, so that SHIFT-CMD-click works with and without bypass
		-- 	event = { Up = { streak = 1, button = "Left" } },
		-- 	mods = "CMD|SHIFT",
		-- 	action = act.OpenLinkAtMouseCursor,
		-- },
		--
		-- -- Disable the 'Down' event of CMD-Click to avoid weird program behaviors
		{
			event = { Down = { streak = 1, button = "Left" } },
			mods = "CMD",
			action = act.Nop,
		},
		{
			event = { Down = { streak = 2, button = "Left" } },
			mods = "CMD|SHIFT",
			action = act.Nop,
		},
	},
}
