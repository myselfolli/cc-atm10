package.path = "/lib/?.lua;" .. "/lib/?/init.lua;" .. package.path

local UI = require("ui.ui")
local Button = require("ui.button")
local Label = require("ui.label")
local Container = require("ui.container")

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
local title = Label:new(2, 2, "Washer Speed Control")

local speedPanel = Container:new(1, 1, 40, 10):setColors(colors.lightGray, colors.black)
local speedLabel = Label:new(2, 3, "Current Speed: " .. currentSpeed .. " RPM")

local function updateSpeedLabel()
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  speedLabel:markDirty()
  ui:draw()
end

speedPanel:add(Button:new(2, 4, 12, "+", function()
  currentSpeed = math.min(currentSpeed + STEP, 512)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setColors(colors.green, colors.black))

speedPanel:add(Button:new(16, 4, 12, "-", function()
  currentSpeed = math.max(currentSpeed - STEP, 0)
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setColors(colors.orange, colors.black))

speedPanel:add(Button:new(30, 4, 12, "Stop", function()
  currentSpeed = 0
  setMotorSpeed(currentSpeed)
  updateSpeedLabel()
end):setColors(colors.red, colors.black))

speedPanel:add(speedLabel)

ui:add(title)
ui:add(speedPanel)

-- Start UI loop
setMotorSpeed(currentSpeed)
ui:run()