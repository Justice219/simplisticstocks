ENT.Base = "base_ai" -- This entity is based on "base_ai"
ENT.Type = "ai" -- What type of entity is it, in this case, it's an AI.
ENT.Category = "Enigma Stock System"
ENT.PrintName = "Stockbroker"

ENT.Spawnable = true
ENT.AutomaticFrameAdvance = true -- This entity will animate itself.
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim ) -- This is called by the game to tell the entity if it should animate itself.
	self.AutomaticFrameAdvance = bUsingAnim
end

-- Since this file is ran by both the client and the server, both will share this information.