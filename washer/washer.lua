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


local motors = peripheral.find("electric_motor", function(m) return m end, true)

if next(motors) == nil then
    error("No electric motors found")
end

-- Motor control

local currentSpeed = 0
local STEP = 32

local function setMotorSpeed(speed)
    for _, motor in pairs(motors) do
        motor.setSpeed(speed)
    end
end

-- UI Setup

local ui = UI:new(monitor)
local title = Label:new(2, 2, "Washer Speed Control")

local speedPanel = Container:new(1, 1, 40, 10)
local speedLabel = Label:new(2, 3, "Current Speed: " .. currentSpeed .. " RPM")
speedPabnel:add(speedLabel)

speedPanel:add(Button:new(2, 4, 12, "+", function()
  currentSpeed = math.min(currentSpeed + STEP, 512)
  setMotorSpeed(currentSpeed)
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  speedLabel.dirty = true
end))

speedPanel:add(Button:new(16, 4, 12, "-", function()
  currentSpeed = math.max(currentSpeed - STEP, 0)
  setMotorSpeed(currentSpeed)
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  speedLabel.dirty = true
end))

speedPanel:add(Button:new(30, 4, 12, "Stop", function()
  currentSpeed = 0
  setMotorSpeed(currentSpeed)
  speedLabel.text = "Current Speed: " .. currentSpeed .. " RPM"
  speedLabel.dirty = true
end))

ui:add(title)
ui:add(speedPanel)