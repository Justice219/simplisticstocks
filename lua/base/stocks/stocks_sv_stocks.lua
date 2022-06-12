stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.pdata = stocks.server.pdata or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}
stocks.server.events = stocks.server.events or {}

plyMeta = FindMetaTable("Player")
stocks.server.db.create("stocks_data", {
    [1] = {
        name = "stocks_tbl",
        type = "TEXT",
    }
})

function stocks.server.stocks.Create(name, data)
    stocks.server.data[name] = {
        name = name,
        id = #stocks.server.data + 1,
        cost = data.cost,
        min = data.min,
        max = data.max,
        limit = data.limit,
    }
    stocks.server.errors.change("Stock " .. name .. " created.")
end

function stocks.server.stocks.Find(name)
    if stocks.server.data[name] then
        return stocks.server.data[name]
    else
        print(name)
        stocks.server.errors.severe("Stock " .. name .. " not found.")
        return false
    end
end

function stocks.server.stocks.Remove(name)
    if stocks.server.data[name] then
        stocks.server.data[name] = nil
        stocks.server.errors.severe("Stock " .. name .. " removed.")
    else
        stocks.server.errors.severe("Stock " .. name .. " not found.")
        return false
    end
end

function plyMeta:BuyStocks(s, ammount)
    if stocks.server.stocks.Find(s) then
        local stock = stocks.server.stocks.Find(s)
        local ammount = tonumber(ammount) or 1
        if ammount > stock.limit then
            self:JLIBSendNotification("Stocks", "You can't buy more than " .. stock.limit .. " stocks of " .. stock.name .. ".")
        else
            local money = self:getDarkRPVar("money")
            local cost = ammount * stock.cost
            if money < cost then
                self:JLIBSendNotification("Stocks", "You don't have enough money to buy " .. ammount .. " stocks of " .. stock.name .. ".")
            else
                self:addMoney(-cost)
                local val = stocks.server.db.loadAll("stocks_data", "stocks_tbl")
                if val then
                    local tbl = util.JSONToTable(val)
                    tbl[self:SteamID()] = tbl[self:SteamID()] or {}
                    tbl[self:SteamID()][stock.name] = tbl[self:SteamID()][stock.name] or 0
                    tbl[self:SteamID()][stock.name] = tbl[self:SteamID()][stock.name] + ammount
                
                    stocks.server.pdata = tbl
                    stocks.server.db.updateAll("stocks_data", "stocks_tbl", util.TableToJSON(tbl))
                    stocks.server.errors.change(self:Nick() .. " bought " .. ammount .. " stocks of " .. stock.name .. ".")
                else
                    local tbl = {}
                    tbl[self:SteamID()] = {}
                    tbl[self:SteamID()][stock.name] = ammount

                    stocks.server.db.updateAll("stocks_data", "stocks_tbl", util.TableToJSON(tbl))
                    stocks.server.pdata = tbl
                    stocks.server.errors.change(self:Nick() .. " bought " .. ammount .. " stocks of " .. stock.name .. ".")
                end

                self:JLIBSendNotification("Stocks", "You bought " .. ammount .. " stocks of " .. stock.name .. " for " .. cost .. ".")
            end
        end
    else
        stocks.server.errors.severe("Stock " .. s .. " not found.")
    end
end

function plyMeta:SellStocks(s, ammount)
    if stocks.server.stocks.Find(s) then
        local stock = stocks.server.stocks.Find(s)
        local val = stocks.server.db.loadAll("stocks_data", "stocks_tbl")
        if val then
            local tbl = util.JSONToTable(val)
            local ammount = tonumber(ammount) or 1
            tbl[self:SteamID()] = tbl[self:SteamID()] or {}
            if !tbl[self:SteamID()][stock.name] then 
                self:JLIBSendNotification("Stocks", "You don't have any stocks of " .. stock.name .. ".")
            else
                if ammount > tbl[self:SteamID()][stock.name] then
                    self:JLIBSendNotification("Stocks", "You can't sell more than you have.")
                else
                    local money = self:getDarkRPVar("money")
                    local cost = ammount * stock.cost
                    self:addMoney(cost)
                    tbl[self:SteamID()][stock.name] = tbl[self:SteamID()][stock.name] - ammount
                    if tbl[self:SteamID()][stock.name] == 0 then
                        tbl[self:SteamID()][stock.name] = nil
                    end
                    stocks.server.db.updateAll("stocks_data", "stocks_tbl", util.TableToJSON(tbl))
                    stocks.server.pdata = tbl
                    stocks.server.errors.change(self:Nick() .. " sold " .. ammount .. " stocks of " .. stock.name .. " for " .. cost .. ".")
                    self:JLIBSendNotification("Stocks", "You sold " .. ammount .. " stocks of " .. stock.name .. " for " .. cost .. ".")
                end
            end
        else
           stocks.server.errors.severe("Stock data not found. If this happens something is totally broken.")
        end
    else
        stocks.server.errors.severe("Stock " .. stock .. " not found.")
    end
end

function plyMeta:GetStocks()
    return stocks.server.pdata[self:SteamID()]
end

hook.Add("PlayerSay", "StockChatCommands", function(ply, text)
    args = string.Explode(" ", text)
    if args[1] == "!buystocks" then
        args[1] = nil 
        ply:BuyStocks(args[2], args[3])
    elseif args[1] == "!sellstocks" then
        args[1] = nil 
        ply:SellStocks(args[2], args[3])
    elseif (args[1] == "!viewstocks") then
        local stocks = ply:GetStocks()
        if stocks then
            for k, v in pairs(stocks) do
                ply:JLIBSendNotification("Stocks", "Your stocks have been printed in chat!.")
                ply:PrintMessage(HUD_PRINTTALK, k .. ":" .. v)
            end
        else
            ply:JLIBSendNotification("Stocks", "You don't have any stocks.")
        end
    end
end)
hook.Add("PlayerInitialSpawn", "StockLoader", function(ply)
    local val = stocks.server.db.loadAll("stocks_data", "stocks_tbl")
    if val then
        local tbl = util.JSONToTable(val)
        stocks.server.pdata[ply:SteamID()] = tbl[ply:SteamID()] or {}
        stocks.server.errors.change(ply:Nick() .. " has joined the server. Stocks loaded.")
    end
end)
hook.Add("PlayerDisconnected", "StockDeLoader", function(ply)
    stocks.server.pdata[ply:SteamID()] = nil
    stocks.server.errors.normal(ply:Nick() .. " has disconnected. Deloaded their stocks.")
end)
concommand.Add("stocks_viewdata", function(ply, cmd, args)
    PrintTable(stocks.server.pdata)
end)