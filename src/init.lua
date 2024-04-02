--!strict

local namecallHandlers = require(script.namecallHandlers)

local firstNamecallHandler = namecallHandlers.firstNamecallHandler
local secondNamecallHandler = namecallHandlers.secondNamecallHandler

local function matchNamecallMethodFromError(errorMessage: string): string?
	return errorMessage:match("^(.+) is not a valid member of %w+$")
end

local function getNamecallMethod(): string
	local _, errorMessage = pcall(firstNamecallHandler)
	local namecallMethod = if type(errorMessage) == "string" then matchNamecallMethodFromError(errorMessage) else nil

	if not namecallMethod then
		_, errorMessage = pcall(secondNamecallHandler)
		namecallMethod = if type(errorMessage) == "string" then matchNamecallMethodFromError(errorMessage) else nil
	end

	assert(namecallMethod, `Could not find the namecall method in error message: '{errorMessage}'`)

	return namecallMethod
end

return getNamecallMethod
