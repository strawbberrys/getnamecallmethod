--!strict

local overlapParams = OverlapParams.new()
local color3 = Color3.new()

export type DataTypesWithNamecall =
	Color3
	| CFrame
	| Instance
	| OverlapParams
	| Random
	| Ray
	| RaycastParams
	| RBXScriptConnection
	| RBXScriptSignal
	| Region3
	| UDim2
	| Vector2
	| Vector3

local function extractNamecallHandler()
	return debug.info(2, "f")
end

local function getNamecallHandlerFromObject(object: DataTypesWithNamecall)
	local _, namecallHandler = xpcall(function()
		(object :: any):__namecall()
	end, extractNamecallHandler)

	assert(namecallHandler, `A namecall handler could not be extracted from object: '{object}'`)

	return namecallHandler
end

return {
	firstNamecallHandler = getNamecallHandlerFromObject(overlapParams),
	secondNamecallHandler = getNamecallHandlerFromObject(color3),
}
