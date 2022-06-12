include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.

surface.CreateFont( "jstock_shopnpc", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 50,
} )

surface.CreateFont( "jstock_shoptitle", {
	font = "Roboto", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 30,
} )
-- Fonts
function ENT:Draw()
	self:DrawModel()

	if (LocalPlayer():GetPos():Distance(self:GetPos()) < 250) then
		self:DrawInfo()
	end
end

function ENT:DrawInfo()
	local Pos = self:GetPos() + self:GetUp() * 80
	Pos = Pos + self:GetUp() * math.abs(math.sin(CurTime()) * 5)
	local Ang = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
	cam.Start3D2D(Pos, Ang, 0.1)
	draw.RoundedBox(6,-130,0,260,50,Color(36,35,35))
	draw.DrawText("Stockbroker", "jstock_shopnpc", 0, 0, Color(255, 255, 0), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

function ENT:DrawTranslucent()
	self:Draw()
end