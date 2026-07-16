--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local ModelList = {}
local ModelListRev = {}
local HandNames = {}

module("player_manager", package.seeall)

local playermodel = _G.playermodel or playermodel or require("playermodel") or {}

function AddValidModel(name, model)
    if not name or not model then return end

    ModelList[name] = model
    ModelListRev[string.lower(model)] = name

    playermodel.AddValidModel(name, model)
end

function AllValidModels()
    return ModelList
end

function TranslatePlayerModel(name)
    return ModelList[name] or playermodel.GetValidModel(name) or "models/player/kleiner.mdl"
end

function TranslateToPlayerModelName(model)
    model = string.lower(model or "")

    return ModelListRev[model] or "kleiner"
end

function AddValidHands(name, model, skin, body, matchBodySkin)
    HandNames[name] = {
        model = model,
        skin = skin or 0,
        body = body or "0000000",
        matchBodySkin = matchBodySkin or false
    }

    playermodel.AddValidHands(name, model, skin, body, matchBodySkin)
end

function TranslatePlayerHands(name)
    return HandNames[name] or playermodel.GetValidHands(name) or {
        model = "models/weapons/c_arms_citizen.mdl",
        skin = 0,
        body = "100000000"
    }
end

function Get(listid)
    local raw = playermodel.Dump()[listid]
    return raw and shallow_copy(raw) or {}
end

function GetForEdit(listid, nocreate)
    local data = playermodel.Dump()[listid]

    if not data and nocreate then
        return nil
    end

    if not data then
        playermodel.Exists(listid, "__init")
        data = playermodel.Dump()[listid]
    end

    return data
end

function Set(listid, key, value)
    local bucket = playermodel.Dump()[listid]

    if not bucket then
        bucket = {}
    end

    bucket[key] = value
    playermodel.Registry = playermodel.Registry or {}
    playermodel.Registry[listid] = bucket
end

