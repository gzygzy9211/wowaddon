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

local IRmainframe = IRmainframePointer
local help_info1 = "\t To add spell watch, enter /iir add {spell id}.\n To remove spell watch, enter /iir rm {spell id}.\n To list all watch, enter /iir list.\n To open/close debug, enter /iir debug.\n"
local help_info2 = "\t To add spell watch group, enter /iir addg {group name}.\n To remove spell watch group, enter /iir rmg {group name}.\n To select a group, enter /iir sel {group name}"

function IRmainframe:releaseOnUpdate()
	self:SetScript("OnUpdate", function(self, elapsed) end)
end

SLASH_ITISREADY1 = "/itisready"
SLASH_ITISREADY2 = "/iir"

SlashCmdList["ITISREADY"] = function (...)
	local arg, var = ...
	arg, var = strsplit(" ", arg)
	--print(arg)
	--print(var)
	if arg == "add" then 
		IRmainframe:releaseOnUpdate()
		local func = IRmainframe.SlashHandleFunc["add"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "rm" or arg == "remove" then 
		IRmainframe:releaseOnUpdate()
		local func = IRmainframe.SlashHandleFunc["rm"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "list" then 
		local func = IRmainframe.SlashHandleFunc["list"]
		func(var)
	elseif arg == "listc" then 
		local func = IRmainframe.SlashHandleFunc["listc"]
		func(var)
	elseif arg == "addg" then 
		local func = IRmainframe.SlashHandleFunc["addg"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "rmg" then 
		IRmainframe:releaseOnUpdate()
		local func = IRmainframe.SlashHandleFunc["rmg"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "sel" then 
		IRmainframe:releaseOnUpdate()
		local func = IRmainframe.SlashHandleFunc["sel"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "debug" then 
		ItIsReadyData._debug = not ItIsReadyData._debug
		print(ItIsReadyData._debug)
	else
		print(help_info1)
		print(help_info2)
	end
end

IRmainframe.SlashHandleFunc = {
	
	add = function(var)
		if ItIsReadyData.CurrentGroup == nil then 
			print("No group is selected")
			return false
		end
		if tonumber(var) == nil then 
			print("Please input a number")
			return false
		end
		var = tonumber(var)
		if var >= 10000000 then 
			print("Input number is too large")
			return false
		end
		if GetSpellInfo(var) == nil then 
			print("No such spell exists")
			return false
		end
		table.insert(ItIsReadyData.CurrentGroup, var)
		return true
	end,
	
	rm = function(var)
		local flag = false
		var = tonumber(var)
		for i,v in pairs(ItIsReadyData.CurrentGroup) do 
			if v == var then 
				table.remove(ItIsReadyData.CurrentGroup, i)
				flag = true
				break
			end
		end
		if flag then 
			print("Removed")
			return true
		else
			print("No such spell")
			return false
		end
	end,
	
	list = function(var)
		if ItIsReadyData.Spells == nil then return end
		local i, v, j, c
		for i,v in pairs(ItIsReadyData.Spells) do 
			print(i)
			for j,c in pairs(v) do
				print(GetSpellInfo(c))
			end
		end
	end,
	
	listc = function(var)
		local i, v
		if ItIsReadyData.CurrentGroup == nil then return end
		for i,v in pairs(ItIsReadyData.CurrentGroup) do 
			print(GetSpellInfo(v))
		end
	end,
	
	addg = function(var)
		if ItIsReadyData.Spells[var] ~= nil then 
			print("Group exists")
			return false
		else
			ItIsReadyData.Spells[var] = {}
			return true
		end
	end,
	
	rmg = function(var)
		if ItIsReadyData.CurrentGroup == ItIsReadyData.Spells[var] then 
			ItIsReadyData.CurrentGroup = nil
			ItIsReadyData.CurrentGroupName = ""
			print("set nil")
		end
		ItIsReadyData.Spells[var] = nil
		--[[local c = 0, i, v
		print("var= ", var)
		for i,v in pairs(ItIsReadyData.Spells) do 
			print(i)
			if i == var then break end
			c = c + 1
		end
		table.remove(ItIsReadyData.Spells, c)
		]]--
		return true
	end,
	
	sel = function(var)
		if ItIsReadyData.Spells[var] ~= nil then 
			ItIsReadyData.CurrentGroup = ItIsReadyData.Spells[var]
			ItIsReadyData.CurrentGroupName = var
			return true
		else 
			print("No such group exists")
			return false
		end
	end
	
}
