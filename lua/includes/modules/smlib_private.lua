--- Copyright © 2026, YourLocalCappy, all rights deserved ---

-- SpawnMenu Library (smlib)
-- only for Alpha 4.0+

-- just in case
local SERVER = not _CLIENT
local CLIENT = _CLIENT

if SERVER then
   return
end

module("smlib_Private", package.seeall)

local function resolvePath(p)
    local paths = {
        p,
        "hl2sbr/" .. p,
        "./" .. p
    }

    for _, test in ipairs(paths) do
        local f = io.open(test, "r")
        if f then
            f:close()
            return test
        end
    end

    return "hl2sbr/" .. p
end

local path = resolvePath("settings/entities_menu.kv")

local function readFile(p)
    local f = io.open(p, "r")
    if not f then return "" end
    local d = f:read("*all")
    f:close()
    return d
end

local function writeFile(p, d)
    local f = io.open(p, "w")
    if not f then return end
    f:write(d)
    f:close()
end

local function escape(s)
    return s:gsub('"', '\\"')
end

local function ensureBase(data)
    if data == "" or not data:find("SMenu%s*{") then
        return [[
SMenu
{
}
]]
    end
    return data
end

local function findBlockEnd(data, name)
    local start = data:find(name .. "%s*{")
    if not start then return nil end

    local i = start
    local level = 0
    local started = false

    while i <= #data do
        local c = data:sub(i, i)

        if c == "{" then
            level = level + 1
            started = true
        elseif c == "}" then
            level = level - 1
            if started and level == 0 then
                return i
            end
        end

        i = i + 1
    end

    return nil
end

function CreateTab(tab)
    tab = escape(tab)

    local data = readFile(path)
    local original = data
    data = ensureBase(data)

    if original ~= data then
        writeFile(path, data)
    end

    if data:find(tab .. "%s*{") then
        return
    end

    local finish = findBlockEnd(data, "SMenu")
    if not finish then return end

    local tabBlock =
        '\n    ' .. tab .. '\n' ..
        '    {\n' ..
        '    }\n'

    data =
        data:sub(1, finish - 1)
        .. tabBlock ..
        "\n" ..
        data:sub(finish)

    writeFile(path, data)
end

function CreateButton(tab, name, command)
    tab = escape(tab)
    name = escape(name)
    command = escape(command)

    local data = readFile(path)
    local original = data
    data = ensureBase(data)

    if original ~= data then
        writeFile(path, data)
    end

    if not data:find(tab .. "%s*{") then
        CreateTab(tab)
        data = readFile(path)
    end

    if data:find('"' .. name .. '"%s*{') then
        return
    end

    local finish = findBlockEnd(data, tab)
    if not finish then return end

    local button =
        '\n        "' .. name .. '"\n' ..
        '        {\n' ..
        '            "command" "' .. command .. '"\n' ..
        '        }\n'

    data =
        data:sub(1, finish - 1)
        .. button ..
        "\n" ..
        data:sub(finish)

    writeFile(path, data)
end