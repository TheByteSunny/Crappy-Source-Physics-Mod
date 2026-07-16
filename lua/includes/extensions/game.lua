--- Copyright © 2026, YourLocalCappy, all rights deserved ---

-- not useful
function i(data)
  if type(data) ~= "string" then
    return ""
  end

  return data
end

i[[

   do not mess with this

]]
GLOBAL = _G
IN_GAME = not _CLIENT
CLIENT = _CLIENT == true
SERVER = IN_GAME == true
CLIVER = CLIENT and SERVER
SHARED = CLIVER == true
NOSIDE = not CLIENT and not SERVER or not CLIVER -- useless
NULL = nil

require("filesystemtwo")
includeC = include
concommand = require("concommand")
hook = require("hook")
timer = require("timer") -- TIMER!!!
Timer = timer
entity = require("entity")
engine = engine
cvar = require("cvar")
filesystem = require("filesystem")
gamemode = gamemode or require("gamemode")
util = util or {}
bit = require("bit")
material = IMaterial or _R.IMaterial
scriptpanel = CScriptedClientLuaPanel or _R.CScriptedClientLuaPanel
ppage = PropertyPage or _R.PropertyPage
pdialog = PropertyDialog or _R.PropertyDialog
frame = Frame or _R.Frame
panel = Panel or _R.Panel
checkbutton = CheckButton or _R.CheckButton
button = Button or _R.Button
net = require("net")

function isfunction(v) return type(v) == "function" end
function isstring(v) return type(v) == "string" end
function isnumber(v) return type(v) == "number" end

if not bit then
bit = nil
end

cmd = concommand
GM = gamemode
ent = entity

Warning = dbg.Warning
DevMsg = dbg.DevMsg
DevWarning = dbg.DevWarning
Msg = dbg.Msg

function AddThink(name, fn)
  timer.Add(name, 0.1, 0, fn)
end

function IsValid(a)
if a == nil then return false end
if a == NULL then return false end
return true
end

function CreateVConVar(cvarName, default, min, max, onChange)

    local vconvar = ConVar(cvarName, default, FCVAR_CLIENTDLL)

    min = tonumber(min)
    max = tonumber(max)

    local prevValue = tonumber(vconvar:GetString()) or tonumber(default) or 0

    local function ClampValue(val)
        val = tonumber(val) or 0

        if min and val < min then
            val = min
        end

        if max and val > max then
            val = max
        end

        return val
    end

    local function callback(varName, oldStr, oldNum)

        local newValue = ClampValue(vconvar:GetString())

        if newValue ~= tonumber(vconvar:GetString()) then
            vconvar:SetValue(newValue)
        end

        if newValue ~= prevValue then
            onChange(newValue, prevValue)
        end

        prevValue = newValue
    end

    cvar.AddChangeCallback(cvarName, "vproxy_" .. cvarName, callback)

    local startValue = ClampValue(prevValue)
    prevValue = startValue

    if onChange then
        onChange(startValue, nil)
    end

    return vconvar
end

function CreateClientConVar(cvarName, default, save, udata)
    local fcvar = FCVAR_CLIENTDLL

    if save then
       fcvar = bit.bor(fcvar, FCVAR_ARCHIVE)
    end

    if udata then
       fcvar = bit.bor(fcvar, FCVAR_USERINFO)
    end

    return ConVar(cvarName, default, fcvar)
end

function GetConVar(c)
  return cvar.FindVar(c)
end

function ColorPrint(r, g, b, a, msg)
if dbg and dbg.ConColorMsg then
dbg.ConColorMsg(Color(r, g, b, a or 255), msg .. "\n")
else
print(msg)
end
end

util = util

game = game or {}

function util.PrecacheModel(model)
  _R.CBaseEntity.PrecacheModel(model)
end

function CurTime()
  if gpGlobals and gpGlobals.curtime then
      return gpGlobals.curtime()
  end
  if _G.CurTime then
      return _G.CurTime()
  end
  return os.clock()
end

function FrameTime()
  return gpGlobals.frametime()
end

function hook.Add(type, name, fn)
  hook.add(type, name, fn)
end

ents = {}

function ents.Create(entName)
  return CreateEntityByName(entName)
end

function game.SinglePlayer()
  return gpGlobals.maxClients() == 1
end

function game.MultiPlayer()
  return gpGlobals.maxClients() > 1
end

function game.IsDedicated()
  return SERVER and not gpGlobals.IsClient()
end

function game.MaxPlayers()
  return gpGlobals.maxClients()
end

