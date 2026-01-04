-- ui/button.lua
local UIElement = require("ui.element")

Button = setmetatable({}, {__index = UIElement})
Button.__index = Button

function Button:new(text, callback)
  local obj = setmetatable(UIElement:new(), self)
  obj.text = text or ""
  obj.callback = callback
  return obj
end

function Button:draw()
  if not self.visible or not self.dirty then return end

  local t = self:getTerm()

  t.setCursorPos(self.x, self.y)
  t.setTextColor(self:getFG())
  t.setBackgroundColor(self:getBG())

  t.write("[" .. self.text .. "]")

  self.dirty = false
end


function Button:handleEvent(event, button, x, y)
  print("Button handling event: " .. event)
  local iwasClicked = self:containsPoint(x, y)
  print("Button was clicked: " .. tostring(iwasClicked))
  if event == "mouse_click" and self:containsPoint(x, y) then
    if self.onClick then
      self.onClick()
    end
  end
end

return Button
