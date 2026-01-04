package.path = "/lib/?.lua;" .. "/lib/?/init.lua;" .. package.path

local Label = require("ui.label")
local GridContainer = require("ui.gridcontainer")
local UI = require("ui.ui")

local monitor = peripheral.find("monitor")
if not monitor then
    error("No monitor found")
end

monitor.clear()
monitor.setTextScale(1)

local ui = UI:new(monitor)
local grid = GridContainer:new(1, 1, monitor.getSize(), 5, 5):setBackgroundColor(colors.blue)

grid:add(Label:new("Label 1"), 1, 1)
grid:add(Label:new("Label 2"), 2, 2)
grid:add(Label:new("Label 3"), 3, 3)
grid:add(Label:new("Label 4"), 4, 4)
grid:add(Label:new("Label 5"), 5, 5)

ui:add(grid)
ui:draw()