CONTENTS_EMPTY = 0
CONTENTS_SOLID = 0x1
CONTENTS_WINDOW = 0x2
CONTENTS_AUX = 0x4
CONTENTS_GRATE = 0x8
CONTENTS_SLIME = 0x10
CONTENTS_WATER = 0x20
CONTENTS_BLOCKLOS = 0x40
CONTENTS_OPAQUE = 0x80
LAST_VISIBLE_CONTENTS = 0x80

ALL_VISIBLE_CONTENTS = bit and bit.bor(
LAST_VISIBLE_CONTENTS,
LAST_VISIBLE_CONTENTS - 1
) or LAST_VISIBLE_CONTENTS

CONTENTS_TESTFOGVOLUME = 0x100
CONTENTS_UNUSED = 0x200
CONTENTS_UNUSED6 = 0x400
CONTENTS_TEAM1 = 0x800
CONTENTS_TEAM2 = 0x1000
CONTENTS_IGNORE_NODRAW_OPAQUE = 0x2000
CONTENTS_MOVEABLE = 0x4000
CONTENTS_AREAPORTAL = 0x8000
CONTENTS_PLAYERCLIP = 0x10000
CONTENTS_MONSTERCLIP = 0x20000
CONTENTS_CURRENT_0 = 0x40000
CONTENTS_CURRENT_90 = 0x80000
CONTENTS_CURRENT_180 = 0x100000
CONTENTS_CURRENT_270 = 0x200000
CONTENTS_CURRENT_UP = 0x400000
CONTENTS_CURRENT_DOWN = 0x800000
CONTENTS_ORIGIN = 0x1000000
CONTENTS_MONSTER = 0x2000000
CONTENTS_DEBRIS = 0x4000000
CONTENTS_DETAIL = 0x8000000
CONTENTS_TRANSLUCENT = 0x10000000
CONTENTS_LADDER = 0x20000000
CONTENTS_HITBOX = 0x40000000

COLLISION_GROUP_NONE = 0
COLLISION_GROUP_DEBRIS = 1
COLLISION_GROUP_DEBRIS_TRIGGER = 2
COLLISION_GROUP_INTERACTIVE_DEBRIS = 3
COLLISION_GROUP_INTERACTIVE = 4
COLLISION_GROUP_PLAYER = 5
COLLISION_GROUP_BREAKABLE_GLASS = 6
COLLISION_GROUP_VEHICLE = 7
COLLISION_GROUP_PLAYER_MOVEMENT = 8
COLLISION_GROUP_NPC = 9
COLLISION_GROUP_IN_VEHICLE = 10
COLLISION_GROUP_WEAPON = 11
COLLISION_GROUP_VEHICLE_CLIP = 12
COLLISION_GROUP_PROJECTILE = 13
COLLISION_GROUP_DOOR_BLOCKER = 14
COLLISION_GROUP_PASSABLE_DOOR = 15
COLLISION_GROUP_DISSOLVING = 16
COLLISION_GROUP_PUSHAWAY = 17
COLLISION_GROUP_NPC_ACTOR = 18
COLLISION_GROUP_NPC_SCRIPTED = 19
LAST_SHARED_COLLISION_GROUP = 20

DMG_GENERIC = 0
DMG_CRUSH = bit.lshift(1, 0)
DMG_BULLET = bit.lshift(1, 1)
DMG_SLASH = bit.lshift(1, 2)
DMG_BURN = bit.lshift(1, 3)
DMG_VEHICLE = bit.lshift(1, 4)
DMG_FALL = bit.lshift(1, 5)
DMG_BLAST = bit.lshift(1, 6)
DMG_CLUB = bit.lshift(1, 7)
DMG_SHOCK = bit.lshift(1, 8)
DMG_SONIC = bit.lshift(1, 9)
DMG_ENERGYBEAM = bit.lshift(1, 10)
DMG_PREVENT_PHYSICS_FORCE = bit.lshift(1, 11)
DMG_NEVERGIB = bit.lshift(1, 12)
DMG_ALWAYSGIB = bit.lshift(1, 13)
DMG_DROWN = bit.lshift(1, 14)
DMG_PARALYZE = bit.lshift(1, 15)
DMG_NERVEGAS = bit.lshift(1, 16)
DMG_POISON = bit.lshift(1, 17)
DMG_RADIATION = bit.lshift(1, 18)
DMG_DROWNRECOVER = bit.lshift(1, 19)
DMG_ACID = bit.lshift(1, 20)
DMG_SLOWBURN = bit.lshift(1, 21)
DMG_REMOVENORAGDOLL = bit.lshift(1, 22)
DMG_PHYSGUN = bit.lshift(1, 23)
DMG_PLASMA = bit.lshift(1, 24)
DMG_AIRBOAT = bit.lshift(1, 25)
DMG_DISSOLVE = bit.lshift(1, 26)
DMG_BLAST_SURFACE = bit.lshift(1, 27)
DMG_DIRECT = bit.lshift(1, 28)
DMG_BUCKSHOT = bit.lshift(1, 29)

