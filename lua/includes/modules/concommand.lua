--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local ConCommand = ConCommand
local Warning = dbg.Warning
local tostring = tostring
local pcall = pcall
local tonumber = tonumber
local cvar = require("cvar")

module( "concommand", package.seeall )

local bError, strError
local function isfunction(v) return type(v) == "function" end
local function isstring(v) return type(v) == "string" end
local function isnumber(v) return type(v) == "number" end
local tFnCommandCallbacks = {}

function Create( pName, callback, pHelpString, flags )
  tFnCommandCallbacks[ pName ] = callback
  ConCommand( pName, pHelpString, flags )
end

function Add( pName, callback )
  if not isstring(pName) then 
    return
  end

  Create( pName, callback, nil, 0 )
end

function Dispatch( pPlayer, pCmd, ArgS )
  local fnCommandCallback = tFnCommandCallbacks[ pCmd ]
  if ( not fnCommandCallback ) then
    return false
  else
    bError, strError = pcall( fnCommandCallback, pPlayer, pCmd, ArgS )
    if ( bError == false ) then
      Warning( "ConCommand '" .. tostring( pCmd ) .. "' Failed: " .. tostring( strError ) .. "\n" )
    end
    return true
  end
end

function Remove( pName )
  if ( tFnCommandCallbacks[ pName ] ) then
    tFnCommandCallbacks[ pName ] = nil
  end
end