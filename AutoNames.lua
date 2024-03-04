local function AutoNames()
	-- Define descriptive attributes of the custom extension that are displayed on the Tracker settings
	local self = {}
	self.version = "1.0"
	self.name = "Auto Names"
	self.author = "Sticke"
	self.description = "Automatically sets Player & Rival names and sprites (currently only works for Gen3)"
	self.github = "Sticke0/AutoNames" -- Replace "MyUsername" and "ExtensionRepo" to match your GitHub repo url, if any
	self.url = string.format("https://github.com/%s", self.github or "") -- Remove this attribute if no host website available for this extension

	local SETTINGS_FILENAME = "AutoNames.json"
	local CUSTOM_SPRITE_FOLDER = FileManager.getCustomFolderPath() .. "AutoNamesSprites\\"

	self.skipHelpBoxEvent = ""
	self.setInfoEvent = ""

	self.setInfoEventName = "Set Player & Rival info"
	self.skipHelpBoxEventName = "Hide intro help box"

	self.DefaultOptions = {
		player = {
			name = "Ash",
			sprite = "Boy",
		},
		rival = {
			name = "Gary",
			gender = "Boy",
		},
	}

	self.SpriteDataLookup = {
		FRLG = { "Boy", "Girl" },
	}

	self.SpriteData = {}
	for k, v in pairs(self.SpriteDataLookup) do
		self.SpriteData[k] = {}
		for i = 1, #v do
			self.SpriteData[k][v[i]] = i
		end
	end

	-- Screen "classes"
	local NameEditScreen = {}
	local previousScreen = nil -- Used to help navigate backward from the options menu, for ease of access

	local characterTable = {
		[" "] = 0x00,
		["À"] = 0x01,
		["Á"] = 0x02,
		["Â"] = 0x03,
		["Ç"] = 0x04,
		["È"] = 0x05,
		["É"] = 0x06,
		["Ê"] = 0x07,
		["Ë"] = 0x08,
		["Ì"] = 0x09,
		["Î"] = 0x0B,
		["Ï"] = 0x0C,
		["Ò"] = 0x0D,
		["Ó"] = 0x0E,
		["Ô"] = 0x0F,
		["Œ"] = 0x10,
		["Ù"] = 0x11,
		["Ú"] = 0x12,
		["Û"] = 0x13,
		["Ñ"] = 0x14,
		["ß"] = 0x15,
		["à"] = 0x16,
		["á"] = 0x17,
		["ç"] = 0x19,
		["è"] = 0x1A,
		["é"] = 0x1B,
		["ê"] = 0x1C,
		["ë"] = 0x1D,
		["ì"] = 0x1E,
		["î"] = 0x20,
		["ï"] = 0x21,
		["ò"] = 0x22,
		["ó"] = 0x23,
		["ô"] = 0x24,
		["œ"] = 0x25,
		["ù"] = 0x26,
		["ú"] = 0x27,
		["û"] = 0x28,
		["ñ"] = 0x29,
		["º"] = 0x2A,
		["ª"] = 0x2B,
		-- [SUPER_ER] = 0x2C,
		["&"] = 0x2D,
		["+"] = 0x2E,
		-- [LV] = 0x34,
		["="] = 0x35,
		[";"] = 0x36,
		["¿"] = 0x51,
		["¡"] = 0x52,
		-- [PK] = 0x53,
		-- [PKMN] = 0x54, -- 0x53, 54
		-- [POKEBLOCK] = 0x55, -- 0x55, 56 57 58 59
		["Í"] = 0x5A,
		["%"] = 0x5B,
		["("] = 0x5C,
		[")"] = 0x5D,
		["â"] = 0x68,
		["í"] = 0x6F,
		-- [UP_ARROW] = 0x79,
		-- [DOWN_ARROW] = 0x7A,
		-- [LEFT_ARROW] = 0x7B,
		-- [RIGHT_ARROW] = 0x7C,
		-- [SUPER_E] = 0x84,
		["<"] = 0x85,
		[">"] = 0x86,
		-- [SUPER_RE] = 0xA0,
		["0"] = 0xA1,
		["1"] = 0xA2,
		["2"] = 0xA3,
		["3"] = 0xA4,
		["4"] = 0xA5,
		["5"] = 0xA6,
		["6"] = 0xA7,
		["7"] = 0xA8,
		["8"] = 0xA9,
		["9"] = 0xAA,
		["!"] = 0xAB,
		["?"] = 0xAC,
		["."] = 0xAD,
		["-"] = 0xAE,
		["·"] = 0xAF,
		["…"] = 0xB0,
		["“"] = 0xB1,
		["”"] = 0xB2,
		["‘"] = 0xB3,
		["’"] = 0xB4,
		["'"] = 0xB4,
		["♂"] = 0xB5,
		["♀"] = 0xB6,
		["¥"] = 0xB7,
		[","] = 0xB8,
		["×"] = 0xB9,
		["/"] = 0xBA,
		["A"] = 0xBB,
		["B"] = 0xBC,
		["C"] = 0xBD,
		["D"] = 0xBE,
		["E"] = 0xBF,
		["F"] = 0xC0,
		["G"] = 0xC1,
		["H"] = 0xC2,
		["I"] = 0xC3,
		["J"] = 0xC4,
		["K"] = 0xC5,
		["L"] = 0xC6,
		["M"] = 0xC7,
		["N"] = 0xC8,
		["O"] = 0xC9,
		["P"] = 0xCA,
		["Q"] = 0xCB,
		["R"] = 0xCC,
		["S"] = 0xCD,
		["T"] = 0xCE,
		["U"] = 0xCF,
		["V"] = 0xD0,
		["W"] = 0xD1,
		["X"] = 0xD2,
		["Y"] = 0xD3,
		["Z"] = 0xD4,
		["a"] = 0xD5,
		["b"] = 0xD6,
		["c"] = 0xD7,
		["d"] = 0xD8,
		["e"] = 0xD9,
		["f"] = 0xDA,
		["g"] = 0xDB,
		["h"] = 0xDC,
		["i"] = 0xDD,
		["j"] = 0xDE,
		["k"] = 0xDF,
		["l"] = 0xE0,
		["m"] = 0xE1,
		["n"] = 0xE2,
		["o"] = 0xE3,
		["p"] = 0xE4,
		["q"] = 0xE5,
		["r"] = 0xE6,
		["s"] = 0xE7,
		["t"] = 0xE8,
		["u"] = 0xE9,
		["v"] = 0xEA,
		["w"] = 0xEB,
		["x"] = 0xEC,
		["y"] = 0xED,
		["z"] = 0xEE,
		["▶"] = 0xEF,
		[":"] = 0xF0,
		["Ä"] = 0xF1,
		["Ö"] = 0xF2,
		["Ü"] = 0xF3,
		["ä"] = 0xF4,
		["ö"] = 0xF5,
		["ü"] = 0xF6,
		["\n"] = 0xFE,
		["\b"] = 0xFB,
		["\r"] = 0xFA,
	}

	--------------------------------------
	-- INTENRAL TRACKER FUNCTIONS BELOW
	-- Add any number of these below functions to your extension that you want to use.
	-- If you don't need a function, don't add it at all; leave ommitted for faster code execution.
	--------------------------------------

	function self.applyPlayerInfo(player)
		local saveBlock2 = memory.read_u32_le(0x0300500C) -- Save Block 2 (DMA Protected)

		local bytes = self.getBytesFromText(player.name, 7)
    print(player.name)
		local name_tophalf = bytes[1] + bytes[2] * 0x100 + bytes[3] * 0x10000 + bytes[4] * 0x1000000
		local name_bottomhalf = bytes[5] + bytes[6] * 0x100 + bytes[7] * 0x10000 + bytes[8] * 0x1000000

		memory.write_u32_le(saveBlock2, name_tophalf)
		memory.write_u32_le(saveBlock2 + 4, name_bottomhalf)

		local sprite = self.SpriteData.FRLG[player.sprite] - 1 or 0 -- Default to Male
		memory.write_u8(saveBlock2 + 8, sprite)
	end

	function self.applyRivalInfo(rival)
		local saveBlock1 = memory.read_u32_le(0x03005008)

		local bytes = self.getBytesFromText(rival.name, 7)
		local name_tophalf = bytes[1] + bytes[2] * 0x100 + bytes[3] * 0x10000 + bytes[4] * 0x1000000
		local name_bottomhalf = bytes[5] + bytes[6] * 0x100 + bytes[7] * 0x10000 + bytes[8] * 0x1000000

		memory.write_u32_le(saveBlock1 + 0x3A4C, name_tophalf)
		memory.write_u32_le(saveBlock1 + 0x3A4C + 4, name_bottomhalf)
	end

	function self.getByteFromCharacter(character)
		return characterTable[character] or 0xAC
	end

	function self.getBytesFromText(text, maxSize)
		local byteArray = {}
		for i = 1, #text do
			local char = text:sub(i, i)
			byteArray[i] = self.getByteFromCharacter(char)
		end

		if #byteArray > maxSize and maxSize > 0 then
			local trimmedArray = {}
			for i = 1, maxSize do
				trimmedArray[i] = byteArray[i]
			end
			byteArray = trimmedArray
		end

		for i = #byteArray + 1, maxSize do
			byteArray[i] = 0xFF
		end

		byteArray[#byteArray + 1] = 0xFF

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

	function self.getTextInput(title, fieldName, default, callback)
		local x, y, w, h, lineHeight = 20, 15, 300, 150, 20
		local form = Utils.createBizhawkForm(title, w, h, 80, 20)

		forms.label(form, fieldName, x, y, w - 40, lineHeight)
		y = y + 20

		local textbox = forms.textbox(form, default, w - 40, lineHeight, nil, x - 1, y, false)
		y = y + lineHeight + 10

		forms.button(form, "Save", function()
			callback(forms.gettext(textbox))
			Utils.closeBizhawkForm(form)
		end, x + 70, y)

		forms.button(form, "Cancel", function()
			callback(default)
			Utils.closeBizhawkForm(form)
		end, x + 170, y)
	end

	-- NameEditScreen --
	NameEditScreen.Colors = {
		text = "Default text",
		highlight = "Intermediate text",
		border = "Upper box border",
		fill = "Upper box background",
	}

	NameEditScreen.Buttons = {
		PlayerName = {
			type = Constants.ButtonTypes.NO_BORDER,
			getText = function(this)
				return string.format("Player name: %s", self.DefaultOptions.player.name)
			end,
			box = { Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN + 2, Constants.SCREEN.MARGIN + 20, 65, 11 },
			isVisible = function(this)
				return true
			end,
			onClick = function(this)
				self.getTextInput(
					"Please enter player name",
					"Player name",
					self.DefaultOptions.player.name,
					function(input)
						self.DefaultOptions.player.name = input
						Program.redraw(true)
						self.saveOptionsToFile(self.DefaultOptions)
					end
				)
			end,
		},
		RivalName = {
			type = Constants.ButtonTypes.NO_BORDER,
			getText = function(this)
				return string.format("Rival name: %s", self.DefaultOptions.rival.name)
			end,
			box = { Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN + 2, Constants.SCREEN.MARGIN + 30, 65, 11 },
			isVisible = function(this)
				return true
			end,
			onClick = function(this)
				self.getTextInput(
					"Please enter rival name",
					"Player rival",
					self.DefaultOptions.rival.name,
					function(input)
						self.DefaultOptions.rival.name = input
						Program.redraw(true)
						self.saveOptionsToFile(self.DefaultOptions)
					end
				)
			end,
		},
		PlayerSpriteIcon = {
			type = Constants.ButtonTypes.IMAGE,
			image = CUSTOM_SPRITE_FOLDER .. self.DefaultOptions.player.sprite .. ".png",
			box = { Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN + 52, Constants.SCREEN.MARGIN + 50, 65, 11 },
			isVisible = function(this)
				return true
			end,
			update = function(this)
				this.image = CUSTOM_SPRITE_FOLDER .. self.DefaultOptions.player.sprite .. ".png"
				self.saveOptionsToFile(self.DefaultOptions)
				Program.redraw(true)
			end,
		},
		CycleIconForward = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.RIGHT_ARROW,
			box = { Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN + 94, Constants.SCREEN.MARGIN + 74, 10, 10 },
			isVisible = function(this)
				return true
			end,
			onClick = function(this)
				local count = #self.SpriteDataLookup.FRLG
				local index = self.SpriteData.FRLG[self.DefaultOptions.player.sprite] + 1
				if index == count + 1 then
					index = 1
				end
				self.DefaultOptions.player.sprite = self.SpriteDataLookup.FRLG[index]
				NameEditScreen.Buttons.PlayerSpriteIcon:update()
			end,
		},
		CycleIconBackward = {
			type = Constants.ButtonTypes.PIXELIMAGE,
			image = Constants.PixelImages.LEFT_ARROW,
			box = { Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN + 34, Constants.SCREEN.MARGIN + 74, 10, 10 },
			isVisible = function(this)
				return true
			end,
			onClick = function(this)
				local count = #self.SpriteDataLookup.FRLG
				local index = self.SpriteData.FRLG[self.DefaultOptions.player.sprite] - 1
				if index == 0 then
					index = count
				end
				self.DefaultOptions.player.sprite = self.SpriteDataLookup.FRLG[index]
				NameEditScreen.Buttons.PlayerSpriteIcon:update()
			end,
		},

		Back = Drawing.createUIElementBackButton(function()
			Program.changeScreenView(previousScreen or SingleExtensionScreen)
			previousScreen = nil
		end, NameEditScreen.Colors.text),
	}

	for _, button in pairs(NameEditScreen.Buttons) do
		if button.textColor == nil then
			button.textColor = NameEditScreen.Colors.text
		end
		if button.boxColors == nil then
			button.boxColors = { NameEditScreen.Colors.border, NameEditScreen.Colors.fill }
		end
	end

	function NameEditScreen.refreshButtons()
		for _, button in pairs(NameEditScreen.Buttons or {}) do
			if type(button.updateSelf) == "function" then
				button:updateSelf()
			end
		end
	end

	function NameEditScreen.checkInput(xmouse, ymouse)
		Input.checkButtonsClicked(xmouse, ymouse, NameEditScreen.Buttons or {})
	end

	function NameEditScreen.drawScreen()
		local canvas = {
			x = Constants.SCREEN.WIDTH + Constants.SCREEN.MARGIN,
			y = Constants.SCREEN.MARGIN,
			w = Constants.SCREEN.RIGHT_GAP - (Constants.SCREEN.MARGIN * 2),
			h = Constants.SCREEN.HEIGHT - (Constants.SCREEN.MARGIN * 2),
			text = Theme.COLORS[NameEditScreen.Colors.text],
			border = Theme.COLORS[NameEditScreen.Colors.border],
			fill = Theme.COLORS[NameEditScreen.Colors.fill],
			shadow = Utils.calcShadowColor(Theme.COLORS[NameEditScreen.Colors.fill]),
		}
		Drawing.drawBackgroundAndMargins()
		gui.defaultTextBackground(canvas.fill)

		-- Draw the canvas box
		gui.drawRectangle(canvas.x, canvas.y, canvas.w, canvas.h, canvas.border, canvas.fill)

		-- Draw the pokemon icon first
		Drawing.drawButton(NameEditScreen.Buttons.PokemonIcon, canvas.shadow)

		-- Title text
		local topText
		topText = Utils.formatSpecialCharacters("Auto Names" or self.name)

		local centeredX = Utils.getCenteredTextX(topText, canvas.w) - 2
		Drawing.drawTransparentTextbox(
			canvas.x + centeredX,
			canvas.y + 2,
			topText,
			canvas.text,
			canvas.fill,
			canvas.shadow
		)

		-- Draw all other the buttons
		for _, button in pairs(NameEditScreen.Buttons or {}) do
			if button ~= NameEditScreen.Buttons.PokemonIcon then
				Drawing.drawButton(button, canvas.shadow)
			end
		end
	end

	-- Executed when the user clicks the "Options" button while viewing the extension details within the Tracker's UI
	-- Remove this function if you choose not to include a way for the user to configure options for your extension
	-- NOTE: You'll need to implement a way to save & load changes for your extension options, similar to Tracker's Settings.ini file
	function self.configureOptions()
		-- self.openPopup()
		Program.changeScreenView(NameEditScreen)
	end

	-- Executed when the user clicks the "Check for Updates" button while viewing the extension details within the Tracker's UI
	-- Returns [true, downloadUrl] if an update is available (downloadUrl auto opens in browser for user); otherwise returns [false, downloadUrl]
	-- Remove this function if you choose not to implement a version update check for your extension
	function self.checkForUpdates()
		-- Update the pattern below to match your version. You can check what this looks like by visiting the latest release url on your repo
		local versionResponsePattern = '"tag_name":%s+"%w+(%d+%.%d+)"' -- matches "1.0" in "tag_name": "v1.0"
		local versionCheckUrl = string.format("https://api.github.com/repos/%s/releases/latest", self.github or "")
		local downloadUrl = string.format("%s/releases/latest", self.url or "")
		local compareFunc = function(a, b)
			return a ~= b and not Utils.isNewerVersion(a, b)
		end -- if current version is *older* than online version
		local isUpdateAvailable =
			Utils.checkForVersionUpdate(versionCheckUrl, self.version, versionResponsePattern, compareFunc)
		return isUpdateAvailable, downloadUrl
	end

	-- Executed only once: When the extension is enabled by the user, and/or when the Tracker first starts up, after it loads all other required files and code
	function self.startup()
		if FileManager.fileExists(self.getFilepathForOptions()) then
			local options = self.getOptionsFromFile()
			self.DefaultOptions = options
		end

		NameEditScreen.Buttons.PlayerSpriteIcon.image = CUSTOM_SPRITE_FOLDER
			.. self.DefaultOptions.player.sprite
			.. ".png"

    -- Because BizHawk is broken & stupid, this will only work ONCE per MANUAL CORE REBOOT (ctrl+r)
    -- Even not unregistering the events make them keep working...
    -- Only prevents going further on BizHawk v2.9.1, v2.8 still works
    if WHY_IS_BIZHAWK_THIS_WAY ~= nil then
      print('Not hard reloaded, event.on_bus_exec broken...')
      return
    end
    WHY_IS_BIZHAWK_THIS_WAY = "BUT WHY THO???"

    -- Clean text because why not
    -- Like the only thing that can be done to speed up intro reliably because BizHawk 2.9.1 is broken
    for i = 0x081c589d, 0x081c5f68, 4 do
      Memory.writedword(i, 0xFFFFFF)
    end

		-- Sets Task_OakSpeech1 next task to Task_OakSpeech42
		memory.write_u32_le(0x0812EF04, 0x08130C99)

		self.setupSkipHelpboxEvent()
		self.setupPlayerInfoEvent()
	end

	-- Executed only once: When the extension is disabled by the user, necessary to undo any customizations, if able
	function self.unload()
		-- [ADD CODE HERE]

		-- if not Utils.isNilOrEmpty(self.setInfoEvent) then
		-- print("Unregistering Info Event")
		-- event.unregisterbyname(self.setInfoEventName)
		-- end

		-- if not Utils.isNilOrEmpty(self.skipHelpBoxEvent) then
		-- print("Unregistering Helpbox")
		-- event.unregisterbyname(self.skipHelpBoxEventName)
		-- end
	end

	function self.setPlayerRivalInfo()
    -- print('Supposed to set player info')
		-- To prevent freezing since these values won't be set otherwise
		-- Only run once on new game
		self.applyPlayerInfo(self.DefaultOptions.player)
		self.applyRivalInfo(self.DefaultOptions.rival)
	end

	local function handleHelpBox()
    -- print('Supposed to "break" help box')

		if Memory.readbyte(0x030030f0 + 0x438) == 0 then
			Memory.writebyte(0x030030f0 + 0x438, 1)
		end

		if Memory.readbyte(0x030030f0 + 0x438) == 2 then
			Memory.writebyte(0x030030f0 + 0x438, 10)
		end
	end

	function self.setupPlayerInfoEvent()
		if not Utils.isNilOrEmpty(self.setInfoEvent) then
			return
		end

		self.setInfoEvent = event.onmemoryexecute(self.setPlayerRivalInfo, 0x08130C98, self.setInfoEventName)
	end

	function self.setupSkipHelpboxEvent()
		if not Utils.isNilOrEmpty(self.skipHelpBoxEvent) then
			return
		end

		self.skipHelpBoxEvent = event.onmemoryexecute(handleHelpBox, 0x0812EBD0, self.skipHelpBoxEventName)
	end

	return self
end


return AutoNames
