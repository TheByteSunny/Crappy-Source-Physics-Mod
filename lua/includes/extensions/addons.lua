--- Copyright © 2026, YourLocalCappy, all rights deserved ---

require("list")
if not list then return end

require("concommand")
require("filesystemtwo")

local _, dirs = file.Find("*", "ADDON")

for _, dir in ipairs(dirs) do
    list.Write("Addons", dir, {
        Addon = dir
    })
end

addons = list.Raw("Addons") or {}