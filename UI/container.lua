-- ui/container.lua
local UIElement = require("ui.element")

local Container = setmetatable({}, UIElement)
Container.__index = Container

function Container:new(x, y, width, height)
  local obj = UIElement.new(self, x, y, width, height)
  obj.children = {}
  return obj
end

function Container:add(child)
  child.parent = self
  table.insert(self.children, child)
end

function Container:draw()
  if not self.visible then return end

  -- draw background
  local x, y = self:getAbsolutePosition()
  term.setBackgroundColor(self.bg)
  term.setTextColor(self.fg)

  for dy = 0, self.height - 1 do
    term.setCursorPos(x, y + dy)
    term.write(string.rep(" ", self.width))
  end

  for _, child in ipairs(self.children) do
    child:draw()
  end
end

function Container:handleEvent(event, ...)
  for _, child in ipairs(self.children) do
    child:handleEvent(event, ...)
  end
end

return Container
