local PlayerName = GetUnitName("Player")
local _, PlayerClass = UnitClass("Player")

--print("HI")
--if PlayerClass ~= "MONK" and PlayerClass ~= "PALADIN" then
	--return 
--end
--print("HI")
local IRmainframe = CreateFrame("Frame", nil, UIParent)
IRmainframePointer = IRmainframe
IRmainframe.Cooldown = {}
IRmainframe.isInit = false
if PlayerClass == "MONK" then
	IRmainframe.Spells = {115151, 115098}
	IRmainframe.Icons = {115151, 115098}
	--IRmainframe.Spells = {107428, 113656, 115098}
	--IRmainframe.Icons = {107428, 113656, 115098}
elseif PlayerClass == "PALADIN" then
	--IRmainframe.Spells = {20473, 20271, 114165}
	--IRmainframe.Icons = {20473, 20271, 114165}
	IRmainframe.Spells = {35395, 53595, 20271, 879}
	--IRmainframe.Icons = {35395, 53595, 20271, 879}
end

local IconPosition = {}
local i, j
for i = 1, 10 do 
	for j = 1, 4 do 
		table.insert(IconPosition, {i*64, j*64})
	end
end

IRmainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
IRmainframe:RegisterEvent("PLAYER_LOGIN")
IRmainframe:RegisterEvent("ADDON_LOADED")
IRmainframe:SetScript("OnEvent", function(self,e,...) 
	local func = self.HandleFunc[e]
	func(...)
end)

IRmainframe:SetScript("OnUpdate", function(self, elapsed)
	local func = self.HandleFunc["ON_UPDATE"]
	func(elapsed)
end)

IRmainframe.HandleFunc = {

	ADDON_LOADED = function(...)
		local AddonName = ...
		if AddonName ~= "ItIsReady" then return end
		--Initialize Saved Variables if Necessary
		if ItIsReadyData == nil then 
			ItIsReadyData = {
				_debug = false,
				CurrentGroup = nil,
				CurrentGroupName = "",
				Spells = {}
			}
		end
		if ItIsReadyData.Position == nil then
			ItIsReadyData.Position = {X = 0, Y = 0}
		end
		if ItIsReadyData.CurrentGroupName ~= "" then 
			ItIsReadyData.CurrentGroup = ItIsReadyData.Spells[ItIsReadyData.CurrentGroupName]
		end
		--print("Spells:", type(ItIsReadyData["Spells"]))
	end,
	
	PLAYER_LOGIN = function (...)
		if isInit then
			return
		end
		local i, v, c
		IRmainframe.Spells = ItIsReadyData.CurrentGroup
		if IRmainframe.Spells == nil then 
			IRmainframe.Spells = {}
		end
		IRmainframe.Icons = {}
		--table.setn(IRmainframe.Icons, table.getn(IRmainframe.Spells))
		IRmainframe.Position = CreateFrame("Frame", nil, IRmainframe)
		IRmainframe.Position:SetHeight(480)
		IRmainframe.Position:SetWidth(256)
		IRmainframe.Position:SetPoint("CENTER", UIParent, "CENTER", ItIsReadyData.Position.X, ItIsReadyData.Position.Y)
		for i,v in pairs(IRmainframe.Spells) do
			--print(v)
			
			IRmainframe.Icons[i] = CreateFrame("Frame", nil, IRmainframe.Position)
			IRmainframe.Icons[i]:SetWidth(64)
			IRmainframe.Icons[i]:SetHeight(64)
			IRmainframe.Icons[i]:SetBackdrop({ 
				bgFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 背景材质路径 
				insets = {left = 1,right = 1,top = 1,bottom = 1}, -- 背景收缩程度，单位为像素，例如，top = 1即背景材质的上边缘向内收缩1个像素 
				edgeFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 边框材质路径 
				edgeSize = 1, -- 边框宽度 
			})
			IRmainframe.Icons[i]:SetBackdropColor(0, 0, 0, 0)
			IRmainframe.Icons[i]:SetBackdropBorderColor(0, 0, 0, 0)
			IRmainframe.Icons[i]:SetPoint("CENTER", IRmainframe.Position, "CENTER", IconPosition[i][2], IconPosition[i][1])
			local name, _, icon = GetSpellInfo(v)
			
			IRmainframe.Icons[i].texture = IRmainframe.Icons[i]:CreateTexture(nil, "ARTWORK")
			IRmainframe.Icons[i].texture:SetTexture(icon)
			IRmainframe.Icons[i].texture:SetPoint("CENTER", IRmainframe.Icons[i], "CENTER", 0,0)
			
			IRmainframe.Cooldown[i] = 0
		end
		print("ItIsReady has loaded")
	end,
	
	COMBAT_LOG_EVENT_UNFILTERED = function (...)
		local event = select(2, ...)
		local name = select(5, ...)
		local id = select(12, ...)
		local i, v, c
		
		if name == PlayerName and event == "SPELL_CAST_SUCCESS" then
			if ItIsReadyData._debug then 
				print(name, id)
			end
			for i,c in pairs(IRmainframe.Icons) do
				v = IRmainframe.Spells[i]
				if id == v then
					IRmainframe.Cooldown[i] = 1
					if IRmainframe.Icons[i]:IsShown() then
						IRmainframe.Icons[i]:Hide()
					end
 				end
			end
		end
	end,
	
	ON_UPDATE = function(elapsed)
		local i, v, c
		for i,c in pairs(IRmainframe.Icons) do
			v = IRmainframe.Spells[i]
			local _, length = GetSpellCooldown(v)
			if length == 0 and not IRmainframe.Icons[i]:IsShown() then
				IRmainframe.Icons[i]:Show()
				IRmainframe.Cooldown[i] = 0
			elseif--[[ IRmainframe.Cooldown[i] == 1 and ]]length >= 2 then
				IRmainframe.Cooldown[i] = length
				if IRmainframe.Icons[i]:IsShown() then 
					IRmainframe.Icons[i]:Hide()
				end
			elseif length < 2 then
				IRmainframe.Cooldown[i] = length;
				if IRmainframe.Cooldown[i] <= length then 
					IRmainframe.Icons[i]:Show()
					IRmainframe.Cooldown[i] = 0
				end
			end
		end
	end

}

