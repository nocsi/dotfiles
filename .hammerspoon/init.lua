-- seed the RNG
math.randomseed(os.time())

-- default log level
hs.logger.defaultLogLevel = "info"

-- disable icons
hs.dockIcon(false)
hs.menuIcon(false)

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, "F17")
-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    hs.eventtap.keyStroke({}, "ESCAPE")
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, "F18", enterHyperMode, exitHyperMode)

hyper:bind({}, "u", function()
  hs.eventtap.keyStroke({ "cmd", "alt", "shift", "ctrl" }, "u")
  hyper.triggered = true
end)

hyper:bind({}, "l", function()
  hs.caffeinate.lockScreen()
  hyper.triggered = true
end)

hyper:bind({}, "t", function()
  local app = hs.application.open("alacritty")
  --local win = app:getWindow()
  --win:moveToUnit(hs.layout.right50)
  hyper.triggered = true
end)

-- local hyper = { "ctrl", "alt", "cmd" }
require("smartLaunch")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3

require("slowq") -- Avoid accidental Cmd-Q

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()
