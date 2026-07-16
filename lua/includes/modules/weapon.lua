--- Copyright © 2026, YourLocalCappy, all rights deserved ---

_BASE_WEAPON = "weapon_hl2mpbase_scriptedweapon"

local table = table
local Warning = dbg and dbg.Warning or function() end

local Punch = ConVar("wpn_punch", "1", FCVAR.REPLICATED)

module("weapon", package.seeall)

local tWeapons = {}

local function buildFromTable(tWeapon, pPlayer)

  local P = tWeapon.Primary or {}
  local S = tWeapon.Secondary or {}

  tWeapon.printname        = tWeapon.PrintName
  tWeapon.viewmodel        = tWeapon.ViewModel
  tWeapon.playermodel      = tWeapon.WorldModel
  tWeapon.anim_prefix      = tWeapon.AnimPrefix
  tWeapon.bucket           = tWeapon.Slot
  tWeapon.bucket_position  = tWeapon.SlotPos

  tWeapon.clip_size        = P.ClipSize or -1
  tWeapon.default_clip     = P.DefaultClip or -1
  tWeapon.primary_ammo     = P.Ammo or "none"

  tWeapon.clip2_size       = S.ClipSize or -1
  tWeapon.default_clip2    = S.DefaultClip or -1
  tWeapon.secondary_ammo   = S.Ammo or "none"

  tWeapon.ShowUsageHint    = tWeapon.ShowHint
  tWeapon.BuiltRightHanded = tWeapon.IsRightHand
  tWeapon.AllowFlipping    = tWeapon.AllowFlip
  tWeapon.MeleeWeapon      = tWeapon.IsMelee


  if ( tWeapon.ShowHint == true ) then
     tWeapon.ShowHint = 1
  else
     tWeapon.ShowHint = 0
  end


  if ( tWeapon.AutoSwitchTo == true ) then
     tWeapon.AutoSwitchTo = 1
  else
     tWeapon.AutoSwitchTo = 0
  end


  if ( tWeapon.AutoSwitchFrom == true ) then
     tWeapon.AutoSwitchFrom = 1
  else
     tWeapon.AutoSwitchFrom = 0
  end


  if ( tWeapon.IsRightHand == true ) then
     tWeapon.IsRightHand = 1
  else
     tWeapon.IsRightHand = 0
  end


  if ( tWeapon.AllowFlip == true ) then
     tWeapon.AllowFlip = 1
  else
     tWeapon.AllowFlip = 0
  end


  if ( tWeapon.IsMelee == true ) then
     tWeapon.IsMelee = 1
  else
     tWeapon.IsMelee = 0
  end


  tWeapon.weight           = tWeapon.Weight or 0
  tWeapon.damage           = tWeapon.Damage or 0

  tWeapon.m_acttable       = tWeapon.Act
  tWeapon.item_flags       = tWeapon.Flags
  tWeapon.Flags            = tWeapon.ItemFlags

  local GetPunchScale = Punch:GetFloat()

  if ( tWeapon.UseIronSight == false ) then
	  pPlayer:ViewPunch(QAngle(-3.5,math.random(-0.2,0.2),0) * GetPunchScale)
  else
	  if ( tWeapon.UseIronSight == true ) then
			pPlayer:ViewPunch(QAngle(-2,math.random(-0.1,0.1),0) * GetPunchScale)
	  end
  end

  if P.Automatic == true then
     tWeapon.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.2
  end

  if S.Automatic == true then
     tWeapon.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.2
  end

  tWeapon.SoundData =
  {
     empty = tWeapon.Empty,
     single_shot = tWeapon.PrimarySound,
     special1 = tWeapon.SpecialSound
  }

  return true
end

function get(strClassname, visited)

  local tWeapon = tWeapons[strClassname]
  if not tWeapon then return nil end

  visited = visited or {}
  if visited[strClassname] then return nil end
  visited[strClassname] = true

  if table.copy then
    tWeapon = table.copy(tWeapon)
  end

  local tBase

  if tWeapon.__base and tWeapon.__base ~= strClassname then

    tBase = get(tWeapon.__base, visited)

    if not tBase then
      Warning('WARNING: Attempted to initialize weapon "' .. strClassname .. '" with non-existing base class!\n')
      return nil
    end

    if table.inherit then
      tWeapon = table.inherit(tWeapon, tBase)
    else
      for k,v in pairs(tBase) do
        if tWeapon[k] == nil then
          tWeapon[k] = v
        end
      end
    end

    if tBase.DrawLargeWeaponBox then
      tWeapon.DrawLargeWeaponBox = tBase.DrawLargeWeaponBox
    end

    if tBase.Think then
      tWeapon.Think = tBase.Think
    end

  end

  local built = buildFromTable(tWeapon)
  if not built then
    return nil
  end

  if not tWeapon.printname or not tWeapon.viewmodel then
    return nil
  end

  return tWeapon
end

function getweapons()
  return tWeapons
end

function register(tWeapon, strClassname, bReload)

  if not strClassname then return end

  if tWeapons[strClassname] and not bReload then
    return
  end

  if not tWeapon.__base then
    tWeapon.__base = _BASE_WEAPON
  end

  tWeapons[strClassname] = tWeapon
end