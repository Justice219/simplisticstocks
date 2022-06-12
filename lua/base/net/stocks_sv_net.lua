stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}
stocks.server.pdata = stocks.server.pdata or {}

util.AddNetworkString("stocks_request_data")
util.AddNetworkString("stocks_menus_main")
util.AddNetworkString("stocks_stocks_buy")
util.AddNetworkString("stocks_stocks_sell")
util.AddNetworkString("stocks_chat_message")

function stocks.server.net.broadcast(head, msg)
    net.Start("stocks_chat_message")
    net.WriteString(head)
    net.WriteString(msg)
    net.Broadcast()
end

net.Receive("stocks_request_data", function(len, ply)
    local server = stocks.server
    local stocks = server.data
    local pdata = server.pdata

    net.Start("stocks_request_data")
    net.WriteTable(stocks)
    net.WriteTable(pdata)
    net.Send(ply)
end)

net.Receive("stocks_stocks_buy", function(len, ply)
    local num = net.ReadInt(32)
    print(num)
    if num > 0 then
        ply:BuyStocks(net.ReadString(), num)
    end
end)
net.Receive("stocks_stocks_sell", function(len, ply)
    local num = net.ReadInt(32)
    if num > 0 then
        ply:SellStocks(net.ReadString(), num)
    end
end)