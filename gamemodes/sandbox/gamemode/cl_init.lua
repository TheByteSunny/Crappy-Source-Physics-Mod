--- Copyright © 2026, YourLocalCappy, all rights deserved ---

include( "shared.lua" )
include( "function.lua" )

require("spaint")

Timer = require("timer")
Net = require("net")

spaint.CreateFont("TestFont", {
    font = "Roboto",
    size = 29,
    weight = 600,
    antialias = true,
    shadow = false
})

-- yep I'm making this the global think
hook.add( "Think", "TestHook", function()
  Timer.Check()
  Net.Tick()
end)

function GM:ActivateClientUI()
end

function GM:AdjustEngineViewport( x, y, width, height )
end

function GM:CanShowSpeakerLabels()
end

-- this one is useless
-- function GM:CreateDefaultPanels()
-- end

function GM:DrawHeadLabels( pPlayer )
end

function GM:GetPlayerTextColor( entindex, r, g, b )
end

function GM:HideClientUI()
end

function GM:HudViewportPaint( pElementName )
  hook.call("HudViewportPaint", nil, pElementName)
end

function GM:KeyInput( down, keynum, pszCurrentBinding )
end

function GM:LevelInitPreEntity()
end

function GM:LevelInitPostEntity()
end

function GM:OnScreenSizeChanged( iOldWide, iOldTall )
end

function GM:ShouldDrawCrosshair()
end

function GM:ShouldDrawDetailObjects()
end

function GM:ShouldDrawEntity( pEnt )
end

function GM:ShouldDrawFog()
end

function GM:ShouldDrawLocalPlayer()
   return true
end

function GM:ShouldDrawParticles()
end

function GM:ShouldDrawViewModel()
end
