stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.pdata = stocks.server.pdata or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}
stocks.server.events = stocks.server.events or {}
stocks.server.edata = stocks.server.edata or {}

hook.Add("PlayerSay", "StocksChat", function(ply, text)
    local cmd = string.Explode(" ", text)
    if cmd[1] == "!stocks" then
        print("ran")
        net.Start("stocks_menus_main")
        net.Send(ply)
        ply:JLIBSendNotification("Stocks", "Stocks menu has been opened.")
    elseif cmd[1] == "!stock_change" and ply:GetUserGroup() == "superadmin" then
        local args = string.Explode(" ", text)
        local stock = stocks.server.stocks.Find(args[2])
        if !stock then return end
        local amount = tonumber(args[3])
        if !amount then return end
        stock.cost = amount
        ply:JLIBSendNotification("Stocks", "Stock price has been changed.")
    elseif cmd[1] == "!stock_give" and ply:GetUserGroup() == "superadmin" then
        local args = string.Explode(" ", text)
        local ply2 = player.GetBySteamID(args[2])
        local stock = stocks.server.stocks.Find(args[3])
        local amm = tonumber(args[4])
        if !ply2 or !stock or !amm then return end
        stocks.server.pdata[ply2:SteamID()][stock.name] = amm
        ply:JLIBSendNotification("Stocks", "You have given someone"..amm.." "..stock.name..".")
    end
        
end)