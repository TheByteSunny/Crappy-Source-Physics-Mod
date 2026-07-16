include("shared.lua")

function SWEP:DrawLargeWeaponBox(bSelected, xpos, ypos, boxWide, boxTall, selectedColor, alpha)

    require("spaint") -- best module
    require("hook")

    i[[ force this here so that all SWEPs have icons ]]
    self.UseIcon = true

    i[[ can't have this running in server ]]
    if CLIENT then

    local defaultW = 128
    local defaultH = 64

    local tex
    local col
    local w
    local h

    if self.UseIcon == true or not self.UseIcon or not self.UseIcon == false then

    if self.Icon or self.IconSelected then
       local iconData = bSelected and self.IconSelected or self.Icon
       if not iconData then return end

       tex = iconData.Texture
       col = iconData.Color or Color(255,255,255,255)

       w = iconData.Width or defaultW
       h = iconData.Height or defaultH

    else
        return
    end

    end

    if tex == "weapons/swep_small" then
        w = defaultW
        h = defaultH
    end

    local x = xpos + (boxWide - w) / 2
    local y = ypos + (boxTall - h) / 2

    spaint.Texture({
        texture = tex or "weapons/swep_small",
        pos = { x, y },
        width = w,
        height = h,
        color = col
    })

   end

end

function SWEP:DrawModel(flags)
end

function SWEP:MuzzleFlash(pos1, angles, type, firstPerson)
end