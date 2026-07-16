--- Copyright © 2026, YourLocalCappy, all rights deserved ---

require("smlib_Private")

smlib = {}

function smlib.CreateTab(tab)
  tab = tab or "Entities"

  smlib_Private.CreateTab(tab)
end

function smlib.CreateButton(tab, name, command)
  -- should I?
  if not tab or tab == "" then
     tab = "Unknown"
  end

  if not name or name == "" then
     name = "NoName"
  end

  if not commmand then
    return
  end

  local t = tab
  local n = name
  local cmd = command

  smlib_Private.CreateTab(t)
  smlib_Private.CreateButton(t, n, cmd)

  -- print("created " .. n .. "button in " .. t .. ".")

end
