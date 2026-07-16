--- Copyright © 2026, YourLocalCappy, all rights deserved ---

-- finally fixed

_BASE_GM = "deathmatch" -- I can't put sandbox here

local hook = hook or require( "hook" )
local table = table
local print = print
local _BASE_GAMEMODE = _BASE_GM
local _G = _G

module( "gamemode", package.seeall )

local tGamemodes = {}

-------------------------------------------------------------------------------
-- Purpose: Calls a gamemode function
-- Input  : strEventName - Name of the internal GameRules method
-- Output :
-------------------------------------------------------------------------------
function call( strEventName, ... ) -- so I can use this for timer... hmmm...
  if ( _G._GAMEMODE and _G._GAMEMODE[ strEventName ] == nil ) then
    return false
  end
  return hook.call( strEventName, _G._GAMEMODE, ... )
end

-------------------------------------------------------------------------------
-- Purpose: Returns a gamemode table object
-- Input  : strName - Name of the gamemode
-- Output : table
-------------------------------------------------------------------------------
function get( strName )
  return tGamemodes[ strName ]
end

-------------------------------------------------------------------------------
-- Purpose: Registers a gamemode
-- Input  : tGamemode - Gamemode table object
--          strName - Name of the gamemode
--          strBaseClass - Name of the base class
-- Output :
-------------------------------------------------------------------------------
function register( tGamemode, strName, strBaseClass )
  if ( get( strName ) ~= nil and _G._GAMEMODE ~= nil ) then
    tGamemode = table.inherit( tGamemode, _G._GAMEMODE )
  end
  if ( strName ~= _BASE_GAMEMODE ) then
    tGamemode = table.inherit( tGamemode, get( strBaseClass ) )
  end
  tGamemodes[ strName ] = tGamemode
end
