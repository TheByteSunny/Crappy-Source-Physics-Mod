--- Copyright © 2026, YourLocalCappy, all rights deserved ---

file = file or {}
fl = fl or {}

if not filesystem then
require("filesystem")
end

local BASE = "hl2sbr"

local ROOTS = {
MOD = BASE .. "/addons",
GAME = BASE,
LUA = BASE .. "/lua",
DATA = BASE .. "/data",
ADDON = MOD
}

local function list(path)
return io.popen('ls -1pa "' .. path:gsub('"', '\"') .. '"')
end

local function splitPattern(pattern)

    local dir, file = pattern:match("^(.*)/([^/]*)$")

    if not dir then
        dir = "."
        file = pattern
    end

    return dir, file

end

local function wildcardToLua(pattern)

    pattern = pattern:gsub("([%.%+%-%^%$%(%)%%])", "%%%1")

    pattern = pattern:gsub("%*", ".*")

    return "^" .. pattern .. "$"

end

local function findIn(path, filePattern)
local files, dirs = {}, {}
local handle = list(path)

if handle then    
    for line in handle:lines() do    
        if line ~= "." and line ~= ".." then    
            if line:sub(-1) == "/" then    
                dirs[#dirs + 1] = line:sub(1, -2)    
            else    
                if not filePattern or line:match(filePattern) then    
                    files[#files + 1] = line    
                end    
            end    
        end    
    end    
    handle:close()    
end    

return files, dirs

end

function fl.Find(pattern, root, sorting)
local base = ROOTS[root or "MOD"] or ROOTS.MOD

local subdir, filePattern = splitPattern(pattern)    
local fullPath = base .. "/" .. subdir    

local luaPattern = wildcardToLua(filePattern)    

local files, dirs = findIn(fullPath, luaPattern)    

if sorting == "nameasc" then    
    table.sort(files)    
    table.sort(dirs)    
elseif sorting == "namedesc" then    
    table.sort(files, function(a,b) return a > b end)    
    table.sort(dirs, function(a,b) return a > b end)    
end    

return files, dirs

end

function file.Find(pattern, path, sorting)
return fl.Find(pattern, path, sorting)
end

if not CompileString then

function CompileString(code, name, handleError)
local fn, err = loadstring(code, name)

if not fn then    
    if handleError == false then    
        return err    
    end    
    error(err)    
end    

return fn

end

end