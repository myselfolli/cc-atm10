-- ui/container.lua
local UIElement = require("ui.element")

Container = setmetatable({}, {__index = UIElement})
Container.__index = Container

function Container:new(x, y, width, height)
  local obj = setmetatable(UIElement:new(), self)
  obj.x = x or 1
  obj.y = y or 1
  obj.width = width or 10
  obj.height = height or 5
  obj.children = {}
  return obj
end

function Container:add(child)
  child.parent = self
  table.insert(self.children, child)
  return self
end

function Container:draw()
  if not self.visible or not self.dirty then return end

  local t = self:getTerm()

  -- draw background
  local x, y = self:getAbsolutePosition()
  t.setBackgroundColor(self:getBG())
  t.setTextColor(self:getFG())

  for dy = 0, self.height - 1 do
    t.setCursorPos(x, y + dy)
    t.write(string.rep(" ", self.width))
  end

  for _, child in ipairs(self.children) do
    child:markDirty()
    child:draw()
  end

  self.dirty = false
end

function Container:handleEvent(event, ...)
  for _, child in ipairs(self.children) do
    child:handleEvent(event, ...)
  end
end

return Container
