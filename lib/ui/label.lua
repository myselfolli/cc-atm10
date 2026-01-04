-- ui/label.lua
local UIElement = require("ui.element")

Label = setmetatable({}, {__index = UIElement})
Label.__index = Label

function Label:new(text)
  local obj = setmetatable(UIElement:new(), self)
  obj.text = text or ""
  return obj
end

function Label:draw()
  if not self.visible or not self.dirty then return end
  local t = self:getTerm()

  t.setCursorPos(self.x, self.y)
  t.setTextColor(self:getFG())
  t.setBackgroundColor(self:getBG())
  t.write(self.text)

  self.dirty = false
end

return Label