AUTOAIM_2DEGREES = 0.0348994967
AUTOAIM_5DEGREES = 0.0871557427
AUTOAIM_8DEGREES = 0.1391731010
AUTOAIM_10DEGREES = 0.1736481777
AUTOAIM_20DEGREES = 0.3490658504

MoveType = {
NONE = 0,
ISOMETRIC = 1,
WALK = 2,
STEP = 3,
FLY = 4,
FLYGRAVITY = 5,
VPHYSICS = 6,
PUSH = 7,
NOCLIP = 8,
LADDER = 9,
OBSERVER = 10,
CUSTOM = 11,
LAST = 11,
MAX_BITS = 4
}


for key, value in pairs(MoveType) do
  _G["MoveType_" .. key] = value
end

for key, value in pairs(MoveType) do
  _G["MOVETYPE_" .. key] = value
end

FCVAR = {
  NONE = 0,
  UNREGISTERED = 1,
  DEVELOPMENTONLY = 2,
  GAMEDLL = 4,
  CLIENTDLL = 8,
  HIDDEN = 16,
  PROTECTED = 32,
  SPONLY = 64,
  ARCHIVE = 128,
  NOTIFY = 256,
  USERINFO = 512,
  CHEAT = 1024,
  PRINTABLEONLY = 2048,
  UNLOGGED = 4096,
  NEVER_AS_STRING = 8192,
  REPLICATED = 16384,
  DEMO = 32768,
  DONTRECORD = 65536,
  NOT_CONNECTED = 131072,
  ARCHIVE_XBOX = 262144,
  SERVER_CAN_EXECUTE = 524288,
  SERVER_CANNOT_QUERY = 1048576,
  CLIENTCMD_CAN_EXECUTE = 2097152,
}

for key, value in pairs(FCVAR) do
  _G["FCVAR_" .. key] = value
end

MoveCollide = {
DEFAULT = 0,
FLY_BOUNCE = 1,
FLY_CUSTOM = 2,
FLY_SLIDE = 3,
COUNT = 4,
MAX_BITS = 3
}

SOLID = {
NONE = 0,
BSP = 1,
BBOX = 2,
OBB = 3,
OBB_YAW = 4,
CUSTOM = 5,
VPHYSICS = 6,
LAST = 7
}

SolidType = {
NONE = 0,
BSP = 1,
BBOX = 2,
OBB = 3,
OBB_YAW = 4,
CUSTOM = 5,
VPHYSICS = 6,
LAST = 7
}

for key, value in pairs(SolidType) do
  _G["SOLID_" .. key] = value
end

for key, value in pairs(SOLID) do
  _G["SolidType_" .. key] = value
end

SolidFlags = {
CUSTOMRAYTEST = 0x0001,
CUSTOMBOXTEST = 0x0002,
NOT_SOLID = 0x0004,
TRIGGER = 0x0008,
NOT_STANDABLE = 0x0010,
VOLUME_CONTENTS = 0x0020,
FORCE_WORLD_ALIGNED = 0x0040,
USE_TRIGGER_BOUNDS = 0x0080,
ROOT_PARENT_ALIGNED = 0x0100,
TRIGGER_TOUCH_DEBRIS = 0x0200,
MAX_BITS = 10
}

for i = 0, 360 do
  _G["AUTOAIM_" .. i .. "DEGREES"] = math.sin(math.rad(i))
end

UTIL = UTIL or util 

function DEFINE_BASECLASS(name)

  if ENT then
     ENT.__base = name
  elseif SWEP then
     SWEP.__base = name
  else
     Warning("Not a SWEP or a entity!")
  end

end

function DEFINE_FACTORY(name)

  if ENT then
     ENT.__factory = name
  elseif SWEP then
     SWEP.__factory = name
  else
     Warning("Not a SWEP or a entity!")
  end

end

