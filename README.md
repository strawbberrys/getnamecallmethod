# getnamecallmethod
A vanilla Roblox getnamecallmethod implementation.

## Building
```
$ git clone https://github.com/strawbberrys/getnamecallmethod.git
$ cd getnamecallmethod
$ aftman install
$ rojo build --output getNamecallMethod.rbxm
```

## Usage
```lua
local getNamecallMethod = require(game.ReplicatedStorage.getNamecallMethod)

local object = newproxy(true)
local objectMt = getmetatable(object)

objectMt.__namecall = function(self, ...)
	local namecallMethod = getNamecallMethod()

	print(`{self}:{namecallMethod}({...})`)
end

object:lookAtThis(1234)
```

<details>
<summary><h2>Explanation</h2></summary>

### getnamecallmethod.luau
```lua
local namecallHandlers = require(script.namecallHandlers)

local firstNamecallHandler = namecallHandlers.firstNamecallHandler
local secondNamecallHandler = namecallHandlers.secondNamecallHandler

-- When a namecall handler is called, it should error with: "NamecallMethod is not a valid member of DataType"
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
```

### namecallHandlers.luau
```lua
--!strict

local overlapParams = OverlapParams.new() -- An object with the namecall metamethod set.
local color3 = Color3.new() -- A second object with unique methods, used in case a valid namecall method was used on the first object.

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

-- Grabs the function creating the invalid method error.
local function extractNamecallHandler()
	return debug.info(2, "f")
end

local function getNamecallHandlerFromObject(object: DataTypesWithNamecall)
	-- Cause a namecall error by calling a non-existent method.
	-- The method called will be whatever the current stacks namecall method is.
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

```
</details>