local PlayerName = GetUnitName("Player")
local _, PlayerClass = UnitClass("Player")
--print("HI")
--if PlayerClass ~= "MONK" and PlayerClass ~= "PALADIN" then
	--return 
--end
--print("HI")
local BWmainframe = CreateFrame("Frame", nil, UIParent)
BWmainframePointer =  BWmainframe
--BWmainframe.Cooldown = {}
BWmainframe.isInit = false
if PlayerClass == "MONK" then
	BWmainframe.Spells = {127722, 118674, 125359, 139597, 129914}
	BWmainframe.Icons = {127722, 118674, 125359, 139597, 129914}
elseif PlayerClass == "PALADIN" then 
	--BWmainframe.Spells = {114250}
	--BWmainframe.Icons = {114250}
	BWmainframe.Spells = {84963, 20925}
	--BWmainframe.Icons = {84963, 20925}
end

BWmainframe.StringNum = {" "," "}

for i = 2 ,100, 1 do
	BWmainframe.StringNum[i] = string.format("%d", i)
end
--BWmainframe:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
BWmainframe:RegisterEvent("PLAYER_LOGIN")
BWmainframe:RegisterEvent("ADDON_LOADED")
BWmainframe:SetScript("OnEvent", function(self,e,...) 
	local func = self.HandleFunc[e]
	func(self, ...)
end)


