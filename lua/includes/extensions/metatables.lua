--- Copyright © 2026, YourLocalCappy, all rights deserved ---

local meta = getmetatable(Vector(0,0,0))

function meta:Normalize()
    local len = self:Length()

    if len <= 0 then
        return 0
    end

    self.x = self.x / len
    self.y = self.y / len
    self.z = self.z / len

    return len
end