--- Copyright © 2026, YourLocalCappy, all rights deserved ---

if not WeaponSound then
WeaponSound = {
EMPTY = 0,
SINGLE = 1,
WPN_DOUBLE = 2,
RELOAD = 3,
MELEE_MISS = 4,
MELEE_HIT = 5,
SPECIAL1 = 6,
SPECIAL2 = 7,
SPECIAL3 = 8
}
end

local function DoTrace(pPlayer, dist)

local start = pPlayer:EyePosition()

local forward = Vector()
pPlayer:EyeVectors(forward, nil, nil)

local finish = start + forward * (dist or 8192)

local tr = trace_t()

UTIL.TraceLine(
    start,
    finish,
    _E.MASK and _E.MASK.SHOT or 0,
    pPlayer,
    0,
    tr
)

return tr

end

SWEP.PrintName = "PHYSQUIRK"

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Slot = 0
SWEP.SlotPos = 1

SWEP.AnimPrefix = "physgun"

SWEP.Primary = {
ClipSize = -1,
DefaultClip = -1,
Ammo = "None"
}

SWEP.Secondary = {
ClipSize = -1,
DefaultClip = -1,
Ammo = "None"
}

SWEP.ShowHint = 0
SWEP.AutoSwitchTo = 1
SWEP.AutoSwitchFrom = 1
SWEP.IsRightHand = 1
SWEP.AllowFlip = 0
SWEP.IsMelee = 1
SWEP.Weight = 7

SWEP.Damage = 0
SWEP.Flags = 2

SWEP.PrimarySound = "Weapon_357.Single"
SWEP.Empty = "Weapon_Pistol.Empty"

SWEP.Act = {
{ ACT.MP_STAND_IDLE, ACT.HL2MP_IDLE_PHYSGUN, false },
{ ACT.MP_CROUCH_IDLE, ACT.HL2MP_IDLE_CROUCH_PHYSGUN, false },
{ ACT.MP_RUN, ACT.HL2MP_RUN_PHYSGUN, false },
{ ACT.MP_CROUCHWALK, ACT.HL2MP_WALK_CROUCH_PHYSGUN, false },
{ ACT.MP_ATTACK_STAND_PRIMARYFIRE, ACT.HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN, false },
{ ACT.MP_ATTACK_CROUCH_PRIMARYFIRE, ACT.HL2MP_GESTURE_RANGE_ATTACK_PHYSGUN, false },
{ ACT.MP_RELOAD_STAND, ACT.HL2MP_GESTURE_RELOAD_PHYSGUN, false },
{ ACT.MP_RELOAD_CROUCH, ACT.HL2MP_GESTURE_RELOAD_PHYSGUN, false },
{ ACT.MP_JUMP, ACT.HL2MP_JUMP, false }
}

function SWEP:Initialize()

    self.m_bReloadsSingly = false
    self.m_bFiresUnderwater = false

    self.HeldEntity = nil
    self.HoldDistance = 100
    self.Frozen = false
    self.StoredMoveType = nil

    self.GrabLocalPos = nil
    self.PhysBone = 0

end

function SWEP:PrimaryAttack()

    local tr = DoTrace(self:GetOwner())

    local ent = tr.m_pEnt

    if not IsValid(ent) then return end
    if ent:IsPlayer() then return end
    if tr:DidHitWorld() then return end

    local phys = ent:VPhysicsGetObject()

    if not IsValid(phys) then
        return
    end

    self.HeldEntity = ent
    self.StoredMoveType = ent:GetMoveType()

    self.HoldDistance =
        (tr.endpos - self:GetOwner():EyePosition()):Length()

    self.PhysBone = tr.physicsbone or 0

    local localPos = Vector()
    ent:WorldToEntitySpace(tr.endpos, localPos)
    self.GrabLocalPos = localPos

    self.Frozen = false

end

function SWEP:DropHeldEntity()

    if not IsValid(self.HeldEntity) then
        self.HeldEntity = nil
        return
    end

    self.HeldEntity:SetMoveType(self.StoredMoveType or 6)
    self.HeldEntity:SetAbsVelocity(Vector(0,0,0))
    self.HeldEntity:WakeRestingObjects()

    self.HeldEntity = nil
    self.StoredMoveType = nil
    self.GrabLocalPos = nil
    self.PhysBone = 0
    self.Frozen = false

end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()

    if not IsValid(self.HeldEntity) then return end

    self.Frozen = not self.Frozen

    if self.Frozen then
        self.StoredMoveType = self.HeldEntity:GetMoveType()
        self.HeldEntity:SetMoveType(0) -- MOVETYPE_NONE
        self.HeldEntity:SetAbsVelocity(Vector(0,0,0))
    else
        self.HeldEntity:SetMoveType(self.StoredMoveType or 6)
        self.HeldEntity:WakeRestingObjects()
    end

end

function SWEP:Holster()

    self:DropHeldEntity()

    return true
end

local function SafeNormalize(v)
    local len = v:Length()
    if len <= 0.001 then
        return Vector(0,0,0)
    end
    return v * (1 / len)
end

function SWEP:ItemPostFrame()

    local ply = self:GetOwner()

    if not IsValid(self.HeldEntity) then
        self.HeldEntity = nil
        return
    end

    local ent = self.HeldEntity

    if not IsValid(ent) then
        self.HeldEntity = nil
        return
    end

    if not ReturnFlags(ply.m_nButtons, IN.ATTACK) then

        self:DropHeldEntity()

        return
    end

    if self.Frozen then
        return
    end

    local forward = Vector()
    ply:EyeVectors(forward, nil, nil)

    local holdDistance = self.HoldDistance

    if ReturnFlags(ply.m_nButtons, IN.USE) then
       holdDistance = holdDistance + 64
    end

    local targetPos =
       ply:EyePosition() +
        forward * holdDistance

    local worldGrabPos = Vector()
    ent:EntityToWorldSpace(self.GrabLocalPos, worldGrabPos)

    local delta = targetPos - worldGrabPos

    if not IsValid(phys) then
       phys = ent:VPhysicsGetObject()
    end

    if not IsValid(phys) then
       self.HeldEntity = nil
       return
    end

    local len = delta:Length()

    if len > 140 then
       self.HeldEntity = nil
       return
    end

    delta:Normalize()

    local mass = phys:GetMass()

    if mass <= 0 then
       mass = 10
    end

    local velocity =
       phys:GetVelocity() -
       ply:GetAbsVelocity()

    local force =
       (delta * len - velocity / 20) * mass

    if force:Length() > 5000 then
       self.HeldEntity = nil
       return
    end

    local grabPos = Vector()
    ent:EntityToWorldSpace(self.GrabLocalPos, grabPos)

    phys:ApplyForceOffset(force, grabPos)
    phys:ApplyForceCenter(Vector(0, 0, mass))

    ent:SetLocalAngularVelocity(
        ent:GetLocalAngularVelocity() +
        (-ent:GetLocalAngularVelocity() / 10)
        )

    ent:WakeRestingObjects()

end

function SWEP:Think()
end

function SWEP:CanHolster()
    return true
end

function SWEP:GetDrawActivity()
    return ACT.VM_DRAW
end

function SWEP:ItemBusyFrame()
end

function SWEP:DoImpactEffect()
end
