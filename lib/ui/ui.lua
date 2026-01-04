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
    local eventType = e[1]

    if eventType == "monitor_touch" then
      print("Monitor touch event received")
      local _, _, x, y = table.unpack(e)
      self:handleEvent("mouse_click", 1, x, y)
    else
      self:handleEvent(table.unpack(e))
    end
  end
end

return UI
