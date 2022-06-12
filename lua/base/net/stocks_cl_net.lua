stocks = stocks or {}
stocks.client = stocks.client or {}
stocks.client.menus = stocks.client.menus or {}
stocks.client.data = stocks.client.data or {}
stocks.client.pdata = stocks.client.pdata or {}
stocks.client.sdata = stocks.client.sdata or {}
stocks.client.net = stocks.client.net or {}

function stocks.client.net.sync()
    net.Start("stocks_request_data")
    net.SendToServer()
end

net.Receive("stocks_request_data", function(len,ply)
    stocks.client.sdata = net.ReadTable()
    stocks.client.pdata = net.ReadTable()
end)

net.Receive("stocks_menus_main", function(len,ply)
    stocks.client.net.sync()
    timer.Simple(0.1, function()
        stocks.client.menus.main()
    end)
end)
net.Receive("stocks_chat_message", function(len, ply)
    local head = net.ReadString()
    local message = net.ReadString()
    chat.AddText(Color(255,255,0), "[Stock Event] ", head, ": ", Color(255,255,255), message)
end)