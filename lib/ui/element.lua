-- ui/element.lua
local UIElement = {}
UIElement.__index = UIElement

function UIElement:new(x, y, width, height)
  local obj = setmetatable({}, self)
  obj.x = x
  obj.y = y
  obj.width = width
  obj.height = height
  obj.visible = true

  obj.fg = nil
  obj.bg = nilf

  obj.parent = nil
  obj.term = nil
  obj.dirty = true
  return obj
end

function UIElement:getBG()
  if self.bg ~= nil then
    return self.bg
  elseif self.parent then
    return self.parent:getBG()
  else
    return colors.black
  end
end

function UIElement:getFG()
  if self.fg ~= nil then
    return self.fg
  elseif self.parent then
    return self.parent:getFG()
  else
    return colors.white
  end
end

function UIElement:setColors(fg, bg)
  self.fg = fg or self.fg
  self.bg = bg or self.bg
  self:markDirty()
  return self
end

function UIElement:setBackgroundColor(bg)
  self.bg = bg
  self:markDirty()
  return self
end

function UIElement:setTextColor(fg)
  self.fg = fg
  self:markDirty()
  return self
end


function UIElement:setVisible(visible)
  self.visible = visible
  self:markDirty()
  return self
end

function UIElement:getAbsolutePosition()
  if self.parent then
    local px, py = self.parent:getAbsolutePosition()
    return px + self.x - 1, py + self.y - 1
  end
  return self.x, self.y
end

function UIElement:markDirty()
  self.dirty = true
  if self.parent then
    self.parent:markDirty()
  end
  return self
end

-- fallback term: own term or parent's, or global term
function UIElement:getTerm()
  if self.term then return self.term end
  if self.parent then return self.parent:getTerm() end
  return term
end

function UIElement:contains(px, py)
  local ax, ay = self:getAbsolutePosition()
  return px >= ax
     and px < ax + self.width
     and py >= ay
     and py < ay + self.height
end

function UIElement:draw()
end

function UIElement:handleEvent(event, ...)
end

return UIElement
