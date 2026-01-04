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
  if not self.visible then return end

  local t = self:getTerm()

  t.setCursorPos(self.x, self.y)
  t.setTextColor(self:getFG())
  t.setBackgroundColor(self:getBG())

  t.write("[" .. self.text .. "]")
end


function Button:handleEvent(event, button, x, y)
  if event == "mouse_click" and self:containsPoint(x, y) then
    if self.callback then
      self.callback()
    else
      print("Button '" .. self.text .. "' clicked, but no callback defined.")
    end
  end
end

return Button
