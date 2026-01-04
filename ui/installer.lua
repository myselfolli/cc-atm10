-- install.lua
local base = "https://raw.githubusercontent.com/myselfolli/cc-atm10/refs/heads/master/"

local files = {
  "ui/element.lua",
  "ui/container.lua",
  "ui/button.lua",
  "ui/label.lua",
  "ui/ui.lua",
}

for _, file in ipairs(files) do
  -- delete existing file if it exists
  if fs.exists(file) then
    fs.delete(file)
  end

  -- download the file
  shell.run("wget", base .. file, file)
end

print("Installed UI library")
