# getnamecallmethod
A vanilla Roblox getnamecallmethod implementation.

## Script
```lua
local overlapParams = OverlapParams.new() -- An object with the namecall metamethod set.
local color3 = Color3.new() -- A second object with unique methods, used in case a valid namecall method was used on the first object.

-- Grabs the function creating the error.
local function extractNamecallHandler()
	return debug.info(2, "f")
end

local firstNamecallHandler = (function()
	-- Cause a namecall error by calling a non-existent method.
	-- The method called will be whatever the current stacks namecall method is.
	local success, namecallHandler = xpcall(function()
		overlapParams:__namecall()
	end, extractNamecallHandler)

	return namecallHandler
end)()

local secondNamecallHandler = (function()
	local success, namecallHandler = xpcall(function()
		color3:__namecall()
	end, extractNamecallHandler)

	return namecallHandler
end)()

local function getNamecallMethod(): string
	local success, errorMessage = pcall(firstNamecallHandler)
	local namecallMethod = if type(errorMessage) == "string" then errorMessage:match("^(%w+) is not a valid member of OverlapParams$") else nil

	if success or not namecallMethod then
		local success, errorMessage = pcall(secondNamecallHandler)
		local namecallMethod = if type(errorMessage) == "string" then errorMessage:match("^(%w+) is not a valid member of Color3$") else nil

		assert(not success)
		assert(namecallMethod)

		return namecallMethod
	end

	return namecallMethod
end

return getNamecallMethod
```
