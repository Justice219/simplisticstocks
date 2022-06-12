AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("base/thirdparty/imgui.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props/cs_assault/billboard.mdl")

	self:SetSolid(SOLID_BBOX)
	self:SetHullSizeNormal()

end

function ENT:Use(activator, caller, useType, value)
    
end

function ENT:Think()
    
end