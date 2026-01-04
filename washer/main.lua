package.path = "/lib/?.lua;" .. "/lib/?/init.lua;" .. package.path

local UI = require("ui.ui")
local Button = require("ui.button")
local Label = require("ui.label")
local GridContainer = require("ui.gridcontainer")

-- SETUP

local monitor = peripheral.find("monitor")
if not monitor then
    error("No monitor found")
end

monitor.clear()
monitor.setTextScale(1)


local motors = (function()
  local t = {}
  for _, name in ipairs(peripheral.getNames()) do
      if peripheral.getType(name) == "electric_motor" then
          table.insert(t, peripheral.wrap(name))
      end
  end
  return t
end)()

if #motors == 0 then
    error("No electric motors found")
end

-- Motor control

local currentSpeed = 0
local STEP = 32

local function setMotorSpeed(speed)
    for _, motor in ipairs(motors) do
        motor.setSpeed(speed)
    end
end

-- UI Setup

local ui = UI:new(monitor)

local speedPanel = GridContainer:new(1, 1, monitor.getSize(), 5, 5):setBackgroundColor(colors.lightGray)
local speedLabel = Label:new("Current Speed: " .. currentSpeed .. " RPM")

local function updateSpeedLabel()
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  speedLabel:markDirty()
  ui:draw()
end

speedPanel:add(Button:new("+", function()
  currentSpeed = math.min(currentSpeed + STEP, 512)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.green), 3, 2)

speedPanel:add(Button:new("-", function()
  currentSpeed = math.max(currentSpeed - STEP, 0)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.orange), 3, 3)

speedPanel:add(Button:new("Stop", function()
  currentSpeed = 0
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.red), 4, 2, 1, 3)

speedPanel:add(speedLabel, 2, 1, 1, 5)
speedPanel:add(Label:new("Washer Speed Control"), 1, 2, 1, 3)

ui:add(speedPanel)

-- Start UI loop
setMotorSpeed(currentSpeed)
ui:run()