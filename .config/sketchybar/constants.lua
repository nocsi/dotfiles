local events <const> = {
    AEROSPACE_WORKSPACE_CHANGED = "aerospace_workspace_changed",
    AEROSPACE_SWITCH = "aerospace_switch",
    SWAP_MENU_AND_SPACES = "swap_menu_and_spaces",
    FRONT_APP_SWITCHED = "front_app_switched",
    UPDATE_WINDOWS = "update_windows",
    UPDATE_DOCKER = "update_docker",
    SEND_MESSAGE = "send_message",
    HIDE_MESSAGE = "hide_message",
}

local items <const> = {
    SPACES = "workspaces",
    MENU = "menu",
    MENU_TOGGLE = "menu_toggle",
    FRONT_APPS = "front_apps",
    DOCKER = "docker",
    MESSAGE = "message",
    VOLUME = "widgets.volume",
    WIFI = "widgets.wifi",
    BATTERY = "widgets.battery",
    CALENDAR = "widgets.calendar",
    TIMEMACHINE = "widgets.timemachine",
}

local aerospace <const> = {
    LIST_ALL_WORKSPACES = "aerospace list-workspaces --all",
    GET_CURRENT_WORKSPACE = "aerospace list-workspaces --focused",
    LIST_WINDOWS = 'aerospace list-windows --workspace focused --format "id=%{window-id}, name=%{app-name}"',
    GET_CURRENT_WINDOW = "aerospace list-windows --focused --format %{app-name}",
}

return {
    items = items,
    events = events,
    aerospace = aerospace,
}
