local wezterm = require("wezterm")
local act = wezterm.action

return {
    leader = {
        key = "a",
        mods = "CMD",
        timeout_milliseconds = 5000,
    },

    keys = {
        -- { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
        {
            key = "w",
            mods = "CMD",
            action = act.CloseCurrentPane({
                confirm = true,
            }),
        }, -- activate resize mode
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
        { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
        { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
        { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
        { key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
        { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
        { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
        { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
        { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
        { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
        { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
        { key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
        { key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
        { key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
        {
            mods = "LEADER",
            key = "b",
            action = wezterm.action.ActivateTabRelative(-1),
        },
        {
            mods = "LEADER",
            key = "n",
            action = wezterm.action.ActivateTabRelative(1),
        },
        {
            mods = "LEADER",
            key = "c",
            action = wezterm.action.SpawnTab("CurrentPaneDomain"),
        },
        {
            mods = "LEADER",
            key = "x",
            action = wezterm.action.CloseCurrentPane({ confirm = true }),
        },
        { key = "X", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
        { key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
        { key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
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
            key = "[",
            mods = "LEADER",
            action = act.ActivateCopyMode,
        },
        { -- Paste (like in tmux)
            key = "]",
            mods = "LEADER",
            action = act.PasteFrom("Clipboard"),
        },
        {
            key = "r",
            mods = "LEADER",
            action = act.PromptInputLine({
                description = "Enter new name for workspace",
                action = wezterm.action_callback(function(window, pane, line)
                    if line then
                        mux.rename_workspace(
                            window:mux_window():get_workspace(), -- rename workspace
                            line
                        )
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
            key = "p",
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

    mouse_bindings = {
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
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "NONE",
            action = act.CompleteSelection("PrimarySelection"),
        },

        -- and make CMD-Click open hyperlinks
        {
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CMD",
            action = act.OpenLinkAtMouseCursor,
        },
        { -- also with SHIFT, so that SHIFT-CMD-click works with and without bypass
            event = { Up = { streak = 1, button = "Left" } },
            mods = "CMD|SHIFT",
            action = act.OpenLinkAtMouseCursor,
        },

        -- Disable the 'Down' event of CMD-Click to avoid weird program behaviors
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
