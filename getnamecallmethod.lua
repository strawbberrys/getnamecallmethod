local overlapParams = OverlapParams.new()
local color3 = Color3.new()

local function extractNamecallHandler()
	return debug.info(2, "f")
end

local firstNamecallHandler = (function()
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
