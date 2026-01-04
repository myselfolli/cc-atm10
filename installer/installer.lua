-- install.lua
local base = "https://raw.githubusercontent.com/myselfolli/cc-atm10/refs/heads/master/"

-- define libraries
local libs = {
  ui = {
    files = {
      "ui/element.lua",
      "ui/container.lua",
      "ui/gridContainer.lua",
      "ui/button.lua",
      "ui/label.lua",
      "ui/ui.lua",
    },
  },
}

-- define programs and their dependencies
local programs = {
  washer = {
    files = {
      "washer/main.lua",
    },
    dependencies = {"ui"},  -- names from libs table
  },
}

local function multiSelectMenu(options)
  local selected = {}
  local current = 1

  local function draw()
    term.clear()
    term.setCursorPos(1,1)
    for i, option in ipairs(options) do
      local mark = selected[i] and "x" or " "
      if i == current then
        term.setBackgroundColor(colors.gray)
        term.setTextColor(colors.white)
      else
        term.setBackgroundColor(colors.black)
        term.setTextColor(colors.white)
      end
      term.write(string.format("[%s] %s\n", mark, option))
    end
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
  end

  draw()

  while true do
    local event, key = os.pullEvent("key")

    if key == keys.up then
      current = current - 1
      if current < 1 then current = #options end
      draw()
    elseif key == keys.down then
      current = current + 1
      if current > #options then current = 1 end
      draw()
    elseif key == keys.space then
      selected[current] = not selected[current]
      draw()
    elseif key == keys.enter then
      break
    end
  end

  -- convert boolean table to list of indices
  local result = {}
  for i, v in ipairs(selected) do
    if v then table.insert(result, i) end
  end
  return result
end

-- helper to create directories
local function ensureDir(file)
  local dir = fs.getDir(file)
  if dir ~= "" and not fs.exists(dir) then
    fs.makeDir(dir)
  end
end

-- install a list of files to their paths
local function installFiles(fileList)
  for _, file in ipairs(fileList) do
    ensureDir(file)
    if fs.exists(file) then fs.delete(file) end

    local ok, err = pcall(shell.run, "wget", base .. file, file)
    if not ok then
      print("Failed to download:", file, "-", err)
    else
      print("Downloaded:", file)
    end
  end
end

-- install a library into /lib
local function installLib(libName)
  local lib = libs[libName]
  if not lib then
    print("Warning: unknown library", libName)
    return
  end
  print("Installing library:", libName)
  local filesWithLibPath = {}
  for _, file in ipairs(lib.files) do
    filesWithLibPath[#filesWithLibPath+1] = "lib/" .. file
  end
  installFiles(filesWithLibPath)
end

-- install a program
local function installProgram(programName)
  local program = programs[programName]
  if not program then
    print("Unknown program:", programName)
    return
  end

  -- always reinstall dependencies
  for _, dep in ipairs(program.dependencies or {}) do
    installLib(dep)
  end

  -- install program files
  print("Installing program:", programName)
  installFiles(program.files)
end

-- ==== main installer logic ====
write("Which program to install? ")
local programNames = {}
for name,_ in pairs(programs) do table.insert(programNames, name) end

local selectedIndices = multiSelectMenu(programNames)
for _, idx in ipairs(selectedIndices) do
  local progName = programNames[idx]
  installProgram(progName)
end

print("Installation complete")
