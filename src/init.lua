--!strict

local namecallHandlers = require(script.namecallHandlers)

local firstNamecallHandler = namecallHandlers.firstNamecallHandler
local secondNamecallHandler = namecallHandlers.secondNamecallHandler

local function matchNamecallMethodFromError(errorMessage: string): string?
	return string.match(errorMessage, "^(.+) is not a valid member of %w+$")
end

local function getNamecallMethod(): string
	local ok, errorMessage = pcall(firstNamecallHandler)
	local namecallMethod = if not ok then matchNamecallMethodFromError(errorMessage) else nil

	if not namecallMethod then
		ok, errorMessage = pcall(secondNamecallHandler)
		namecallMethod = if not ok then matchNamecallMethodFromError(errorMessage) else nil
	end

	assert(namecallMethod, `Could not find the namecall method in error message: '{errorMessage}'`)

	return namecallMethod
end

return getNamecallMethod
