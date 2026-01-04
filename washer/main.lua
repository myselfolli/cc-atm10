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

local monWidth, monHeight = monitor.getSize()

local speedPanel = GridContainer:new(1, 1, monWidth, monHeight, 5, 6):setBackgroundColor(colors.lightGray)
local speedLabel = Label:new("Current Speed: " .. currentSpeed .. " RPM")

ui:add(speedPanel)

local function updateSpeedLabel()
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  ui:draw()
end

speedPanel:add(Button:new("+", function()
  currentSpeed = math.min(currentSpeed + STEP, 512)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.green), 4, 3)

speedPanel:add(Button:new("-", function()
  currentSpeed = math.max(currentSpeed - STEP, 0)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.orange), 4, 5)

speedPanel:add(Button:new("Stop", function()
  currentSpeed = 0
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setTextColor(colors.red), 5, 4)

speedPanel:add(speedLabel, 3, 3)
speedPanel:add(Label:new("Washer Speed Control"), 1, 3)

-- Start UI loop
setMotorSpeed(currentSpeed)
ui:run()