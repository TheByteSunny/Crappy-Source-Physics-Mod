--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local table = _G.table or table or require("table") or {}
local list      = _G.list or list or require("list") or {}
local copy      = table.copy
local pairs     = pairs
local Warning   = dbg and dbg.Warning or print
local Log       = dbg and dbg.ConColorMsg or print

module("playermodel", package.seeall)

local Registry = {
    models = {},
    hands  = {}
}

local function Ensure(tbl, key)
    if not tbl[key] then
        tbl[key] = {}
    end
    return tbl[key]
end

local function shallow_copy(t)
    local new = {}
    for k, v in pairs(t) do
        new[k] = v
    end
    return new
end

local function get_keys(t)
    local out = {}
    for k in pairs(t) do
        out[#out + 1] = k
    end
    return out
end

function AddValidModel(name, model)
    if not name or not model then
        Warning("AddValidModel: invalid arguments")
        return false
    end

    Registry.models[name] = {
        model = model
    }

    list.Set("PlayerOptionsModel", name, model)

    return true
end

function GetValidModel(name)
    local data = Registry.models[name]
    return data and data.model or nil
end

function GetAllModels()
    return shallow_copy(Registry.models)
end

function AddValidHands(name, model, skin, body)
    if not name or not model then
        Warning("AddValidHands: invalid arguments")
        return false
    end

    Registry.hands[name] = {
        model = model,
        skin  = skin or 0,
        body  = body or "0000000"
    }

    return true
end

function GetValidHands(name)
    return Registry.hands[name]
end

function Exists(type, name)
    local bucket = Registry[type]
    return bucket and bucket[name] ~= nil or false
end

function Dump()
    return shallow_copy(Registry)
end

Flags = Flags or {}

Aliases = {}

local function DefineFlag(name, value, alias)
    if _G[name] == nil then
        _G[name] = value
    end

    Flags[name] = value

    if alias then
        Aliases[alias] = value
    end
end

-- NPC
DefineFlag("SF_NPC_GAG", 2, "NPC_GAG")
DefineFlag("SF_NPC_WAIT_TILL_SEEN", 1, "NPC_WAIT")
DefineFlag("SF_NPC_DROP_HEALTHKIT", 8, "NPC_DROP_HP")

-- Citizen
DefineFlag("SF_CITIZEN_MEDIC", 131072, "CIT_MEDIC")
DefineFlag("SF_CITIZEN_RANDOM_HEAD", 262144, "CIT_RANDOM")

-- Weapon
DefineFlag("SF_WEAPON_NO_PLAYER_PICKUP", 2, "WEP_NO_PICKUP")

-- Physics
DefineFlag("SF_PHYSPROP_PREVENT_PICKUP", 512, "PROP_NO_PICKUP")