--
AddValidModel( "alyx",			"models/player/alyx.mdl" )
AddValidHands( "alyx",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "barney",		"models/player/barney.mdl" )
AddValidHands( "barney",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "breen",			"models/player/breen.mdl" )
AddValidHands( "breen",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "charple",		"models/player/charple.mdl" )
AddValidHands( "charple",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )
--
AddValidModel( "chell",			"models/player/p2_chell.mdl" )
AddValidHands( "chell",			"models/weapons/c_arms_chell.mdl",			0, "0000000" )
--
AddValidModel( "corpse",		"models/player/corpse1.mdl" )
AddValidHands( "corpse",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )
--
AddValidModel( "combine",		"models/player/combine_soldier.mdl" )
AddValidHands( "combine",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "combineprison",	"models/player/combine_soldier_prisonguard.mdl" )
AddValidHands( "combineprison",	"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "combineelite",	"models/player/combine_super_soldier.mdl" )
AddValidHands( "combineelite",	"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "eli",			"models/player/eli.mdl" )
AddValidHands( "eli",			"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
--
AddValidModel( "gman",			"models/player/gman_high.mdl" )
AddValidHands( "gman",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "kleiner",		"models/player/kleiner.mdl" )
AddValidHands( "kleiner",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "monk",			"models/player/monk.mdl" )
AddValidHands( "monk",			"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "mossman",		"models/player/mossman.mdl" )
AddValidHands( "mossman",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "mossmanarctic",	"models/player/mossman_arctic.mdl" )
AddValidHands( "mossmanarctic",	"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "odessa",		"models/player/odessa.mdl" )
AddValidHands( "odessa",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "police",		"models/player/police.mdl" )
AddValidHands( "police",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "policefem",		"models/player/police_fem.mdl" )
AddValidHands( "policefem",		"models/weapons/c_arms_combine.mdl",		0, "0000000" )
--
AddValidModel( "magnusson",		"models/player/magnusson.mdl" )
AddValidHands( "magnusson",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "stripped",		"models/player/soldier_stripped.mdl" )
AddValidHands( "stripped",		"models/weapons/c_arms_hev.mdl",			2, "0000000" )
--
AddValidModel( "zombie",		"models/player/zombie_classic.mdl" )
AddValidHands( "zombie",		"models/weapons/c_arms_citizen.mdl",		2, "0000000" )
--
AddValidModel( "zombiefast",	"models/player/zombie_fast.mdl" )
AddValidHands( "zombiefast",	"models/weapons/c_arms_citizen.mdl",		2, "0000000" )
--
AddValidModel( "female01",		"models/player/Group01/female_01.mdl" )
AddValidHands( "female01",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female02",		"models/player/Group01/female_02.mdl" )
AddValidHands( "female02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female03",		"models/player/Group01/female_03.mdl" )
AddValidHands( "female03",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "female04",		"models/player/Group01/female_04.mdl" )
AddValidHands( "female04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "female05",		"models/player/Group01/female_05.mdl" )
AddValidHands( "female05",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "female06",		"models/player/Group01/female_06.mdl" )
AddValidHands( "female06",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "female07",		"models/player/Group03/female_01.mdl" )
AddValidHands( "female07",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female08",		"models/player/Group03/female_02.mdl" )
AddValidHands( "female08",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female09",		"models/player/Group03/female_03.mdl" )
AddValidHands( "female09",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "female10",		"models/player/Group03/female_04.mdl" )
AddValidHands( "female10",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "female11",		"models/player/Group03/female_05.mdl" )
AddValidHands( "female11",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "female12",		"models/player/Group03/female_06.mdl" )
AddValidHands( "female12",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
--
AddValidModel( "male01",		"models/player/Group01/male_01.mdl" )
AddValidHands( "male01",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "male02",		"models/player/Group01/male_02.mdl" )
AddValidHands( "male02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male03",		"models/player/Group01/male_03.mdl" )
AddValidHands( "male03",		"models/weapons/c_arms_citizen.mdl",		1, "0000000" )
AddValidModel( "male04",		"models/player/Group01/male_04.mdl" )
AddValidHands( "male04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male05",		"models/player/Group01/male_05.mdl" )
AddValidHands( "male05",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male06",		"models/player/Group01/male_06.mdl" )
AddValidHands( "male06",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male07",		"models/player/Group01/male_07.mdl" )
AddValidHands( "male07",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male08",		"models/player/Group01/male_08.mdl" )
AddValidHands( "male08",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "male09",		"models/player/Group01/male_09.mdl" )
AddValidHands( "male09",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "male10",		"models/player/Group03/male_01.mdl" )
AddValidHands( "male10",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "male11",		"models/player/Group03/male_02.mdl" )
AddValidHands( "male11",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male12",		"models/player/Group03/male_03.mdl" )
AddValidHands( "male12",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "male13",		"models/player/Group03/male_04.mdl" )
AddValidHands( "male13",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male14",		"models/player/Group03/male_05.mdl" )
AddValidHands( "male14",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male15",		"models/player/Group03/male_06.mdl" )
AddValidHands( "male15",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male16",		"models/player/Group03/male_07.mdl" )
AddValidHands( "male16",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male17",		"models/player/Group03/male_08.mdl" )
AddValidHands( "male17",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "male18",		"models/player/Group03/male_09.mdl" )
AddValidHands( "male18",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
--
AddValidModel( "medic01",		"models/player/Group03m/male_01.mdl" )
AddValidHands( "medic01",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "medic02",		"models/player/Group03m/male_02.mdl" )
AddValidHands( "medic02",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic03",		"models/player/Group03m/male_03.mdl" )
AddValidHands( "medic03",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
AddValidModel( "medic04",		"models/player/Group03m/male_04.mdl" )
AddValidHands( "medic04",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic05",		"models/player/Group03m/male_05.mdl" )
AddValidHands( "medic05",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic06",		"models/player/Group03m/male_06.mdl" )
AddValidHands( "medic06",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic07",		"models/player/Group03m/male_07.mdl" )
AddValidHands( "medic07",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic08",		"models/player/Group03m/male_08.mdl" )
AddValidHands( "medic08",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic09",		"models/player/Group03m/male_09.mdl" )
AddValidHands( "medic09",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic10",		"models/player/Group03m/female_01.mdl" )
AddValidHands( "medic10",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic11",		"models/player/Group03m/female_02.mdl" )
AddValidHands( "medic11",		"models/weapons/c_arms_refugee.mdl",		0, "0000000" )
AddValidModel( "medic12",		"models/player/Group03m/female_03.mdl" )
AddValidHands( "medic12",		"models/weapons/c_arms_refugee.mdl",		1, "0000000" )
AddValidModel( "medic13",		"models/player/Group03m/female_04.mdl" )
AddValidHands( "medic13",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic14",		"models/player/Group03m/female_05.mdl" )
AddValidHands( "medic14",		"models/weapons/c_arms_refugee.mdl",		0, "0100000" )
AddValidModel( "medic15",		"models/player/Group03m/female_06.mdl" )
AddValidHands( "medic15",		"models/weapons/c_arms_refugee.mdl",		1, "0100000" )
--
AddValidModel( "refugee01",		"models/player/Group02/male_02.mdl" )
AddValidHands( "refugee01",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee02",		"models/player/Group02/male_04.mdl" )
AddValidHands( "refugee02",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee03",		"models/player/Group02/male_06.mdl" )
AddValidHands( "refugee03",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
AddValidModel( "refugee04",		"models/player/Group02/male_08.mdl" )
AddValidHands( "refugee04",		"models/weapons/c_arms_citizen.mdl",		0, "0000000" )
--
AddValidModel( "magnusson",	"models/player/magnusson.mdl" )
AddValidHands( "magnusson",	"models/weapons/c_arms_citizen.mdl", 0, "0000000" )
AddValidModel( "skeleton",	"models/player/skeleton.mdl" )
AddValidHands( "skeleton",	"models/weapons/c_arms_citizen.mdl", 2, "0000000" )
AddValidModel( "zombine",	"models/player/zombie_soldier.mdl" )
AddValidHands( "zombine",	"models/weapons/c_arms_combine.mdl", 0, "0000000" )
--