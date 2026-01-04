-- ui/gridContainer.lua
local Container = require("ui.container")

GridContainer = setmetatable({}, {__index = Container})
GridContainer.__index = GridContainer

function GridContainer:new(x, y, width, height, rows, cols)
  local obj = setmetatable(Container:new(x, y, width, height), self)
  obj.rows = rows or 1
  obj.cols = cols or 1
  return obj
end
-- Add a child to a grid cell
-- row/col: 1-based, rowSpan/colSpan: optional
function GridContainer:add(child, row, col, rowSpan, colSpan)
  child.parent = self
  child.gridRow = row or 1
  child.gridCol = col or 1
  child.rowSpan = rowSpan or 1
  child.colSpan = colSpan or 1
  table.insert(self.children, child)
  return self
end

-- Compute absolute position for a child based on its grid cell
function GridContainer:getChildAbsolutePosition(child)
  local cellWidth = math.floor(self.width / self.cols)
  local cellHeight = math.floor(self.height / self.rows)

  local x = self.x + (child.gridCol - 1) * cellWidth
  local y = self.y + (child.gridRow - 1) * cellHeight
  local w = cellWidth * child.colSpan
  local h = cellHeight * child.rowSpan

  return x, y, w, h
end

-- Draw the GridContainer and its children
function GridContainer:draw()
  if not self.visible then return end
  local t = self:getTerm()

  -- Draw background
  t.setBackgroundColor(self:getBG())
  t.setTextColor(self:getFG())
  for dy = 0, self.height - 1 do
    t.setCursorPos(self.x, self.y + dy)
    t.write(string.rep(" ", self.width))
  end

  -- Draw children
  for _, child in ipairs(self.children) do
    local x, y, w, h = self:getChildAbsolutePosition(child)
    child.x, child.y, child.width, child.height = x, y, w, h
    child:draw()
  end

  self.dirty = false
end

return GridContainer