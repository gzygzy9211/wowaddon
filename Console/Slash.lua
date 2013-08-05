--[[SLASH_SAYSOMETHING1 = "/sayit"
SLASH_SAYSOMETHING2 = "/si"

SlashCmdList["SAYSOMETHING"] = function(...)
	local msg = ...
	print(msg)
	ItIsReadyData.msg = msg
end

SLASH_LOADSOMETHING1 = "/loadit"

SlashCmdList["LOADSOMETHING"] = function(...)
	print(ItIsReadyData.msg)
end
]]--

SLASH_RELOADUISHORT1 = "/rl"

SlashCmdList["RELOADUISHORT"] = function(...)
	ReloadUI()
end

local Console = ConsolePointer
local help_info1 = "\t To add spell watch, enter /iir add {spell id}.\n To remove spell watch, enter /iir rm {spell id}.\n To list all watch, enter /iir list.\n To open/close debug, enter /iir debug.\n"
local help_info2 = "\t To add spell watch group, enter /iir addg {group name}.\n To remove spell watch group, enter /iir rmg {group name}.\n To select a group, enter /iir sel {group name}"

function Console:releaseOnUpdate()
	self:SetScript("OnUpdate", function(self, elapsed) end)
end

SLASH_ITISREADY1 = "/console"
SLASH_ITISREADY2 = "/cmd"

SlashCmdList["CONSOLE"] = function (...)
	local arg, var = ...
	arg, var = strsplit(" ", arg)
	--print(arg)
	--print(var)
	if arg == "add" then 
		
	end
end

Console.SlashHandleFunc = {
	
	
}
