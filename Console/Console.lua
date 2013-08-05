local PlayerName = GetUnitName("Player")
local _, PlayerClass = UnitClass("Player")
--print("ha")

local Console = CreateFrame("Frame", nil, UIParent)
ConsolePointer = Console

Console.isInit = false


--Console:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Console:RegisterEvent("PLAYER_LOGIN")
Console:RegisterEvent("ADDON_LOADED")
Console:SetScript("OnEvent", function(self,e,...) 
	local func = self.HandleFunc[e]
	func(...)
end)
--[[
Console:SetScript("OnUpdate", function(self, elapsed)
	local func = self.HandleFunc["ON_UPDATE"]
	func(elapsed)
end
]]--
Console.HandleFunc = {

	ADDON_LOADED = function(...)
		local AddonName = ...
		if AddonName ~= "Console" then return end
		--Initialize Saved Variables if Necessary
		if ConsoleData == nil then 
			ConsoleData = {}
			ConsoleData.Position = {X = 335, Y = 155}
			if ConsoleData.CurrentText == nil then 
				ConsoleData.CurrentText = ""
			end
		end
		
		--print("Spells:", type(ItIsReadyData["Spells"]))
	end,
	
	PLAYER_LOGIN = function (...)
		Console.Main = CreateFrame("Frame", nil, UIParent)
		Console.Main:SetHeight(500)
		Console.Main:SetWidth(500)
		Console.Main:SetBackdrop({
			bgFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 背景材质路径 
			insets = {left = 1,right = 1,top = 1,bottom = 1}, -- 背景收缩程度，单位为像素，例如，top = 1即背景材质的上边缘向内收缩1个像素 
			edgeFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 边框材质路径 
			edgeSize = 1, -- 边框宽度 
		})
		Console.Main:SetBackdropColor(0, 0, 0, 0.5)
		Console.Main:SetBackdropBorderColor(0, 0, 0, 0.7)
		Console.Main:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", ConsoleData.Position.X, ConsoleData.Position.Y)
		Console.Main:SetMovable(true)
		Console.Main:EnableMouse(true)
		Console.Main:RegisterForDrag("LeftButton")
		Console.Main:SetScript("OnDragStart", Console.Main.StartMoving)
		Console.Main:SetScript("OnDragStop", function()
			Console.Main:StopMovingOrSizing()
			ConsoleData.Position.Y = Console.Main:GetBottom() 
			ConsoleData.Position.X = Console.Main:GetLeft() 
		end)
		
		Console.Main.Title = Console.Main:CreateFontString(nil, "OVERLAY")
		Console.Main.Title:SetFont(GameTooltipText:GetFont(), 15, "THINOUTLINE")
		Console.Main.Title:SetText("Lua Console")
		Console.Main.Title:SetPoint("TOP" , Console.Main, "TOP", 0, -5)
		
		Console.ScriptFrame = CreateFrame("EditBox", nil, Console.Main)
		Console.ScriptFrame:SetSize(480, 450)
		--Console.ScriptFrame:SetPoint("CENTER", Console.Main, "CENTER", 0, 3)
		Console.ScriptFrame:SetBackdrop({
			bgFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 背景材质路径 
			insets = {left = 1,right = 1,top = 1,bottom = 1}, -- 背景收缩程度，单位为像素，例如，top = 1即背景材质的上边缘向内收缩1个像素 
			edgeFile = "Interface\\AddOns\\Sora's Threat\\Media\\Solid", -- 边框材质路径 
			edgeSize = 1, -- 边框宽度 
		})
		Console.ScriptFrame:SetBackdropColor(0, 0, 0, 0.8)
		Console.ScriptFrame:SetBackdropBorderColor(0, 0, 0, 0.8)
		Console.ScriptFrame:ClearFocus()
		Console.ScriptFrame:SetMultiLine(true)
		Console.ScriptFrame:SetMaxBytes(0)
		Console.ScriptFrame:SetMaxLetters(0)
		Console.ScriptFrame:SetAutoFocus(false)
		Console.ScriptFrame:SetFontObject(ChatFontNormal)
		Console.ScriptFrame:EnableMouse(true)
		Console.ScriptFrame:SetText(ConsoleData.CurrentText)
		
		Console.ScriptScroll = CreateFrame("ScrollFrame", "ScrollHandle", Console.Main, "UIPanelScrollFrameTemplate")
		Console.ScriptScroll:SetPoint("TOPLEFT", Console.Main, "TOPLEFT", 10, -22)
		Console.ScriptScroll:SetPoint("BOTTOMRIGHT", Console.Main, "BOTTOMRIGHT", -30, 25)
		Console.ScriptScroll:SetScrollChild(Console.ScriptFrame)
		
		Console.HideAndShowButton = CreateFrame("Button", "ConsoleDisplayControl", UIParent, "UIPanelButtonTemplate")
		Console.HideAndShowButton:SetText("Hide")
		Console.HideAndShowButton:SetScript("OnClick", function() 
			local func = Console.HandleFunc["HIDE_SHOW_BUTTON_CLICK"]
			func()
		end)
		Console.HideAndShowButton:SetPoint("BOTTOMLEFT", Console.Main, "BOTTOMLEFT", 5, -24)
		Console.HideAndShowButton:SetSize(55, 22)
		
		Console.RunBotton = CreateFrame("Button", "RunBotton", Console.Main, "UIPanelButtonTemplate")
		Console.RunBotton:SetText("Run!")
		Console.RunBotton:SetScript("OnClick", function()
			local func = Console.HandleFunc["RUN_BOTTON_CLICK"]
			func()
		end)
		Console.RunBotton:SetPoint("BOTTOMRIGHT", Console.Main, "BOTTOMRIGHT", -5, 2)
		Console.RunBotton:SetSize(55, 22)
		
		Console.ReloadUIButton = CreateFrame("Button", "ReloadUIButton", Console.Main, "UIPanelButtonTemplate")
		Console.ReloadUIButton:SetText("ReloadUI")
		Console.ReloadUIButton:SetScript("OnClick", function() 
			ConsoleData.CurrentText = Console.ScriptFrame:GetText()
			ReloadUI()
		end)
		Console.ReloadUIButton:SetPoint("BOTTOMLEFT", Console.Main, "BOTTOMLEFT", 5, 2)
		Console.ReloadUIButton:SetSize(75, 22)
		
		print("Console has inicialized")
		--print(type(ConsoleData.CurrentText))
	end,
	
	HIDE_SHOW_BUTTON_CLICK = function()
		if Console.Main:IsShown() then
			Console.Main:Hide()
			Console.HideAndShowButton:SetText("Show")
		else
			Console.Main:Show()
			Console.HideAndShowButton:SetText("Hide")
		end
	end,
	
	RUN_BOTTON_CLICK = function()
		local code =  Console.ScriptFrame:GetText()
		--code = string.gsub(code, "\t", "___")
		print(">> "..code)
		local f = assert(loadstring(code))
		f()
	end
	
}

