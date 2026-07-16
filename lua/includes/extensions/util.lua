--- Copyright © 2026, YourLocalCappy, all rights deserved ---

if not UTIL then
   local UTIL = _G.UTIL or UTIL or _G.util or util or require("util") or require("UTIL") or {} or nil
end

function UTIL.AllPlayers()
    local players = {}
    local AllEnts = UTIL.EntitiesInSphere(32, Vector(0, 0, 0), 10000, 0)

    for _, ent in ipairs(AllEnts) do
        if ent:IsPlayer() then
            table.insert(players, ent)
        end
    end

    return players
end