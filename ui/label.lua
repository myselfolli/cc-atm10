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
  if not self.visible or not self.dirty then return end
  local t = self:getTerm()
  local ax, ay = self:getAbsolutePosition()

  t.setCursorPos(ax, ay)
  t.setTextColor(self.fg)
  t.setBackgroundColor(self.bg)
  t.write(self.text)

  self.dirty = false
end

return Label
