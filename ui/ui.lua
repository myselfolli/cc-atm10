-- ui/ui.lua
local UI = {}
UI.__index = UI

function UI:new(termObj)
  local obj = setmetatable({}, self)
  obj.elements = {}
  obj.term = termObj or term
  return obj
end

function UI:add(element)
  element.parent = nil
  element.term = self.term
  table.insert(self.elements, element)
end

function UI:draw()
  for _, el in ipairs(self.elements) do
    el:draw()
  end
end

function UI:handleEvent(event, ...)
  for _, el in ipairs(self.elements) do
    el:handleEvent(event, ...)
  end
end

function UI:run()
  self:draw()
  while true do
    local e = { os.pullEvent() }
    self:handleEvent(table.unpack(e))
  end
end

return UI
