--- Copyright © 2026, YourLocalCappy, all rights deserved ---


-- only for the base scripted weapon
if not WeaponSound then
  WeaponSound = {
    EMPTY   = 0,
    SINGLE  = 1,
    WPN_DOUBLE = 2,
    RELOAD  = 3,
    MELEE_MISS = 4,
    MELEE_HIT = 5,
    SPECIAL1 = 6,
    SPECIAL2 = 7,
    SPECIAL3 = 8
  }
end

SWEP.PrintName = "[BASE] Scripted Weapon"

SWEP.ViewModel = "models/weapons/c_357.mdl"

SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Slot = 1

SWEP.SlotPos = 1


-- ammo
SWEP.Primary = {
    ClipSize    = 20,
    DefaultClip = 20,
    Ammo        = "357"
}

SWEP.Secondary = {
    ClipSize    = -1,
    DefaultClip = -1,
    Ammo        = "None"
}


-- general info
SWEP.ShowHint = 0
SWEP.AutoSwitchTo = 1
SWEP.AutoSwitchFrom = 1
SWEP.IsRightHand = 0
SWEP.AllowFlip = 1
SWEP.IsMelee = 0
SWEP.Weight = 7

Crosshair = false


-- useless but keep it here
SWEP.UseIcon = true


SWEP.Damage = 25

-- icon 
-- if you don't want custom icon you
-- can remove this so the icon will be
-- the default one
SWEP.Icon = {
    Texture = "weapons/swep",
    Color = Color(210,210,210,255),
    Width = 128,
    Height = 64
}

SWEP.IconSelected = {
    Texture = "weapons/swep",
    Color = Color(255,255,255,255),
    Width = 148,
    Height = 84
}

SWEP.Flags = 0 -- idc


-- sounds
SWEP.PrimarySound = "Weapon_357.Single"

SWEP.Empty = "Weapon_Pistol.Empty"


SWEP.Act = {
{ ACT.MP_STAND_IDLE, ACT.HL2MP_IDLE_REVOLVER, false },
{ ACT.MP_CROUCH_IDLE, ACT.HL2MP_IDLE_CROUCH_REVOLVER, false },
{ ACT.MP_RUN, ACT.HL2MP_RUN_REVOLVER, false },
{ ACT.MP_CROUCHWALK, ACT.HL2MP_WALK_CROUCH_REVOLVER, false },
{ ACT.MP_ATTACK_STAND_PRIMARYFIRE, ACT.HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, false },
{ ACT.MP_ATTACK_CROUCH_PRIMARYFIRE, ACT.HL2MP_GESTURE_RANGE_ATTACK_REVOLVER, false },
{ ACT.MP_RELOAD_STAND, ACT.HL2MP_GESTURE_RELOAD_REVOLVER, false },
{ ACT.MP_RELOAD_CROUCH, ACT.HL2MP_GESTURE_RELOAD_REVOLVER, false },
{ ACT.MP_JUMP, ACT.HL2MP_JUMP_REVOLVER, false },
}

function SWEP:Initialize()
  self.m_bReloadsSingly	= false
  self.m_bFiresUnderwater	= false
end

function SWEP:Precache()
end

function SWEP:PrimaryAttack()
local pPlayer = self:GetOwner()

if ( ToBaseEntity( pPlayer ) == NULL ) then
return
end

if ( self.m_iClip1 <= 0 ) then
if ( not self.m_bFireOnEmpty ) then
self:Reload()
else
self:WeaponSound( 0 )
self.m_flNextPrimaryAttack = 0.15
end

return

end

self:WeaponSound( WeaponSound.SINGLE )
pPlayer:DoMuzzleFlash()

self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
pPlayer:SetAnimation( PLAYER_ANIM.ATTACK )

self.m_flNextPrimaryAttack = gpGlobals.curtime() + 0.75
self.m_flNextSecondaryAttack = gpGlobals.curtime() + 0.75

self.m_iClip1 = self.m_iClip1 - 1

local vecSrc		= pPlayer:Weapon_ShootPosition()
local vecAiming		= pPlayer:GetAutoaimVector( AUTOAIM_5DEGREES )

local info = {
m_iShots = 1,
m_vecSrc = vecSrc,
m_vecDirShooting = vecAiming,
m_vecSpread = vec3_origin,
m_flDistance = MAX_TRACE_LENGTH,
m_iAmmoType = self.m_iPrimaryAmmoType
}

info.m_pAttacker = pPlayer

pPlayer:FireBullets( info )

local angles = pPlayer:GetLocalAngles()

angles.x = angles.x + random.RandomInt( -1, 1 )
angles.y = angles.y + random.RandomInt( -1, 1 )
angles.z = 0

if not _CLIENT then
pPlayer:SnapEyeAngles( angles )
end

pPlayer:ViewPunch( QAngle( -8, random.RandomFloat( -2, 2 ), 0 ) )

if ( self.m_iClip1 == 0 and pPlayer:GetAmmoCount( self.m_iPrimaryAmmoType ) <= 0 ) then
pPlayer:SetSuitUpdate( "!HEV_AMO0", 0, 0 )
end

end

function SWEP:SecondaryAttack()
  self.UseIronSight = true
end

function SWEP:Reload()
  self.UseIronSight = false
end

function SWEP:Think()
end

function SWEP:CanHolster()
end

function SWEP:GetDrawActivity()
return ACT.VM_DRAW
end

function SWEP:Holster()
  self.UseIronSight = false
end

function SWEP:ItemPostFrame()
end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end