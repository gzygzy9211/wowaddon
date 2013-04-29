local BWmainframe = BWmainframePointer
local help_info1 = "\t To add spell watch, enter /bfw add {spell id}.\n To remove spell watch, enter /bfw rm {spell id}.\n To list all watch, enter /bfw list.\n To open/close debug, enter /bfw debug.\n"
local help_info2 = "\t To add spell watch group, enter /bfw addg {group name}.\n To remove spell watch group, enter /bfw rmg {group name}.\n To select a group, enter /bfw sel {group name}"

SLASH_BUFFWATCHER1 = "/buffwatcher"
SLASH_BUFFWATCHER2 = "/bfw"

SlashCmdList["BUFFWATCHER"] = function (...)
	local arg, var = ...
	arg, var = strsplit(" ", arg)
	--print(arg)
	--print(var)
	if arg == "add" then 
		local func = BWmainframe.SlashHandleFunc["add"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "rm" or arg == "remove" then 
		local func = BWmainframe.SlashHandleFunc["rm"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "list" then 
		local func = BWmainframe.SlashHandleFunc["list"]
		func(var)
	elseif arg == "listc" then 
		local func = BWmainframe.SlashHandleFunc["listc"]
		func(var)
	elseif arg == "addg" then 
		local func = BWmainframe.SlashHandleFunc["addg"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "rmg" then 
		local func = BWmainframe.SlashHandleFunc["rmg"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "sel" then 
		local func = BWmainframe.SlashHandleFunc["sel"]
		if func(var) then 
			print("succeeded")
		end
	elseif arg == "debug" then 
		BuffWatcherData._debug = not BuffWatcherData._debug
		print(BuffWatcherData._debug)
	else
		print(help_info1)
		print(help_info2)
	end
end

BWmainframe.SlashHandleFunc = {
	
	add = function(var)
		if BuffWatcherData.CurrentGroup == nil then 
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
		table.insert(BuffWatcherData.CurrentGroup, var)
		return true
	end,
	
	rm = function(var)
		local flag = false
		var = tonumber(var)
		for i,v in pairs(BuffWatcherData.CurrentGroup) do 
			if v == var then 
				table.remove(BuffWatcherData.CurrentGroup, i)
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
		if BuffWatcherData.Spells == nil then return end
		local i, v, j, c
		for i,v in pairs(BuffWatcherData.Spells) do 
			print(i)
			for j,c in pairs(v) do
				print(GetSpellInfo(c))
			end
		end
	end,
	
	listc = function(var)
		local i, v
		if BuffWatcherData.CurrentGroup == nil then return end
		for i,v in pairs(BuffWatcherData.CurrentGroup) do 
			print(GetSpellInfo(v))
		end
	end,
	
	addg = function(var)
		if BuffWatcherData.Spells[var] ~= nil then 
			print("Group exists")
			return false
		else
			BuffWatcherData.Spells[var] = {}
			return true
		end
	end,
	
	rmg = function(var)
		if BuffWatcherData.CurrentGroup == BuffWatcherData.Spells[var] then 
			BuffWatcherData.CurrentGroup = nil
			BuffWatcherData.CurrentGroupName = ""
			print("set nil")
		end
		BuffWatcherData.Spells[var] = nil
		--[[local c = 0, i, v
		print("var= ", var)
		for i,v in pairs(BuffWatcherData.Spells) do 
			print(i)
			if i == var then break end
			c = c + 1
		end
		table.remove(BuffWatcherData.Spells, c)
		]]--
		return true
	end,
	
	sel = function(var)
		if BuffWatcherData.Spells[var] ~= nil then 
			BuffWatcherData.CurrentGroup = BuffWatcherData.Spells[var]
			BuffWatcherData.CurrentGroupName = var
			return true
		else 
			print("No such group exists")
			return false
		end
	end
	
}
