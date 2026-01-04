-- ui/label.lua
local UIElement = require("ui.element")

local Label = setmetatable({}, UIElement)
Label.__index = Label

function Label:new(x, y, text)
  local obj = UIElement.new(self, x, y, #text, 1)
  obj.text = text
  return obj
end

function Label:draw()
  if not self.visible then return end
  term.setCursorPos(self.x, self.y)
  term.write(self.text)
end

return Label
