--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local pairs = pairs
local Warning = dbg.Warning
local tostring = tostring
local pcall = pcall
local unpack = unpack

module( "hook" )

local tHooks = {}
local tReturns = {}

function add( strEventName, strHookName, pFn )
  tHooks[ strEventName ] = tHooks[ strEventName ] or {}
  tHooks[ strEventName ][ strHookName ] = pFn
end

function Add( strEventName, strHookName, pFn )
    return add( strEventName, strHookName, pFn )
end

function call( strEventName, tGamemode, ... )
  local tHooks = tHooks[ strEventName ]
  if ( tHooks ~= nil ) then
    for k, v in pairs( tHooks ) do
      if ( v == nil ) then
        Warning( "Hook '" .. tostring( k ) .. "' (" .. tostring( strEventName ) .. ") tried to call a nil function!\n" )
        tHooks[ k ] = nil
        break
      else
        tReturns = { pcall( v, ... ) }
        if ( tReturns[ 1 ] == false ) then
          Warning( "Hook '" .. tostring( k ) .. "' (" .. tostring( strEventName ) .. ") Failed: " .. tostring( tReturns[ 2 ] ) .. "\n" )
          tHooks[ k ] = nil
        elseif ( tReturns[ 2 ] ~= nil ) then
          return unpack( tReturns, 2 )
        end
      end
    end
  end
  if ( tGamemode ~= nil ) then
    local fn = tGamemode[ strEventName ]
    if ( fn == nil ) then
      return nil
    else
      tReturns = { pcall( fn, tGamemode, ... ) }
      if ( tReturns[ 1 ] == false ) then
        Warning( "ERROR: GAMEMODE: '" .. tostring( strEventName ) .. "' Failed: " .. tostring( tReturns[ 2 ] ) .. "\n" )
        tGamemode[ strEventName ] = nil
        return nil
      end
      return unpack( tReturns, 2 )
    end
  end
end

function Run( strEventName, tGamemode, ... )
    return call( strEventName, tGamemode, ... )
end

function gethooks( strEventName )
  if ( strEventName ) then
    return tHooks[ strEventName ]
  end
  return tHooks
end

function GetTable( strEventName )
    return gethooks( strEventName )
end

function remove( strEventName, strHookName )
  if ( tHooks[ strEventName ][ strHookName ] ) then
    tHooks[ strEventName ][ strHookName ] = nil
  end
end

function Remove( strEventName, strHookName )
     return remove( strEventName, strHookName )
end
