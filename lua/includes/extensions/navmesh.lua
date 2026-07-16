--- Copyright © 2026, YourLocalCappy, all rights deserved ---

math = math or {}

function math.Rand(min, max)
    if not min or not max then return 0 end
    if min > max then min, max = max, min end

    return min + (max - min) * math.random()
end

navmesh = {}
local areas = {}

local GRID_SIZE = 300

local function CreateGrid(min, max)
    local id = 1

    for x = min.x, max.x, GRID_SIZE do
        for y = min.y, max.y, GRID_SIZE do
            local nw = Vector(x, y, min.z)
            local se = Vector(x + GRID_SIZE, y + GRID_SIZE, max.z)

            local area = {
                id = id,
                nw = nw,
                se = se,
                adjacent = {}
            }

            areas[id] = area
            id = id + 1
        end
    end

    for i, a in pairs(areas) do
        a.adjacent = {}

        for j, b in pairs(areas) do
            if i ~= j then
                local dist = (GetCenter(a) - GetCenter(b)):Length()

                if dist <= GRID_SIZE * 1.5 then
                    table.insert(a.adjacent, b)
                end
            end
        end
    end
end

local function GetCenter(area)
    return Vector(
        (area.nw.x + area.se.x) * 0.5,
        (area.nw.y + area.se.y) * 0.5,
        (area.nw.z + area.se.z) * 0.5
    )
end

local function GetRandomPoint(area)
    return Vector(
        math.Rand(area.nw.x, area.se.x),
        math.Rand(area.nw.y, area.se.y),
        area.se.z
    )
end

function navmesh.GetNearestNavArea(pos)
    local best, bestDist

    for _, area in pairs(areas) do
        local d = (GetCenter(area) - pos):Length()

        if not best or d < bestDist then
            best = area
            bestDist = d
        end
    end

    return best
end

function GetAdjacentCount(area)
    return #area.adjacent
end

function GetAdjacentArea(area, i)
    return area.adjacent[i + 1]
end

function GetRandomPoint(area)
    return Vector(
        math.Rand(area.nw.x, area.se.x),
        math.Rand(area.nw.y, area.se.y),
        area.se.z
    )
end