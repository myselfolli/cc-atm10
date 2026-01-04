-- install.lua
local base = "https://raw.githubusercontent.com/myselfolli/cc-atm10/refs/heads/master/"

local files = {
  "lib/element.lua",
  "lib/container.lua",
  "lib/button.lua",
  "lib/label.lua",
  "lib/ui.lua",
}

for _, file in ipairs(files) do
  shell.run("wget", base .. file, file)
end

print("Installed UI library")
