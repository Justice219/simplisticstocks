include('shared.lua') -- At this point the contents of shared.lua are ran on the client only.
imgui = include("base/thirdparty/imgui.lua")

stocks = stocks or {}
stocks.client = stocks.client or {}
stocks.client.menus = stocks.client.menus or {}
stocks.client.data = stocks.client.data or {}
stocks.client.pdata = stocks.client.pdata or {}
stocks.client.sdata = stocks.client.sdata or {}
stocks.client.net = stocks.client.net or {}

-- Fonts
function ENT:Draw()
	self:DrawModel()

    if (LocalPlayer():GetPos():Distance(self:GetPos()) < 1000) then
        if imgui.Entity3D2D(self, Vector(3,0,31), Angle(0,90,90), 0.1) then

            -- Main UI
            draw.RoundedBox(6, -1150, -310, 2300, 1250, Color(31,30,30, 255))
            draw.SimpleText("Stock Market Board", imgui.xFont("!Roboto@150"),-550, -310, Color(255, 255, 255))

			-- Boxes
			draw.RoundedBox(6, -1100, -130, 500, 1000, Color(41,41,41, 255))
			draw.RoundedBox(6, -575, -130, 500, 1000, Color(41,41, 41,255))
			draw.RoundedBox(6, -50, -130, 1150, 1000, Color(41,41,41, 255))

			draw.SimpleText("Top Stocks", imgui.xFont("!Roboto@75"),-1010, -125, Color(255,255,0))
			draw.SimpleText("Your Stocks", imgui.xFont("!Roboto@75"),-500, -125, Color(255,255,0))
			draw.SimpleText("Dashboard", imgui.xFont("!Roboto@75"), 350, -125, Color(255,255,0))
			stocks.client.pdata[LocalPlayer():SteamID()] = stocks.client.pdata[LocalPlayer():SteamID()] or {}
			
			local sum = 0
			for k,v in pairs(stocks.client.pdata[LocalPlayer():SteamID()]) do
				sum = sum + v
			end
			draw.SimpleText("Stocks Owned - " .. sum, imgui.xFont("!Roboto@50"),0, 0, Color(255,255,255))
			draw.SimpleText("Use !stocks to open the stock menu!", imgui.xFont("!Roboto@50"),-310, -190, Color(255,255,255))

			local t = {}
			local i = 0
			for k,v in pairs(stocks.client.sdata) do
				if i != 10 then
					table.insert(t, #t, v)
					i = i + 1
				end
			end
			table.sort(t, function(a,b) return a.cost > b.cost end)
			for k, v in pairs(t) do
				draw.SimpleText(v.name .. " : ", imgui.xFont("!Roboto@50"),-1075, 0 + k * 75, Color(255,255,255))
				draw.SimpleText(v.cost, imgui.xFont("!Roboto@50"),-720, 0 + k * 75, Color(255,255,0))
			end

			local t2 = {}
			local i = 0
			for k,v in pairs(stocks.client.pdata[LocalPlayer():SteamID()]) do
				if i != 10 then
					table.insert(t2, #t2, k)
					i = i + 1
				end
			end
			table.sort(t2, function(a,b) print() return b > a end)
			for k, v in pairs(t2) do
				draw.SimpleText(v .. " : ", imgui.xFont("!Roboto@50"),-550, 0 + k * 75, Color(255,255,255))
				draw.SimpleText(stocks.client.pdata[LocalPlayer():SteamID()][v], imgui.xFont("!Roboto@50"),-200, 0 + k * 75, Color(255,255,0))
			end

            imgui.End3D2D()
        end
    end
end