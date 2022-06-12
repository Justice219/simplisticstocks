AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/player/gman_high.mdl")

	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetHullType(HULL_HUMAN)
	self:SetUseType(SIMPLE_USE)
    self:SetAnimation(PLAYER_IDLE)

    self:CapabilitiesAdd(CAP_ANIMATEDFACE)
    self:CapabilitiesAdd(CAP_TURN_HEAD)

	self:DropToFloor()
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

end

function ENT:Use(activator, caller, useType, value)
    
end

function ENT:Think()
    
end