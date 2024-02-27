-- This is a template for a custom code extension for the Ironmon Tracker.
-- To use, first rename both this top-most function and the return value at the bottom: "CodeExtensionTemplate" -> "YourFileNameHere"
-- Then fill in each function you want to use with the code you want executed during Tracker runtime.
-- The name, author, and description attribute fields are used by the Tracker to identify this extension, please always include them.
-- You can safely remove unused functions; they won't be called.

local function AutoNames()
	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	local self = {}
	self.version = "0.1"
	self.name = "Auto Names"
	self.author = "Sticke"
	self.description = "Automatically sets Player & Rival names and gender"
	self.github = "Sticke/AutoNames" -- Replace "MyUsername" and "ExtensionRepo" to match your GitHub repo url, if any
	self.url = string.format("https://github.com/%s", self.github or "") -- Remove this attribute if no host website available for this extension

	local SETTINGS_FILENAME = "AutoNames.json"
	local NEWLINE = "\r\n"
	self.DefaultOptions = {
    player = {
      name = "Ash",
      gender = "Female"
    },
    rival = {
      name = "Gary",
    }
  }

  local characterTable = {
    [' '] = 0x00,
    ['À'] = 0x01,
    ['Á'] = 0x02,
    ['Â'] = 0x03,
    ['Ç'] = 0x04,
    ['È'] = 0x05,
    ['É'] = 0x06,
    ['Ê'] = 0x07,
    ['Ë'] = 0x08,
    ['Ì'] = 0x09,
    ['Î'] = 0x0B,
    ['Ï'] = 0x0C,
    ['Ò'] = 0x0D,
    ['Ó'] = 0x0E,
    ['Ô'] = 0x0F,
    ['Œ'] = 0x10,
    ['Ù'] = 0x11,
    ['Ú'] = 0x12,
    ['Û'] = 0x13,
    ['Ñ'] = 0x14,
    ['ß'] = 0x15,
    ['à'] = 0x16,
    ['á'] = 0x17,
    ['ç'] = 0x19,
    ['è'] = 0x1A,
    ['é'] = 0x1B,
    ['ê'] = 0x1C,
    ['ë'] = 0x1D,
    ['ì'] = 0x1E,
    ['î'] = 0x20,
    ['ï'] = 0x21,
    ['ò'] = 0x22,
    ['ó'] = 0x23,
    ['ô'] = 0x24,
    ['œ'] = 0x25,
    ['ù'] = 0x26,
    ['ú'] = 0x27,
    ['û'] = 0x28,
    ['ñ'] = 0x29,
    ['º'] = 0x2A,
    ['ª'] = 0x2B,
    -- [SUPER_ER] = 0x2C,
    ['&'] = 0x2D,
    ['+'] = 0x2E,
    -- [LV] = 0x34,
    ['='] = 0x35,
    [';'] = 0x36,
    ['¿'] = 0x51,
    ['¡'] = 0x52,
    -- [PK] = 0x53,
    -- [PKMN] = 0x54, -- 0x53, 54
    -- [POKEBLOCK] = 0x55, -- 0x55, 56 57 58 59
    ['Í'] = 0x5A,
    ['%'] = 0x5B,
    ['('] = 0x5C,
    [')'] = 0x5D,
    ['â'] = 0x68,
    ['í'] = 0x6F,
    -- [UP_ARROW] = 0x79,
    -- [DOWN_ARROW] = 0x7A,
    -- [LEFT_ARROW] = 0x7B,
    -- [RIGHT_ARROW] = 0x7C,
    -- [SUPER_E] = 0x84,
    ['<'] = 0x85,
    ['>'] = 0x86,
    -- [SUPER_RE] = 0xA0,
    ['0'] = 0xA1,
    ['1'] = 0xA2,
    ['2'] = 0xA3,
    ['3'] = 0xA4,
    ['4'] = 0xA5,
    ['5'] = 0xA6,
    ['6'] = 0xA7,
    ['7'] = 0xA8,
    ['8'] = 0xA9,
    ['9'] = 0xAA,
    ['!'] = 0xAB,
    ['?'] = 0xAC,
    ['.'] = 0xAD,
    ['-'] = 0xAE,
    ['·'] = 0xAF,
    ['…'] = 0xB0,
    ['“'] = 0xB1,
    ['”'] = 0xB2,
    ['‘'] = 0xB3,
    ['’'] = 0xB4,
    ['\''] = 0xB4,
    ['♂'] = 0xB5,
    ['♀'] = 0xB6,
    ['¥'] = 0xB7,
    [','] = 0xB8,
    ['×'] = 0xB9,
    ['/'] = 0xBA,
    ['A'] = 0xBB,
    ['B'] = 0xBC,
    ['C'] = 0xBD,
    ['D'] = 0xBE,
    ['E'] = 0xBF,
    ['F'] = 0xC0,
    ['G'] = 0xC1,
    ['H'] = 0xC2,
    ['I'] = 0xC3,
    ['J'] = 0xC4,
    ['K'] = 0xC5,
    ['L'] = 0xC6,
    ['M'] = 0xC7,
    ['N'] = 0xC8,
    ['O'] = 0xC9,
    ['P'] = 0xCA,
    ['Q'] = 0xCB,
    ['R'] = 0xCC,
    ['S'] = 0xCD,
    ['T'] = 0xCE,
    ['U'] = 0xCF,
    ['V'] = 0xD0,
    ['W'] = 0xD1,
    ['X'] = 0xD2,
    ['Y'] = 0xD3,
    ['Z'] = 0xD4,
    ['a'] = 0xD5,
    ['b'] = 0xD6,
    ['c'] = 0xD7,
    ['d'] = 0xD8,
    ['e'] = 0xD9,
    ['f'] = 0xDA,
    ['g'] = 0xDB,
    ['h'] = 0xDC,
    ['i'] = 0xDD,
    ['j'] = 0xDE,
    ['k'] = 0xDF,
    ['l'] = 0xE0,
    ['m'] = 0xE1,
    ['n'] = 0xE2,
    ['o'] = 0xE3,
    ['p'] = 0xE4,
    ['q'] = 0xE5,
    ['r'] = 0xE6,
    ['s'] = 0xE7,
    ['t'] = 0xE8,
    ['u'] = 0xE9,
    ['v'] = 0xEA,
    ['w'] = 0xEB,
    ['x'] = 0xEC,
    ['y'] = 0xED,
    ['z'] = 0xEE,
    ['▶'] = 0xEF,
    [':'] = 0xF0,
    ['Ä'] = 0xF1,
    ['Ö'] = 0xF2,
    ['Ü'] = 0xF3,
    ['ä'] = 0xF4,
    ['ö'] = 0xF5,
    ['ü'] = 0xF6,
  }

  --------------------------------------
	-- INTENRAL TRACKER FUNCTIONS BELOW
	-- Add any number of these below functions to your extension that you want to use.
	-- If you don't need a function, don't add it at all; leave ommitted for faster code execution.
	--------------------------------------

  function self.applyPlayerInfo(player)
    local saveBlock2 = memory.read_u32_le(0x0300500C) -- Save Block 2 (DMA Protected)

    local bytes = self.getBytesFromText(player.name, 7)
    local name_tophalf = bytes[1] + bytes[2]*0x100 + bytes[3] * 0x10000 + bytes[4]*0x1000000
    local name_bottomhalf = bytes[5] + bytes[6]*0x100 + bytes[7] * 0x10000 + bytes[8]*0x1000000

    memory.write_u32_le(saveBlock2, name_tophalf)
    memory.write_u32_le(saveBlock2 + 4, name_bottomhalf)

    local gender = 0 -- Default to Male
    if player.gender == 'Female' then
      gender = 1
    end

    memory.write_u8(saveBlock2 + 8, gender)
  end

  function self.applyRivalInfo(rival)
    local saveBlock1 = memory.read_u32_le(0x03005008)

    local bytes = self.getBytesFromText(rival.name, 7)
    local name_tophalf = bytes[1] + bytes[2]*0x100 + bytes[3] * 0x10000 + bytes[4]*0x1000000
    local name_bottomhalf = bytes[5] + bytes[6]*0x100 + bytes[7] * 0x10000 + bytes[8]*0x1000000

    memory.write_u32_le(saveBlock1 + 0x3A4C, name_tophalf)
    memory.write_u32_le(saveBlock1 + 0x3A4C + 4, name_bottomhalf)
  end

  function self.getByteFromCharacter(character)
    return characterTable[character] or 0xAC
  end

  function self.getBytesFromText(text, size)
    local byteArray = {}
    for i = 1, #text do
      local char = text:sub(i, i)
      byteArray[i] = self.getByteFromCharacter(char)
    end

    if #byteArray > size then
      local trimmedArray = {}
      for i = 1, size do
        trimmedArray[i] = byteArray[i]
      end
      byteArray = trimmedArray
    end

    for i = #byteArray + 1, size+1 do
      byteArray[i] = 0xFF
    end

    return byteArray
  end

  function self.getFilepathForOptions()
    return FileManager.getCustomFolderPath() .. SETTINGS_FILENAME
  end

  function self.getOptionsFromFile()
    local filepath = self.getFilepathForOptions()
    if not filepath then
      return {}
    end
    return FileManager.decodeJsonFile(filepath) or {}
  end

  function self.saveOptionsToFile(options)
    self.applyPlayerInfo(options.player)
    self.applyRivalInfo(options.rival)

    local filepath = self.getFilepathForOptions()
    if not filepath then
      return {}
    end
    return FileManager.encodeToJsonFile(filepath, options or {})
  end

	function self.openPopup()
    local x, y, w, h, lineHeight = 20, 15, 400, 200, 20
        local bottomPadding = 65
        local form = Utils.createBizhawkForm("Edit Player & Rival Names", w, h, 80, 20)

        forms.label(form, "Player Name:", x, y, w - 40, lineHeight)
        y = y + 20

        local playerNameTextBox = forms.textbox(form, self.DefaultOptions.player.name, w - 40, lineHeight, nil, x - 1, y, false)
        y = y + lineHeight + 10

        forms.label(form, "Player Gender:", x, y, w - 40, lineHeight)
        y = y + 20

        local playerGenderDropdown = forms.dropdown(form, {'Male', 'Female'}, x - 1, y, w - 40, lineHeight)
        y = y + lineHeight + 10

        forms.label(form, "Rival Name:", x, y, w - 40, lineHeight)
        y = y + 20

        local rivalNameTextBox = forms.textbox(form, self.DefaultOptions.rival.name, w - 40, lineHeight, nil, x - 1, y, false)
        y = y + lineHeight + 10

        forms.button(form, "Save", function()
            local options = {
                player = {
                    name = forms.gettext(playerNameTextBox) or self.DefaultOptions.player.name,
                    gender = forms.gettext(playerGenderDropdown) or 'Male'
                },
                rival = {
                    name = forms.gettext(rivalNameTextBox) or self.DefaultOptions.rival.name,
                    gender = self.DefaultOptions.rival.gender
                }
            }
            self.saveOptionsToFile(options)
            Utils.closeBizhawkForm(form)
        end, x + 70, y)

        forms.button(form, "Cancel", function()
            Utils.closeBizhawkForm(form)
        end, x + 170, y)
  end

	-- Executed when the user clicks the "Options" button while viewing the extension details within the Tracker's UI
	-- Remove this function if you choose not to include a way for the user to configure options for your extension
	-- NOTE: You'll need to implement a way to save & load changes for your extension options, similar to Tracker's Settings.ini file
	function self.configureOptions()
    self.openPopup()
	end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		-- Update the pattern below to match your version. You can check what this looks like by visiting the latest release url on your repo
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"' -- matches "1.0" in "tag_name": "v1.0"
		local versionCheckUrl = string.format("https://api.github.com/repos/%s/releases/latest", self.github or "")
		local downloadUrl = string.format("%s/releases/latest", self.url or "")
		local compareFunc = function(a, b) return a ~= b and not Utils.isNewerVersion(a, b) end -- if current version is *older* than online version
		local isUpdateAvailable = Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, compareFunc)
		return isUpdateAvailable, downloadUrl
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
    if FileManager.fileExists(self.getFilepathForOptions()) then
      local options = self.getOptionsFromFile()
      self.DefaultOptions = options
    end

    self.applyPlayerInfo(self.DefaultOptions.player)
    self.applyRivalInfo(self.DefaultOptions.rival)
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames, after most data from game memory is read in
	function self.afterProgramDataUpdate()
		-- [ADD CODE HERE]
    self.applyPlayerInfo(self.DefaultOptions.player)
    self.applyRivalInfo(self.DefaultOptions.rival)
 end

	-- Executed once every 30 frames, after any battle related data from game memory is read in
	function self.afterBattleDataUpdate()
		-- [ADD CODE HERE]
	end

	-- Executed once every 30 frames or after any redraw event is scheduled (i.e. most button presses)
	function self.afterRedraw()
		-- [ADD CODE HERE]
	end

	-- Executed before a button's onClick() is processed, and only once per click per button
	-- Param: button: the button object being clicked
	function self.onButtonClicked(button)
		-- [ADD CODE HERE]
	end

	-- Executed after a new battle begins (wild or trainer), and only once per battle
	function self.afterBattleBegins()
		-- [ADD CODE HERE]
	end

	-- Executed after a battle ends, and only once per battle
	function self.afterBattleEnds()
		-- [ADD CODE HERE]
	end

	-- [Bizhawk only] Executed each frame (60 frames per second)
	-- CAUTION: Avoid unnecessary calculations here, as this can easily affect performance.
	function self.inputCheckBizhawk()
		-- Uncomment to use, otherwise leave commented out
			-- local mouseInput = input.getmouse() -- lowercase 'input' pulls directly from Bizhawk API
			-- local joypadButtons = Input.getJoypadInputFormatted() -- uppercase 'Input' uses Tracker formatted input
		-- [ADD CODE HERE]
	end

	-- [MGBA only] Executed each frame (60 frames per second)
	-- CAUTION: Avoid unnecessary calculations here, as this can easily affect performance.
	function self.inputCheckMGBA()
		-- Uncomment to use, otherwise leave commented out
			-- local joypadButtons = Input.getJoypadInputFormatted()
		-- [ADD CODE HERE]
	end

  -- gTasks struct offsets
  local gTasks = 0x03005090
  local NUM_TASK_DATA = 16
  local OFFSET_FUNC = 0
  local OFFSET_IS_ACTIVE = 4
  local OFFSET_PREV = 5
  local OFFSET_NEXT = 6
  local OFFSET_PRIORITY = 7
  local OFFSET_DATA = 8
  local TASK_SIZE = 40 -- Size of each task struct in bytes

  -- Function to read a task from memory
  local function read_task(taskIndex)
      local task = {}

      task.func = memory.read_u32_le(gTasks + taskIndex * TASK_SIZE + OFFSET_FUNC)
      task.isActive = memory.read_u8(gTasks + taskIndex * TASK_SIZE + OFFSET_IS_ACTIVE)
      task.prev = memory.read_u8(gTasks + taskIndex * TASK_SIZE + OFFSET_PREV)
      task.next = memory.read_u8(gTasks + taskIndex * TASK_SIZE + OFFSET_NEXT)
      task.priority = memory.read_u8(gTasks + taskIndex * TASK_SIZE + OFFSET_PRIORITY)

      task.data = {}
      for i = 0, NUM_TASK_DATA - 1 do
          task.data[i + 1] = memory.read_s16_le(gTasks + taskIndex * TASK_SIZE + OFFSET_DATA + i * 2)
      end

      return task
  end

  -- Function to draw a task on the screen
  local function draw_task(taskIndex, task)
      if task.isActive == 0 then
        return
      end

      local x = 10
      local y = 0 + taskIndex * 10
      gui.drawText(x, y, "T:" .. taskIndex, 'white', 'black')
      x = x + 35
      gui.drawText(x, y, "F:" .. string.format("%6X", task.func), 'white', 'black')
      x = x + 75
      -- gui.drawText(x, y, "Active: " .. task.isActive, 'white', 'black')
      -- x = x + 50
      gui.drawText(x, y, "P:" .. task.prev, 'blue', 'black')
      x = x + 40
      gui.drawText(x, y, "N:" .. task.next, 'yellow', 'black')
      x = x + 40
      -- gui.drawText(x, y, "Prio: " .. task.priority)
      -- y = y + 10
      for i, data in ipairs(task.data) do
          gui.drawText(x, y, data, 'white', 'black')
          x = x + 25
      end
  end

	-- Executed each frame of the game loop, after most data from game memory is read in but before any natural redraw events occur
	-- CAUTION: Avoid code here if possible, as this can easily affect performance. Most Tracker updates occur at 30-frame intervals, some at 10-frame.
	function self.afterEachFrame()
		-- [ADD CODE HERE]
    -- if read_task(0).func == 0x8130069 or (read_task(2).func == 0x809DD9D and read_task(2).isActive == 0) then
    --   -- print('Applying info')
    --   self.applyPlayerInfo(self.DefaultOptions.player)
    --   self.applyRivalInfo(self.DefaultOptions.rival)
    -- end

    -- local numTasks = 16 -- Assuming there are 16 tasks

    -- Read and print each task
    -- for i = 0, numTasks - 1 do
    --     local task = read_task(i)
    --     -- print("Task " .. i)
    --     -- print_task(task)
    --     draw_task(i, task)
    --     -- print("--------------------")
    -- end
	end

	return self
end
return AutoNames
