--- Copyright © 2026, YourLocalCappy, all rights deserved ---

BasePlayer = _R.CBasePlayer

function LocalPlayer()
	if not _CLIENT then
		return UTIL.GetLocalPlayer()
	else
		return _R.CBasePlayer.GetLocalPlayer()
	end

   return _R.CBaseEntity
end

pPlayer = LocalPlayer()

player = player or {}

function player.GetAll(pPlayer)
pPlayer = pPlayer or LocalPlayer()

player = ToHL2MPPlayer(pPlayer)    

ply = player    
pPlayer = player    

return ply, pPlayer

end
