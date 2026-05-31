local spaces = require("hs.spaces")

local function LaunchOrFocus(name)
  local app = hs.application.find(name)

  if app == nil then
    hs.application.launchOrFocus(name)
  elseif app:isFrontmost() then
    app:hide()
  else
    local window = app:focusedWindow()
    local focused = spaces.focusedSpace()
    spaces.moveWindowToSpace(window:id(), focused)
    window:focus()
  end

end

local function LaunchOrForcusAndHide(appName, otherAppName)
  LaunchOrFocus(appName)
  if otherAppName ~= "" then
    local otherApp = hs.application.find(otherAppName)
    if otherApp then
      otherApp:hide()
    end
  end

end

hs.hotkey.bind({"ctrl"}, "space", function()
  LaunchOrFocus("Alacritty")
end)

hs.hotkey.bind({"ctrl"}, "\\", function()
  LaunchOrForcusAndHide("Google Chrome", "Alacritty")
end)

local function focusNextChromeWindow()
  local frontmostApp = hs.application.frontmostApplication()
  if not frontmostApp or frontmostApp:name() ~= "Google Chrome" then
    return
  end

  local currentWindow = hs.window.frontmostWindow()
  local chromeWindows = hs.fnutils.filter(hs.window.orderedWindows(), function(window)
    local app = window:application()
    return app
      and app:name() == "Google Chrome"
      and window:isStandard()
      and window:isVisible()
  end)

  if #chromeWindows <= 1 then
    return
  end

  for index, window in ipairs(chromeWindows) do
    if currentWindow and window:id() == currentWindow:id() then
      chromeWindows[(index % #chromeWindows) + 1]:focus()
      return
    end
  end

  chromeWindows[1]:focus()
end

local chromeCtrlO = hs.hotkey.new({"ctrl"}, "o", focusNextChromeWindow)

local chromeWatcher = hs.application.watcher.new(function(appName, eventType)
  if eventType == hs.application.watcher.activated then
    if appName == "Google Chrome" then
      chromeCtrlO:enable()
    else
      chromeCtrlO:disable()
    end
  end
end)

chromeWatcher:start()

hs.hotkey.bind({"ctrl", "cmd"}, "a", function()
  local app = hs.application.frontmostApplication()
  hs.alert.show("Active App: " .. app:name())
end)

hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