-- I need this for some stuff
function SToScreen(pos)

    if not debugoverlay or not debugoverlay.ScreenPosition then
        return { x = 0, y = 0, visible = false }
    end

    local out = Vector()
    debugoverlay.ScreenPosition(pos, out)

    local scrW = UTIL.ScreenWidth()
    local scrH = UTIL.ScreenHeight()

    local visible = true

    if out.x < 0 or out.x > scrW then visible = false end
    if out.y < 0 or out.y > scrH then visible = false end

    return {
        x = out.x,
        y = out.y,
        visible = visible
    }
end

function ReturnFlags(flags, flag)

  if IsValid(flags) and IsValid(flag) then
  
     local bbflags = bit.band(flags, flag) ~= 0

     return bbflags
  
  end

end

i [[ test ]]

i [[

TEST TWOOO!!!

]]

concommand.Add("setmaster", function()
  return true
end)

function GetConVar(name)
  return cvar.FindVar(name)
end

if not file.Find then
   require("filesystemtwo")
end

function filesystem.Find(pattern, path, sorting)
  return file.Find(pattern, path, sorting)
end

file = file or {}

function file.Write(name, content)
local f = filesystem.Open(name, "w", "DATA")
if not f then return false end
local ok = filesystem.Write(content, f) == #content
filesystem.Close(f)
return ok
end

function file.Append(name, content)
local f = filesystem.Open(name, "a", "DATA")
if not f then return false end
local ok = filesystem.Write(content, f) == #content
filesystem.Close(f)
return ok
end

function file.Read(name)
local f = filesystem.Open(name, "r", "DATA")
if not f then return nil end
local size = filesystem.Size(f)
if size <= 0 then filesystem.Close(f) return nil end
local _, content = filesystem.Read(size, f)
filesystem.Close(f)
return content
end

function file.Exists(name, path)
return filesystem.FileExists(name, path or "DATA")
end

function file.IsDir(name, path)
return filesystem.IsDirectory(name, path or "DATA")
end

function file.CreateDir(name)
filesystem.CreateDirHierarchy(name, "DATA")
end

function file.Delete(name)
return filesystem.RemoveFile(name, "DATA")
end

function file.Rename(old, new)
return filesystem.RenameFile(old, new, "DATA")
end

function file.Size(name)
local f = filesystem.Open(name, "r", "DATA")
if not f then return 0 end
local size = filesystem.Size(f)
filesystem.Close(f)
return size
end

function file.Find(pattern, path, sorting)
return fl.Find(pattern, path, sorting)
end

CSLUA = {}
CSLUA.Files = {}
CSLUA.BundleName = "cslua_autobundle.dat"

function AddCSLuaFile(path)
    CSLUA.Files[path] = true
end

local function BuildBundle()
    local data = ""

    for path in pairs(CSLUA.Files) do
        local code = file.Read(path)

        if code then
            data = data ..
                "FILE:" .. path .. "\n" ..
                code ..
                "\nEND_FILE\n"
        end
    end

    file.Write(CSLUA.BundleName, data)
end

local function LoadBundle()
    local data = file.Read(CSLUA.BundleName)

    if not data then return end

    local currentPath
    local currentCode = {}

    for line in data:gmatch("[^\r\n]+") do

        if line:sub(1,5) == "FILE:" then

            currentPath = line:sub(6)
            currentCode = {}

        elseif line == "END_FILE" then

            local temp =
                "cslua_cache/" ..
                currentPath:gsub("[/\\]", "_")

            file.CreateDir("cslua_cache")
            file.Write(temp, table.concat(currentCode, "\n"))

            include(temp)

        else

            currentCode[#currentCode + 1] = line

        end
    end
end

function CreateConVar(name, default, flags, help, min, max)

    flags = flags or FCVAR_CLIENTDLL

    local convar = ConVar(name, default, flags)

    min = tonumber(min)
    max = tonumber(max)

    local prev = tonumber(convar:GetString()) or tonumber(default) or 0

    local function Clamp(v)
        v = tonumber(v) or 0

        if min then v = math.max(min, v) end
        if max then v = math.min(max, v) end

        return v
    end

    local function callback()
        local newValue = Clamp(convar:GetString())

        if newValue ~= prev then
            prev = newValue
        end
    end

    cvar.AddChangeCallback(name, "compat_" .. name, callback)

    return convar
end

hook.Add("Initialize", "CSBuild", function()
    BuildBundle()
end)

hook.Add("PostInitialize", "CSLoad", function()
    LoadBundle()
end)


local meta = getmetatable(Vector())
local vec = meta.__index

function vec:GetNormalized()
    local len = self:Length()
    if len == 0 then
        return Vector(0, 0, 0)
    end
    return self * (1 / len)
end

