-- ui/button.lua
local UIElement = require("ui.element")

local Button = setmetatable({}, UIElement)
Button.__index = Button

function Button:new(x, y, width, text, onClick)
  local obj = UIElement.new(self, x, y, width, 1)
  obj.text = text
  obj.onClick = onClick
  return obj
end

function Button:draw()
  if not self.visible or not self.dirty then return end

  local t = self:getTerm()
  local ax, ay = self:getAbsolutePosition()

  t.setCursorPos(ax, ay)
  t.setTextColor(self:getFG())
  t.setBackgroundColor(self:getBG())

  t.write("[" .. self.text .. "]")

  self.dirty = false
end


function Button:handleEvent(event, button, x, y)
  if event == "mouse_click" and self:contains(x, y) then
    if self.onClick then
      self.onClick()
    end
  end
end

return Button
