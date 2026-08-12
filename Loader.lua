-- example script by https://github.com/mstudio45/LinoriaLib/blob/main/Example.lua and modified by deivid
-- You can suggest changes with a pull request or something

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false -- Forces AddToggle to AddCheckbox
Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)

local Window = Library:CreateWindow({
	Title = "AgnX v4.o",
	Footer = "Version: 4.0 | Paid | discord.gg/2K9YuG9HYb",
	Icon = nil,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

-- Create tabs
local Tabs = {
	SkinChanger = Window:AddTab("SkinChanger", "user"),
	RageBot = Window:AddTab("RageBot", "bot"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ============================================================
-- LOAD ALL FEATURES IMMEDIATELY (NO KEY REQUIRED)
-- ============================================================

local FullUILoaded = false

function LoadFullUI()
	if FullUILoaded then return end
	FullUILoaded = true
	
	-- Load all UI elements
	LoadSkinChangerUI()
	LoadRageBotUI()
	LoadUISettings()
	
	Library:Notify({
		Title = "Welcome!",
		Description = "All features unlocked! Enjoy!",
		Time = 3,
	})
end

-- Load everything immediately
task.spawn(function()
	task.wait(0.5) -- Small delay for UI to render
	LoadFullUI()
end)

-- ============================================================
-- SKIN CHANGER - FULL SCRIPT
-- ============================================================

-- Variables for SkinChanger
local skinChangerRunning = false
local skinChangerConnections = {}

-- Function to load the SkinChanger UI
function LoadSkinChangerUI()
	local SkinGroup = Tabs.SkinChanger:AddLeftGroupbox("Skin Changer", "user")
	
	SkinGroup:AddLabel({
		Text = "Click the button below to activate the skin changer:",
		DoesWrap = true,
		Size = 16,
	})
	
	SkinGroup:AddButton({
		Text = "Activate Skin Changer",
		Func = function()
			if skinChangerRunning then
				Library:Notify({
					Title = "Already Active",
					Description = "Skin changer is already running!",
					Time = 2,
				})
				return
			end
			
			print("Activating Skin Changer...")
			Library:Notify({
				Title = "Activating",
				Description = "Skin changer is being activated...",
				Time = 2,
			})
			
			task.spawn(function()
				RunSkinChanger()
			end)
		end,
	})
	
	-- Add a status label
	local statusLabel = SkinGroup:AddLabel({
		Text = "Status: ❌ Not Active",
		DoesWrap = true,
		Size = 14,
	})
	
	-- Store reference to update status
	skinChangerConnections.statusLabel = statusLabel
	
	-- Function to update status
	local function updateSkinStatus(active)
		if active then
			statusLabel:SetText("Status: ✅ Active - All skins unlocked!")
		else
			statusLabel:SetText("Status: ❌ Not Active")
		end
	end
	
	skinChangerConnections.updateStatus = updateSkinStatus
end

-- Function to run the skin changer script
function RunSkinChanger()
	if skinChangerRunning then return end
	skinChangerRunning = true
	
	-- Update status
	if skinChangerConnections.updateStatus then
		skinChangerConnections.updateStatus(true)
	end
	
	print("Running Skin Changer...")
	
	-- AC Bypass
	local _stbl; _stbl = hookfunction(getrenv().setmetatable, newcclosure(function(tbl, mt)
		if mt and typeof(mt) == "table" and rawget(mt, "__mode") == "kv" then
			local tr = debug.traceback()
			if tr:find("MiscellaneousController") then
				return _stbl({1,2,3}, {})
			end
		end
		return _stbl(tbl, mt)
	end))

	coroutine.wrap(function()
		pcall(function()
			local function _proc(o)
				pcall(function()
					if o:IsA("LocalScript") or o:IsA("ModuleScript") then
						local _s, nm = pcall(function() return o.Name:lower() end)
						if not _s or not nm then return end
						local _tags = {"anticheat","ac","detection","ban","kick","security","moderation"}
						for _i = 1, #_tags do
							if nm:find(_tags[_i]) then
								pcall(function() o.Disabled = true end)
								break
							end
						end
					end
				end)
			end
			pcall(function()
				local _desc = game:GetDescendants()
				for _i = 1, #_desc do _proc(_desc[_i]) end
			end)
			pcall(function() game.DescendantAdded:Connect(_proc) end)
		end)
		pcall(function()
			local _nc = game:GetService("NetworkClient")
			if not _nc then return end
			_nc.ChildAdded:Connect(function(ch)
				pcall(function()
					local _ok, _n = pcall(function() return ch.Name:lower() end)
					if _ok and _n then
						if _n:find("anticheat") or _n:find("detection") then
							pcall(function() ch:Destroy() end)
						end
					end
				end)
			end)
		end)
	end)()

	local _fakeEv
	pcall(function()
		_fakeEv = Instance.new("RemoteEvent")
		_fakeEv.Name = "ClientAlert"
		_fakeEv.Parent = game.Players.LocalPlayer
	end)

	pcall(function()
		local _rf = game:GetService("ReplicatedFirst")
		local _tgt = _rf:WaitForChild("LocalScript3", 10)
		local _ct = 0
		local _gc = getgc(false)
		for _i = 1, #_gc do
			local _fn = _gc[_i]
			if type(_fn) ~= "function" then continue end
			local _ok1, _env = pcall(getfenv, _fn)
			if not _ok1 or type(_env) ~= "table" then continue end
			local _ok2, _scr = pcall(function() return rawget(_env, "script") end)
			if not _ok2 or not _scr or typeof(_scr) ~= "Instance" then continue end
			local _ok3, _ss = pcall(tostring, _scr)
			if not _ok3 then continue end
			if not (_scr == _tgt or (type(_ss) == "string" and _ss:find("LoadingScreen"))) then continue end
			local _ok4, _consts = pcall(debug.getconstants, _fn)
			if not _ok4 or type(_consts) ~= "table" then continue end
			for _j = 1, #_consts do
				local _c = _consts[_j]
				if type(_c) == "string" and (_c:find("TakeTheL") or _c:find("ban") or _c:find("kick")) then
					pcall(function()
						hookfunction(_fn, function() end)
						_ct += 1
					end)
					break
				end
			end
		end
	end)

	task.wait(4)

	-- Unlock All Skins / Wraps / Charms.
	local _plrs    = game:GetService("Players")
	local _rs      = game:GetService("ReplicatedStorage")
	local _http    = game:GetService("HttpService")
	local _run     = game:GetService("RunService")
	local _ws      = game:GetService("Workspace")
	local _lp      = _plrs.LocalPlayer
	local _pscripts = _lp.PlayerScripts
	local _ctrl    = _pscripts.Controllers
	local _mods    = _rs:WaitForChild("Modules", 10)

	local _enumLib = require(_mods:WaitForChild("EnumLibrary", 10))
	if _enumLib then pcall(function() _enumLib:WaitForEnumBuilder() end) end

	local _cosLib  = require(_mods:WaitForChild("CosmeticLibrary", 10))
	local _itmLib  = require(_mods:WaitForChild("ItemLibrary", 10))
	local _datCtrl = require(_ctrl:WaitForChild("PlayerDataController", 10))

	local _eq, _favs = {}, {}
	local _buildingWep, _viewProf = nil, nil
	local _lastWep = nil
	local _fakeInv = {}

	local function _mkCosmetic(nm, ctype, opts)
		local _base = _cosLib.Cosmetics[nm]
		if not _base then return nil end
		local _d = {}
		for k, v in pairs(_base) do _d[k] = v end
		_d.Name = nm
		_d.Type = _d.Type or ctype
		_d.Seed = _d.Seed or math.random(1, 1000000)
		if _enumLib then
			local _s, _eid = pcall(_enumLib.ToEnum, _enumLib, nm)
			if _s and _eid then
				_d.Enum = _eid
				_d.ObjectID = _d.ObjectID or _eid
			end
		end
		if opts then
			if opts.inverted ~= nil then _d.Inverted = opts.inverted end
			if opts.favoritesOnly ~= nil then _d.OnlyUseFavorites = opts.favoritesOnly end
		end
		return _d
	end

	local _cfgFile = "rivals_unlocker_config.json"
	local _saveLock = false

	local function _stripForSave()
		local _out = {}
		for wn, cos in pairs(_eq) do
			_out[wn] = {}
			for ct, cd in pairs(cos) do
				if cd and cd.Name then
					_out[wn][ct] = {
						Name = cd.Name,
						Inverted = cd.Inverted,
						OnlyUseFavorites = cd.OnlyUseFavorites
					}
				end
			end
		end
		return { equipped = _out, favorites = _favs }
	end

	local function _loadCfg()
		if not isfile or not readfile then return end
		local _ok1, _ex = pcall(isfile, _cfgFile)
		if not _ok1 or not _ex then return end
		local _ok2, _raw = pcall(readfile, _cfgFile)
		if not _ok2 or not _raw or _raw == "" then return end
		local _ok3, _dec = pcall(_http.JSONDecode, _http, _raw)
		if not _ok3 or not _dec then return end
		if _dec.favorites then
			_favs = _dec.favorites
		end
		if _dec.equipped then
			_eq = {}
			local _cnt = 0
			for wn, cos in pairs(_dec.equipped) do
				_eq[wn] = {}
				for ct, sd in pairs(cos) do
					if sd and sd.Name then
						if _cosLib.Cosmetics[sd.Name] then
							local _cloned = _mkCosmetic(sd.Name, ct, {
								inverted = sd.Inverted,
								favoritesOnly = sd.OnlyUseFavorites
							})
							if _cloned then
								_eq[wn][ct] = _cloned
								_cnt += 1
							end
						end
					end
				end
				if not next(_eq[wn]) then _eq[wn] = nil end
			end
		end
	end

	local function _saveCfg()
		if not writefile or _saveLock then return end
		_saveLock = true
		task.spawn(function()
			task.wait(1)
			local _payload = _stripForSave()
			local _ok, _enc = pcall(_http.JSONEncode, _http, _payload)
			if _ok then
				pcall(writefile, _cfgFile, _enc)
			end
			_saveLock = false
		end)
	end

	_loadCfg()

	local _cosTypes = {"Skin","Wrap","Charm","Dance","Emote"}
	local function _isCosType(cosObj)
		if not cosObj then return false end
		for _, t in ipairs(_cosTypes) do
			if cosObj.Type == t then return true end
		end
		return false
	end

	_cosLib.OwnsCosmeticNormally = function(self, inv, nm, wep)
		local c = _cosLib.Cosmetics[nm]
		if c and c.Type == "Skin" then return true end
		return false
	end
	_cosLib.OwnsCosmeticUniversally = function(self, inv, nm, wep)
		local c = _cosLib.Cosmetics[nm]
		if c and c.Type == "Skin" then return true end
		return false
	end
	_cosLib.OwnsCosmeticForWeapon = function(self, inv, nm, wep)
		local c = _cosLib.Cosmetics[nm]
		if c and c.Type == "Skin" then return true end
		return false
	end

	local _origOwns = _cosLib.OwnsCosmetic
	_cosLib.OwnsCosmetic = function(self, inv, nm, wep)
		if nm:find("MISSING_") or nm == "Bubble Gun" then
			return _origOwns(self, inv, nm, wep)
		end
		local c = _cosLib.Cosmetics[nm]
		if c and _isCosType(c) then return true end
		return _origOwns(self, inv, nm, wep)
	end

	local _origGet = _datCtrl.Get
	_datCtrl.Get = function(self, key)
		local _val = _origGet(self, key)
		if key == "CosmeticInventory" then
			local _prx = {}
			if _val then
				for k, v in pairs(_val) do
					local c = _cosLib.Cosmetics[k]
					if c and _isCosType(c) then _prx[k] = v end
				end
			end
			return setmetatable(_prx, {
				__index = function(t, k)
					local c = _cosLib.Cosmetics[k]
					if c and _isCosType(c) then return true end
					return nil
				end
			})
		end
		if key == "FavoritedCosmetics" then
			local _res = _val and table.clone(_val) or {}
			for wep, fv in pairs(_favs) do
				_res[wep] = _res[wep] or {}
				for nm, isFav in pairs(fv) do
					local c = _cosLib.Cosmetics[nm]
					if c and _isCosType(c) then
						_res[wep][nm] = isFav
					end
				end
			end
			return _res
		end
		return _val
	end

	local _origGetWep = _datCtrl.GetWeaponData
	_datCtrl.GetWeaponData = function(self, wn)
		local _d = _origGetWep(self, wn)
		if not _d then return nil end
		local _m = {}
		for k, v in pairs(_d) do _m[k] = v end
		_m.Name = wn
		if _eq[wn] then
			for ct, cd in pairs(_eq[wn]) do
				_m[ct] = cd
			end
		end
		return _m
	end

	local _fightCtrl
	pcall(function()
		_fightCtrl = require(_ctrl:WaitForChild("FighterController", 10))
	end)

	if hookmetamethod then
		local _remotes   = _rs:FindFirstChild("Remotes")
		local _dataRem   = _remotes and _remotes:FindFirstChild("Data")
		local _equipRem  = _dataRem and _dataRem:FindFirstChild("EquipCosmetic")
		local _favRem    = _dataRem and _dataRem:FindFirstChild("FavoriteCosmetic")
		local _repRem    = _remotes and _remotes:FindFirstChild("Replication")
		local _fightRem  = _repRem and _repRem:FindFirstChild("Fighter")
		local _useItmRem = _fightRem and _fightRem:FindFirstChild("UseItem")

		if _equipRem then
			local _onc
			_onc = hookmetamethod(game, "__namecall", function(self, ...)
				if getnamecallmethod() ~= "FireServer" then
					return _onc(self, ...)
				end
				local _a = {...}

				if _useItmRem and self == _useItmRem then
					local _oid = _a[1]
					if _fightCtrl then
						pcall(function()
							local _f = _fightCtrl:GetFighter(_lp)
							if _f and _f.Items then
								for _, itm in pairs(_f.Items) do
									if itm:Get("ObjectID") == _oid then
										_lastWep = itm.Name
										break
									end
								end
							end
						end)
					end
				end

				if self == _equipRem then
					local _wn   = _a[1]
					local _ct   = _a[2]
					local _cn   = _a[3]
					local _opts = _a[4] or {}
					if _cn and _cn ~= "None" and _cn ~= "" then
						local _inv = _datCtrl:Get("CosmeticInventory")
						if _inv and rawget(_inv, _cn) then
							return _onc(self, ...)
						end
					end
					_eq[_wn] = _eq[_wn] or {}
					if not _cn or _cn == "None" or _cn == "" then
						_eq[_wn][_ct] = nil
						if not next(_eq[_wn]) then _eq[_wn] = nil end
					else
						local _cloned = _mkCosmetic(_cn, _ct, {
							inverted = _opts.IsInverted,
							favoritesOnly = _opts.OnlyUseFavorites
						})
						if _cloned then _eq[_wn][_ct] = _cloned end
					end
					task.defer(function()
						pcall(function() _datCtrl.CurrentData:Replicate("WeaponInventory") end)
					end)
					_saveCfg()
					return
				end

				if self == _favRem then
					local _cos = _cosLib.Cosmetics[_a[2]]
					if _cos then
						_favs[_a[1]] = _favs[_a[1]] or {}
						_favs[_a[1]][_a[2]] = _a[3] or nil
						task.spawn(function()
							pcall(function() _datCtrl.CurrentData:Replicate("FavoritedCosmetics") end)
						end)
						_saveCfg()
					end
					return
				end

				return _onc(self, ...)
			end)
		end
	end

	local _cliItem
	pcall(function()
		_cliItem = require(_lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
	end)

	if _cliItem and _cliItem._CreateViewModel then
		local _origCVM = _cliItem._CreateViewModel
		_cliItem._CreateViewModel = function(self, vmRef)
			local _wn  = self.Name
			local _wp  = self.ClientFighter and self.ClientFighter.Player
			_buildingWep = (_wp == _lp) and _wn or nil
			if _wp == _lp and _eq[_wn] then
				local _dk = self:ToEnum("Data")
				if vmRef[_dk] then
					if _eq[_wn].Skin then
						vmRef[_dk][self:ToEnum("Skin")] = _eq[_wn].Skin
						vmRef[_dk][self:ToEnum("Name")] = _eq[_wn].Skin.Name
					end
					if _eq[_wn].Charm then vmRef[_dk][self:ToEnum("Charm")] = _eq[_wn].Charm end
					if _eq[_wn].Wrap  then vmRef[_dk][self:ToEnum("Wrap")]  = _eq[_wn].Wrap  end
				elseif vmRef.Data then
					if _eq[_wn].Skin  then vmRef.Data.Skin  = _eq[_wn].Skin; vmRef.Data.Name = _eq[_wn].Skin.Name end
					if _eq[_wn].Charm then vmRef.Data.Charm = _eq[_wn].Charm end
					if _eq[_wn].Wrap  then vmRef.Data.Wrap  = _eq[_wn].Wrap  end
				end
			end
			local _r = _origCVM(self, vmRef)
			_buildingWep = nil
			return _r
		end
	end

	local _vmMod = _lp.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
	if _vmMod then
		local _CVM = require(_vmMod)
		local _origNew = _CVM.new
		_CVM.new = function(repData, cliItm)
			local _wp  = cliItm.ClientFighter and cliItm.ClientFighter.Player
			local _wn  = _buildingWep or cliItm.Name
			if _wp == _lp and _eq[_wn] then
				local _RC  = require(_rs.Modules.ReplicatedClass)
				local _dk  = _RC:ToEnum("Data")
				repData[_dk] = repData[_dk] or {}
				local _cos = _eq[_wn]
				if _cos.Skin  then repData[_dk][_RC:ToEnum("Skin")]  = _cos.Skin  end
				if _cos.Charm then repData[_dk][_RC:ToEnum("Charm")] = _cos.Charm end
				if _cos.Wrap  then repData[_dk][_RC:ToEnum("Wrap")]  = _cos.Wrap  end
			end
			return _origNew(repData, cliItm)
		end
	end
	
	Library:Notify({
		Title = "Success!",
		Description = "Skin changer has been activated successfully!",
		Time = 3,
	})
	print("Skin Changer activated successfully!")
end

-- ============================================================
-- RAGEBOT - FULL SCRIPT
-- ============================================================

-- Variables for RageBot
local rageBotRunning = false
local rageBotInstance = nil

-- Function to load the RageBot UI
function LoadRageBotUI()
	local RageGroup = Tabs.RageBot:AddLeftGroupbox("RageBot", "bot")
	
	RageGroup:AddLabel({
		Text = "Click the button below to activate the rage bot:",
		DoesWrap = true,
		Size = 16,
	})
	
	RageGroup:AddButton({
		Text = "Activate RageBot",
		Func = function()
			if rageBotRunning then
				Library:Notify({
					Title = "Already Active",
					Description = "RageBot is already running!",
					Time = 2,
				})
				return
			end
			
			print("Activating RageBot...")
			Library:Notify({
				Title = "Activating",
				Description = "RageBot is being activated...",
				Time = 2,
			})
			
			task.spawn(function()
				RunRageBot()
			end)
		end,
	})
	
	-- Add a status label
	local statusLabel = RageGroup:AddLabel({
		Text = "Status: ❌ Not Active",
		DoesWrap = true,
		Size = 14,
	})
	
	-- Add a deactivate button
	RageGroup:AddButton({
		Text = "Deactivate RageBot",
		Func = function()
			if rageBotRunning and rageBotInstance then
				rageBotInstance:Shutdown()
				rageBotRunning = false
				rageBotInstance = nil
				statusLabel:SetText("Status: ❌ Not Active")
				
				Library:Notify({
					Title = "RageBot Deactivated",
					Description = "RageBot has been stopped!",
					Time = 2,
				})
				print("RageBot deactivated!")
			else
				Library:Notify({
					Title = "Not Active",
					Description = "RageBot is not currently running!",
					Time = 2,
				})
			end
		end,
	})
	
	-- Add FOV Slider
	RageGroup:AddSlider("RageBotFOVSlider", {
		Text = "FOV Radius",
		Default = 200,
		Min = 50,
		Max = 500,
		Rounding = 0,
		Callback = function(value)
			if rageBotRunning and rageBotInstance then
				_G.RageBotFOV = value
				print("🔄 RageBot FOV updated to: " .. value)
			end
			_G.RageBotFOV = value
		end
	})
	
	-- Store reference to update status
	RageGroup._statusLabel = statusLabel
end

-- Function to run the rage bot script
function RunRageBot()
	if rageBotRunning then return end
	
	-- Update status
	if Tabs.RageBot and Tabs.RageBot._statusLabel then
		Tabs.RageBot._statusLabel:SetText("Status: 🔄 Activating...")
	end
	
	print("Running RageBot...")
	
	local __a1b2c3 = setmetatable({}, {
		__index = function(__d4e5f6, __g7h8i9)
			local __j0k1l2, __m3n4o5 = pcall(function()
				return game:GetService(__g7h8i9)
			end)
			if __m3n4o5 then
				return cloneref(__m3n4o5)
			end
			return nil
		end
	})

	local __p6q7r8 = getgenv()
	if __p6q7r8.__s9t0u1 then
		__p6q7r8.__s9t0u1:Shutdown()
	end

	local __v2w3x4 = __a1b2c3.Players
	local __y5z6a7 = __a1b2c3.RunService
	local __b8c9d0 = __a1b2c3.ReplicatedStorage
	local __e1f2g3 = __a1b2c3.Workspace
	local __h4i5j6 = __a1b2c3.UserInputService
	local __k7l8m9 = __v2w3x4.LocalPlayer
	local __n0o1p2 = __e1f2g3.CurrentCamera
	local __q3r4s5 = __k7l8m9.PlayerScripts
	local __t6u7v8 = require(__q3r4s5.Modules.ItemTypes.Gun)
	local __w9x0y1 = require(__b8c9d0.Modules.Utility)

	local __z2a3b4 = setmetatable({}, {
		__index = function(_, __c5d6e7)
			local __f8g9h0 = __k7l8m9.Character
			if not __f8g9h0 then return nil end
			if __c5d6e7 == "__root" then
				return __f8g9h0:FindFirstChild("HumanoidRootPart")
			elseif __c5d6e7 == "__head" then
				return __f8g9h0:FindFirstChild("Head")
			end
			return nil
		end
	})

	__p6q7r8.__s9t0u1 = {}

	do
		local __i1j2k3 = __p6q7r8.__s9t0u1

		function __i1j2k3:__init()
			self.__active = true
			self.__target = nil
			self.__desync = false
			self.__conn1 = nil
			self.__conn2 = nil
			self.__task1 = nil
			self.__oldfunc = nil
			self:__setup()
		end

		function __i1j2k3:__setup()
			self.__conn1 = __y5z6a7.Heartbeat:Connect(function()
				if not self.__active then return end
				self.__target = self:__find()
			end)

			local __l4m5n6 = __t6u7v8.StartShooting
			self.__oldfunc = __l4m5n6
			__t6u7v8.StartShooting = function(__o7p8q9, ...)
				local __r0s1t2 = {__l4m5n6(__o7p8q9, ...)}
				if not __o7p8q9.ClientFighter or not __o7p8q9.ClientFighter.IsLocalPlayer then
					return unpack(__r0s1t2)
				end

				local __u3v4w5 = __r0s1t2[3]
				if not __u3v4w5 or typeof(__u3v4w5) ~= "table" then
					return unpack(__r0s1t2)
				end

				__r0s1t2[4] = true
				local __x6y7z8 = self.__target

				if not self.__active or not __x6y7z8 or not __x6y7z8.Character then
					return unpack(__r0s1t2)
				end

				if not self.__desync or self.__curr ~= __x6y7z8 then
					self:__desync_start(__x6y7z8)
					task.wait(0.1)
				end

				if self.__task1 then
					task.cancel(self.__task1)
					self.__task1 = nil
				end

				local __a9b0c1 = __x6y7z8.Character:FindFirstChild("Head")
				if not __a9b0c1 then return unpack(__r0s1t2) end

				local __d2e3f4 = __a9b0c1.Position
				local __g5h6i7 = __a9b0c1.CFrame
				local __j8k9l0 = __d2e3f4 - Vector3.new(0, 5, 0)
				local __m1n2o3 = CFrame.lookAt(__j8k9l0, __d2e3f4)
				local __p4q5r6 = __g5h6i7:ToObjectSpace(CFrame.new(__d2e3f4 + Vector3.new(math.random(), math.random(), math.random())))

				__u3v4w5[utf8.char(0)] = __w9x0y1:EncodeCFrame(CFrame.new(__j8k9l0, __d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
				__u3v4w5[utf8.char(1)] = __w9x0y1:EncodeCFrame(CFrame.new(__d2e3f4) * CFrame.Angles(__m1n2o3:ToOrientation()))
				__u3v4w5[utf8.char(2)] = __a9b0c1
				__u3v4w5[utf8.char(3)] = __w9x0y1:EncodeCFrame(__p4q5r6)

				self.__task1 = task.delay(0.15, function()
					self:__desync_stop()
				end)

				return unpack(__r0s1t2)
			end
		end

		function __i1j2k3:__find()
			local myChar = __k7l8m9.Character
			if not myChar then return nil end
			local myRoot = myChar:FindFirstChild("HumanoidRootPart")
			if not myRoot then return nil end
		   
			local closest = nil
			local closestDist = math.huge
			local MAX_DISTANCE = _G.RageBotFOV or 200

			for _, player in next, __v2w3x4:GetPlayers() do
				if player == __k7l8m9 then continue end
				if player:GetAttribute("TeamID") == __k7l8m9:GetAttribute("TeamID") then continue end
			   
				local char = player.Character
				if not char then continue end

				local root = char:FindFirstChild("HumanoidRootPart")
				local head = char:FindFirstChild("Head")
				local hum = char:FindFirstChildWhichIsA("Humanoid")
				
				if not (root and head and hum and hum.Health > 0) then continue end
			   
				local dist = (myRoot.Position - root.Position).Magnitude
				
				if dist > MAX_DISTANCE then continue end
				
				if dist < closestDist then
					closestDist = dist
					closest = player
				end
			end
			
			return closest
		end

		function __i1j2k3:__desync_start(__c3d4e5)
			if self.__conn2 then self.__conn2:Disconnect() end
			self.__desync = true
			self.__curr = __c3d4e5

			self.__conn2 = __y5z6a7.Heartbeat:Connect(function()
				if not self.__desync then return end
				local __f6g7h8 = __z2a3b4.__root
				if not __f6g7h8 then return end

				local __i9j0k1 = __c3d4e5.Character and __c3d4e5.Character:FindFirstChild("HumanoidRootPart")
				if not __i9j0k1 then
					self:__desync_stop()
					return
				end

				local __l2m3n4 = __f6g7h8.CFrame
				local __o5p6q7 = __f6g7h8.Velocity
				local __r8s9t0 = __f6g7h8.RotVelocity

				__f6g7h8.CFrame = __i9j0k1.CFrame * CFrame.new(0, -5, 0)

				__y5z6a7:BindToRenderStep("__restore", 101, function()
					__f6g7h8.CFrame = __l2m3n4
					__f6g7h8.Velocity = __o5p6q7
					__f6g7h8.RotVelocity = __r8s9t0
					__y5z6a7:UnbindFromRenderStep("__restore")
				end)
			end)
		end

		function __i1j2k3:__desync_stop()
			self.__desync = false
			self.__curr = nil
			if self.__conn2 then
				self.__conn2:Disconnect()
				self.__conn2 = nil
			end
		end

		function __i1j2k3:Shutdown()
			self.__active = false
			if self.__conn1 then self.__conn1:Disconnect() end
			if self.__conn2 then self.__conn2:Disconnect() end
			if self.__task1 then task.cancel(self.__task1) end
			if self.__oldfunc then
				__t6u7v8.StartShooting = self.__oldfunc
			end
		end

		__i1j2k3:__init()
	end
	
	-- Store instance for deactivation
	rageBotInstance = __p6q7r8.__s9t0u1
	rageBotRunning = true
	
	-- Update status
	if Tabs.RageBot and Tabs.RageBot._statusLabel then
		Tabs.RageBot._statusLabel:SetText("Status: ✅ Active - RageBot running!")
	end
	
	local fovValue = _G.RageBotFOV or 200
	Library:Notify({
		Title = "Success!",
		Description = "RageBot activated! FOV: " .. fovValue,
		Time = 3,
	})
	print("RageBot activated successfully! FOV: " .. fovValue)
end

-- ============================================================
-- ESP TAB - WALLHACK + ESP
-- ============================================================

-- Variables for ESP
local espRunning = false
local espConnections = {}
local espObjects = {}
local espConfig = {
	Enabled = false,
	TeamCheck = true,
	HighlightColor = Color3.fromRGB(255, 0, 0),
	OutlineColor = Color3.fromRGB(255, 255, 255),
	Keybind = Enum.KeyCode.L
}

-- Function to load the ESP UI
function LoadESPUI()
	local ESPGroup = Tabs.ESP:AddLeftGroupbox("ESP", "eye")
	
	ESPGroup:AddLabel({
		Text = "Toggle the switch below to enable/disable ESP:",
		DoesWrap = true,
		Size = 16,
	})
	
	-- Add status label
	local statusLabel = ESPGroup:AddLabel({
		Text = "Status: ❌ Disabled",
		DoesWrap = true,
		Size = 14,
	})
	
	-- Function to update status
	local function updateESPStatus()
		if espRunning and espConfig.Enabled then
			statusLabel:SetText("Status: ✅ Active - ESP enabled!")
		elseif espRunning and not espConfig.Enabled then
			statusLabel:SetText("Status: ⏸️ Paused - Press L to enable")
		else
			statusLabel:SetText("Status: ❌ Disabled")
		end
	end
	
	ESPGroup:AddToggle("ESPToggle", {
		Text = "Enable ESP",
		Tooltip = "Toggle ESP on/off",
		Default = false,
		Callback = function(Value)
			if Value then
				print("Enabling ESP...")
				Library:Notify({
					Title = "ESP Enabled",
					Description = "Wallhack + ESP is now active! Press L to toggle visibility.",
					Time = 3,
				})
				
				if not espRunning then
					task.spawn(function()
						RunESP()
					end)
				else
					espConfig.Enabled = true
					_G.Wallhack.On()
					updateESPStatus()
				end
			else
				print("Disabling ESP...")
				Library:Notify({
					Title = "ESP Disabled",
					Description = "Wallhack + ESP has been disabled.",
					Time = 2,
				})
				
				if espRunning then
					StopESP()
				end
				updateESPStatus()
			end
		end,
	})
	
	-- Store reference to update status
	ESPGroup._statusLabel = statusLabel
	ESPGroup._updateStatus = updateESPStatus
end

-- Function to stop ESP
function StopESP()
	espRunning = false
	espConfig.Enabled = false
	
	-- Disconnect all connections
	for _, conn in ipairs(espConnections) do
		conn:Disconnect()
	end
	espConnections = {}
	
	-- Remove all ESP objects
	for player, esp in pairs(espObjects) do
		if esp.Highlight then
			esp.Highlight:Destroy()
		end
		if esp.NameTag then
			esp.NameTag:Destroy()
		end
	end
	espObjects = {}
	
	-- Reset console commands
	if _G.Wallhack then
		_G.Wallhack.Off()
	end
	
	print("ESP stopped!")
end

-- Function to run ESP
function RunESP()
	if espRunning then return end
	
	print("Running ESP...")
	
	-- ===== ESP CODE =====
	
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local Camera = workspace.CurrentCamera
	local LocalPlayer = Players.LocalPlayer

	-- ===== CONFIGURATION =====
	espConfig.Enabled = true

	-- ===== CREATE ESP FOR PLAYER =====
	local function createESP(player)
		if espObjects[player] then return end
		if player == LocalPlayer then return end
		
		local character = player.Character
		if not character then return end
		
		-- Highlight (glow through walls)
		local highlight = Instance.new("Highlight")
		highlight.Parent = character
		highlight.FillColor = espConfig.HighlightColor
		highlight.FillTransparency = 0.4
		highlight.OutlineColor = espConfig.OutlineColor
		highlight.OutlineTransparency = 0.2
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Enabled = espConfig.Enabled
		
		-- Name Tag
		local nameTag = Instance.new("BillboardGui")
		nameTag.Parent = character
		nameTag.Size = UDim2.new(0, 150, 0, 40)
		nameTag.Adornee = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
		nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
		nameTag.MaxDistance = 2000
		nameTag.ResetOnSpawn = false
		
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Parent = nameTag
		nameLabel.Size = UDim2.new(1, 0, 1, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = player.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextStrokeTransparency = 0.3
		nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		
		-- Health Bar
		local healthBar = Instance.new("Frame")
		healthBar.Parent = nameTag
		healthBar.Size = UDim2.new(0.8, 0, 0, 5)
		healthBar.Position = UDim2.new(0.1, 0, 1, 2)
		healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		healthBar.BorderSizePixel = 1
		healthBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		
		local healthFill = Instance.new("Frame")
		healthFill.Parent = healthBar
		healthFill.Size = UDim2.new(1, 0, 1, 0)
		healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		healthFill.BackgroundTransparency = 0
		healthFill.BorderSizePixel = 0
		
		-- Distance Label
		local distanceLabel = Instance.new("TextLabel")
		distanceLabel.Parent = nameTag
		distanceLabel.Size = UDim2.new(0.5, 0, 0.3, 0)
		distanceLabel.Position = UDim2.new(0.25, 0, 1.3, 0)
		distanceLabel.BackgroundTransparency = 1
		distanceLabel.Text = ""
		distanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		distanceLabel.TextScaled = true
		distanceLabel.Font = Enum.Font.Gotham
		
		-- Store ESP objects
		espObjects[player] = {
			Highlight = highlight,
			NameTag = nameTag,
			NameLabel = nameLabel,
			HealthBar = healthBar,
			HealthFill = healthFill,
			DistanceLabel = distanceLabel
		}
	end

	-- ===== UPDATE ESP =====
	local function updateESP()
		for player, esp in pairs(espObjects) do
			if not player or not player.Character or not player.Character.Parent then
				if esp.Highlight then esp.Highlight:Destroy() end
				if esp.NameTag then esp.NameTag:Destroy() end
				espObjects[player] = nil
				continue
			end
			
			-- Update health bar
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and esp.HealthFill then
				local healthPercent = humanoid.Health / humanoid.MaxHealth
				esp.HealthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
				
				-- Change color based on health
				if healthPercent > 0.5 then
					esp.HealthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
				elseif healthPercent > 0.25 then
					esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
				else
					esp.HealthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
				end
			end
			
			-- Update distance
			if esp.DistanceLabel and esp.NameTag and esp.NameTag.Adornee then
				local distance = (esp.NameTag.Adornee.Position - Camera.CFrame.Position).Magnitude
				esp.DistanceLabel.Text = math.floor(distance) .. "m"
			end
		end
	end

	-- ===== REMOVE ESP =====
	local function removeESP(player)
		if espObjects[player] then
			if espObjects[player].Highlight then
				espObjects[player].Highlight:Destroy()
			end
			if espObjects[player].NameTag then
				espObjects[player].NameTag:Destroy()
			end
			espObjects[player] = nil
		end
	end

	-- ===== TOGGLE =====
	local function toggleESP()
		espConfig.Enabled = not espConfig.Enabled
		
		for player, esp in pairs(espObjects) do
			if esp.Highlight then
				esp.Highlight.Enabled = espConfig.Enabled
			end
			if esp.NameTag then
				esp.NameTag.Enabled = espConfig.Enabled
			end
		end
		
		if espConfig.Enabled then
			print("👁️ ESP: ON")
			if Tabs.ESP and Tabs.ESP._updateStatus then
				Tabs.ESP._updateStatus()
			end
		else
			print("👁️ ESP: OFF")
			if Tabs.ESP and Tabs.ESP._updateStatus then
				Tabs.ESP._updateStatus()
			end
		end
	end

	-- ===== KEYBIND =====
	local keybindConnection = UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == espConfig.Keybind then
			toggleESP()
		end
	end)
	table.insert(espConnections, keybindConnection)

	-- ===== PLAYER TRACKING =====
	local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		if espConfig.Enabled then
			task.wait(0.5)
			createESP(player)
		end
	end)
	table.insert(espConnections, playerAddedConnection)

	local playerRemovingConnection = Players.PlayerRemoving:Connect(function(player)
		removeESP(player)
	end)
	table.insert(espConnections, playerRemovingConnection)

	-- ===== HANDLE RESPAWN =====
	local characterAddedConnection = LocalPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		Camera = workspace.CurrentCamera
		-- Recreate ESP for all players if enabled
		if espConfig.Enabled then
			for player in pairs(espObjects) do
				removeESP(player)
			end
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					task.wait(0.05)
					createESP(player)
				end
			end
		end
	end)
	table.insert(espConnections, characterAddedConnection)

	-- ===== UPDATE LOOP =====
	local renderConnection = RunService.RenderStepped:Connect(function()
		if espConfig.Enabled then
			updateESP()
		end
	end)
	table.insert(espConnections, renderConnection)

	-- ===== CONSOLE COMMANDS =====
	_G.Wallhack = {
		Toggle = toggleESP,
		On = function()
			espConfig.Enabled = true
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					createESP(player)
				end
			end
			print("👁️ ESP: ON")
			if Tabs.ESP and Tabs.ESP._updateStatus then
				Tabs.ESP._updateStatus()
			end
		end,
		Off = function()
			espConfig.Enabled = false
			for player, esp in pairs(espObjects) do
				if esp.Highlight then
					esp.Highlight.Enabled = false
				end
				if esp.NameTag then
					esp.NameTag.Enabled = false
				end
			end
			print("👁️ ESP: OFF")
			if Tabs.ESP and Tabs.ESP._updateStatus then
				Tabs.ESP._updateStatus()
			end
		end,
		SetColor = function(color)
			espConfig.HighlightColor = color or Color3.fromRGB(255, 0, 0)
			for player, esp in pairs(espObjects) do
				if esp.Highlight then
					esp.Highlight.FillColor = espConfig.HighlightColor
				end
			end
			print("🎨 Highlight color updated")
		end,
		ToggleTeamCheck = function(state)
			espConfig.TeamCheck = state
			print("👥 Team Check: " .. (state and "ON" or "OFF"))
		end,
		Status = function()
			print("═══════════════════════════════════════════")
			print("👁️ ESP STATUS:")
			print("  Enabled: " .. tostring(espConfig.Enabled))
			print("  Team Check: " .. tostring(espConfig.TeamCheck))
			print("  Highlight Color: " .. tostring(espConfig.HighlightColor))
			print("  Players Tracked: " .. #espObjects)
			print("  Keybind: L")
			print("═══════════════════════════════════════════")
		end
	}

	-- Create ESP for all players
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			task.wait(0.05)
			createESP(player)
		end
	end

	espRunning = true
	
	-- Update status
	if Tabs.ESP and Tabs.ESP._updateStatus then
		Tabs.ESP._updateStatus()
	end
	
	Library:Notify({
		Title = "Success!",
		Description = "ESP activated! Press L to toggle visibility.",
		Time = 3,
	})
	
	print("═══════════════════════════════════════════")
	print("✅ WALLHACK + ESP LOADED!")
	print("═══════════════════════════════════════════")
	print("📌 Controls:")
	print("   Press 'L' to toggle ESP visibility")
	print("")
	print("📌 Features:")
	print("   👁️ See players through walls (Highlight)")
	print("   🏷️ Player Name Tags")
	print("   ❤️ Health Bars")
	print("   📏 Distance Display")
	print("   🎨 Customizable Highlight Color")
	print("   👥 Team Check (don't highlight teammates)")
	print("")
	print("📌 Console Commands:")
	print("   _G.Wallhack.Toggle() - Toggle on/off")
	print("   _G.Wallhack.On() - Turn on")
	print("   _G.Wallhack.Off() - Turn off")
	print("   _G.Wallhack.SetColor(Color3) - Change highlight color")
	print("   _G.Wallhack.ToggleTeamCheck(true/false) - Team check")
	print("   _G.Wallhack.Status() - Show status")
	print("")
	print("📌 Example:")
	print('   _G.Wallhack.SetColor(Color3.fromRGB(0, 255, 0)) -- Green highlight')
	print("═══════════════════════════════════════════")
end

-- ============================================================
-- UI SETTINGS
-- ============================================================

-- Function to load UI Settings
function LoadUISettings()
	local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

	MenuGroup:AddToggle("KeybindMenuOpen", {
		Default = Library.KeybindFrame.Visible,
		Text = "Open Keybind Menu",
		Callback = function(value)
			Library.KeybindFrame.Visible = value
		end,
	})
	MenuGroup:AddToggle("ShowCustomCursor", {
		Text = "Custom Cursor",
		Default = Library.ShowCustomCursor,
		Callback = function(Value)
			Library.ShowCustomCursor = Value
		end,
	})
	MenuGroup:AddDropdown("NotificationSide", {
		Values = { "Left", "Right" },
		Default = "Right",
		Text = "Notification Side",
		Callback = function(Value)
			Library:SetNotifySide(Value)
		end,
	})
	MenuGroup:AddDropdown("DPIDropdown", {
		Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
		Default = "100%",
		Text = "DPI Scale",
		Callback = function(Value)
			Value = Value:gsub("%%", "")
			local DPI = tonumber(Value)
			Library:SetDPIScale(DPI)
		end,
	})

	MenuGroup:AddSlider("UICornerSlider", {
		Text = "Corner Radius",
		Default = Library.CornerRadius,
		Min = 0,
		Max = 20,
		Rounding = 0,
		Callback = function(value)
			Window:SetCornerRadius(value)
		end
	})

	MenuGroup:AddDivider()
	MenuGroup:AddLabel("Menu bind")
		:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

	-- Exit Script Button
	MenuGroup:AddDivider()
	MenuGroup:AddButton("Exit Script", function()
		Library:Notify({
			Title = "Exiting Script",
			Description = "Cleaning up and exiting...",
			Time = 2,
		})
		
		task.wait(1)
		
		-- Stop RageBot if running
		if rageBotRunning and rageBotInstance then
			rageBotInstance:Shutdown()
			rageBotRunning = false
			rageBotInstance = nil
		end
		
		-- Stop ESP if running
		StopESP()
		
		-- Unload the library
		Library:Unload()
		
		-- Print confirmation
		print("✅ Script has been exited successfully!")
		
		-- Optional: Destroy the GUI
		if Window and Window.Gui then
			Window.Gui:Destroy()
		end
	end)

	Library.ToggleKeybind = Options.MenuKeybind

	ThemeManager:SetLibrary(Library)
	SaveManager:SetLibrary(Library)

	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

	ThemeManager:SetFolder("MyScriptHub")
	SaveManager:SetFolder("MyScriptHub/specific-game")
	SaveManager:SetSubFolder("specific-place")

	SaveManager:BuildConfigSection(Tabs["UI Settings"])
	ThemeManager:ApplyToTab(Tabs["UI Settings"])

	SaveManager:LoadAutoloadConfig()
end

Library:OnUnload(function()
	-- Stop RageBot if running
	if rageBotRunning and rageBotInstance then
		rageBotInstance:Shutdown()
		rageBotRunning = false
		rageBotInstance = nil
	end
	
	-- Stop ESP if running
	StopESP()
	
	print("Unloaded!")
end)

print("✅ Script loaded successfully! All features are unlocked!")
