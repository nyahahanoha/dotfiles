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

hs.hotkey.bind({"ctrl"}, "space", function()
  LaunchOrFocus("Alacritty")
end)

hs.hotkey.bind({"ctrl", "cmd"}, "o", function()
  LaunchOrFocus("Google Chrome")
end)

hs.hotkey.bind({"ctrl", "cmd"}, "a", function()
  local app = hs.application.frontmostApplication()
  hs.alert.show("Active App: " .. app:name())
end)

hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
