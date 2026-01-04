-- ui/element.lua
local UIElement = {}
UIElement.__index = UIElement

function UIElement:new()
  local obj = setmetatable({}, self)
  obj.x = 0
  obj.y = 0
  obj.width = 0
  obj.height = 0
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

function UIElement:markDirty()
  self.dirty = true
  if self.parent then
    self.parent:markDirty()
  end
  return self
end

function UIElement:containsPoint(mx, my)
  return self.visible
    and mx >= self.x
    and mx < self.x + self.width
    and my >= self.y
    and my < self.y + self.height
end

-- fallback term: own term or parent's, or global term
function UIElement:getTerm()
  if self.term then return self.term end
  if self.parent then return self.parent:getTerm() end
  return term
end

function UIElement:draw()
end

function UIElement:handleEvent(event, ...)
end

return UIElement