BWmainframe.HandleFunc = {

	ADDON_LOADED = function(self, ...)
		local AddonName = ...
		--print(AddonName)
		if AddonName ~= "BuffWatcher" then return end
		print(2)
		--Initialize Saved Variables if Necessary
		if BuffWatcherData == nil then 
			BuffWatcherData = {
				_debug = false,
				CurrentGroup = nil,
				CurrentGroupName = "",
				Spells = {}
			}
		end
		if BuffWatcherData.CurrentGroupName ~= "" then 
			BuffWatcherData.CurrentGroup = BuffWatcherData.Spells[BuffWatcherData.CurrentGroupName]
		end
		print("Spells:", type(BuffWatcherData["Spells"]))
	end,
	
	PLAYER_LOGIN = function (self, ...)
		if isInit then
			return
		end
		BWmainframe.Spells = BuffWatcherData.CurrentGroup
		if BWmainframe.Spells == nil then 
			BWmainframe.Spells = {}
		end
		BWmainframe.Icons = {}
		
		for i,v in pairs(BWmainframe.Spells) do
			--print(v)
			
			BWmainframe.Icons[i] = CreateFrame("Frame", nil, BWmainframe)
			BWmainframe.Icons[i]:SetWidth(48)
			BWmainframe.Icons[i]:SetHeight(48)
			BWmainframe.Icons[i]:SetBackdrop({ 
				bgFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 背景材质路径 
				insets = {left = 1,right = 1,top = 1,bottom = 1}, -- 背景收缩程度，单位为像素，例如，top = 1即背景材质的上边缘向内收缩1个像素 
				edgeFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 边框材质路径 
				edgeSize = 1, -- 边框宽度 
			})
			BWmainframe.Icons[i]:SetBackdropColor(0, 0, 0, 0)
			BWmainframe.Icons[i]:SetBackdropBorderColor(0, 0, 0, 0)
			BWmainframe.Icons[i]:SetPoint("CENTER", UIParent, "CENTER", 48*i - 144, -96)
			local name, _, icon = GetSpellInfo(v)
			
			--print(icon)
			BWmainframe.Icons[i].texture = BWmainframe.Icons[i]:CreateTexture(nil, "ARTWORK")
			BWmainframe.Icons[i].texture:SetTexture(icon)
			BWmainframe.Icons[i].texture:SetPoint("CENTER", BWmainframe.Icons[i], "CENTER", 0,0)
			BWmainframe.Icons[i].texture:SetWidth(48)
			BWmainframe.Icons[i].texture:SetHeight(48)
			
			BWmainframe.Icons[i].SpellId = v
			BWmainframe.Icons[i].SpellName = name
			BWmainframe.Icons[i].Dose = 1
			local a, _, _, _, _, duration, expires = UnitAura("Player", name)
			local duration, expires
			if a == nil then
				BWmainframe.Icons[i]:Hide()
				BWmainframe.Icons[i].Dose = 0
			else
				_, _, _, BWmainframe.Icons[i].Dose = UnitAura("Player", name)
			end
			
			BWmainframe.Icons[i].Text = BWmainframe.Icons[i]:CreateFontString(nil, "OVERLAY") -- 为Frame创建一个新的文字层 
			BWmainframe.Icons[i].Text:SetFont(GameTooltipText:GetFont(), 15, "THINOUTLINE") -- 设置字体路径, 大小, 描边 
			BWmainframe.Icons[i].Text:SetText(BWmainframe.Icons[i].Dose) 
			BWmainframe.Icons[i].Text:SetPoint("CENTER", BWmainframe.Icons[i], "BOTTOM", 15, 10)
			
			if BWmainframe.Icons[i].Dose < 2 then
				BWmainframe.Icons[i].Text:Hide()
			end
			
			BWmainframe.Icons[i]:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			BWmainframe.Icons[i]:SetScript("OnEvent", function(self, e, ...)
				local func = BWmainframe.HandleFunc[e]
				func(self, ...)
			end)
			
			BWmainframe.Icons[i].CDFrame = CreateFrame("Frame", nil, BWmainframe.Icons[i])
			BWmainframe.Icons[i].CDFrame:SetWidth(48)
			local height
			if duration == nil then duration = 0 end
			if expires == nil then expires = GetTime() end
			if duration == 0 then 
				height = 0
				BWmainframe.Icons[i].CDFrame.deltaH = 0
			else
				height = 48 - 48.0 * (expires - GetTime()) / duration
				BWmainframe.Icons[i].CDFrame.deltaH = 48.0 / duration
			end
			BWmainframe.Icons[i].CDFrame:SetHeight(height)
			BWmainframe.Icons[i].CDFrame:SetBackdrop({ 
				bgFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 背景材质路径 
				insets = {left = 1,right = 1,top = 1,bottom = 1}, -- 背景收缩程度，单位为像素，例如，top = 1即背景材质的上边缘向内收缩1个像素 
				edgeFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 边框材质路径 
				edgeSize = 1, -- 边框宽度 
			})
			BWmainframe.Icons[i].CDFrame:SetBackdropColor(0, 0, 0, 0.6)
			BWmainframe.Icons[i].CDFrame:SetBackdropBorderColor(0, 0, 0, 0.6)
			BWmainframe.Icons[i].CDFrame:SetPoint("BOTTOM", BWmainframe.Icons[i], "BOTTOM", 0, 0)
			
			BWmainframe.Icons[i].CDFrame:SetScript("OnUpdate", function(self, elapsed)
				local func = BWmainframe.HandleFunc["ON_UPDATE"]
				func(self, elapsed)
			end)
			--print(BWmainframe.Icons[i].CDFrame:IsShown())
			BWmainframe.Icons[i].CDFrame.RefreshRate = 0
			--BWmainframe.Cooldown[i] = 0
		end
		print("BuffWatcher has loaded")
	end,
	
	COMBAT_LOG_EVENT_UNFILTERED = function (self, ...)
		local event = select(2, ...)
		local name = select(9, ...)
		local id = select(12, ...)
		local dose = select(16, ...)
		if BuffWatcherData._debug and name == PlayerName then
			print(event, name, id)
		end 
		if id == self.SpellId and name == PlayerName then
			if event == "SPELL_AURA_APPLIED" then
				if not self:IsShown() then 
					self:Show()
				end
				self.Dose = 1
				self.Text:SetText(dose)
				
				local _, _, _, _, _, duration = UnitAura("Player", self.SpellName)
				--print(UnitAura("Player", self.SpellName))
				--print(duration)
				self.CDFrame:SetHeight(0)
				if duration == 0 then 
					self.CDFrame.deltaH = 0
				else
					self.CDFrame.deltaH = 48.0 / duration
				end
				
			elseif event == "SPELL_AURA_REMOVED" then
				if self:IsShown() then
					self:Hide()
				end
				self.Dose = 0
				self.Text:SetText(dose)
				
			elseif event == "SPELL_AURA_APPLIED_DOSE" then
				self.Dose = dose
				self.Text:SetText(dose)
				if dose >= 2 and not self.Text:IsShown() then
					self.Text:Show()
				end
				
				local _, _, _, _, _, duration = UnitAura("Player", self.SpellName)
				self.CDFrame:SetHeight(0)
				if duration == 0 then 
					self.CDFrame.deltaH = 0
				else
					self.CDFrame.deltaH = 48.0 / duration
				end
				
			elseif event == "SPELL_AURA_REMOVED_DOSE" then 
				self.Dose = dose
				self.Text:SetText(dose)
				if dose < 2 and self.Text:IsShown() then
					self.Text:Hide()
				end
				
			elseif event == "SPELL_AURA_REFRESH" then
				local _, _, _, _, _, duration = UnitAura("Player", self.SpellName)
				self.CDFrame:SetHeight(0)
				if duration == 0 then 
					self.CDFrame.deltaH = 0
				else
					self.CDFrame.deltaH = 48.0 / duration
				end
				
			elseif event == "SPELL_AURA_BROKEN" or event == "SPELL__AURA_BROKEN_SPELL" then 
				if self:IsShown() then
					self:Hide()
				end
			end
			--print(event, self.SpellName, self.Dose)
		end
	end,
	
	ON_UPDATE = function(self, elapsed)
		--print(self:GetHeight())
		self.RefreshRate = self.RefreshRate + elapsed
		if self.RefreshRate < 0.1 then 
			return
		else
			self.RefreshRate = 0
			local a, _, _, _, _, duration, expires = UnitAura("Player", self:GetParent().SpellName)
			if a == nil then 
				return
			elseif duration == 0 then
				self:SetHeight(0)
			else
				self:SetHeight(48 - 48.0 * (expires - GetTime()) / duration)
			end
			--height = 48 - 48.0 * (expires - GetTime()) / duration
		end
	end
	
}


