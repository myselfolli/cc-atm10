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
  if event == "mouse_click" then
    print("Button received mouse_click event at (" .. x .. ", " .. y .. "), button is at " .. self.x .. ", " .. self.y)
    if self:containsPoint(x, y) then
      print("Button '" .. self.text .. "' was clicked")
      if self.callback then
        self.callback()
      end
    end
  end
end

return Button
