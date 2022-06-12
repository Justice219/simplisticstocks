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
stocks.server.handler = stocks.server.handler or {}

function stocks.server.handler.randomStock()
    local stock = table.Random(stocks.server.data)
    return stock
end
function stocks.server.handler.randomEvent()
    local event = table.Random(stocks.server.edata)
    return event
end
function stocks.server.handler.stockChange(stock)
    local flip = math.random(1,2)
    if flip == 1 then
        local random = math.random(1,10)
        local test = stock.cost + random
        if test < stock.max then
            stock.cost = stock.cost + random
            stock.up = true
        end
    else
        local random = math.random(1,10)
        local test = stock.cost - random
        if test > stock.min then
            stock.cost = stock.cost - random
            stock.up = false
        end
    end

    net.Start("stocks_request_data")
    net.WriteTable(stocks.server.data)
    net.WriteTable(stocks.server.pdata)
    net.Broadcast()
end

function stocks.server.handler.stockEvent(stock, event)
    local flip = math.random(1,2)
    if flip == 1 then
        local type = event.type
        if type == "crash" then
            local rand = math.random(stock.max, event.min)
            if stock.cost - rand < stock.min then
                stock.cost = stock.min
            else
                stock.cost = stock.cost - rand
            end
            for k,v in pairs(player.GetAll()) do
                stocks.server.net.broadcast(stock.name, "Is crashing! look bellow for details")
                stocks.server.net.broadcast(event.name, event.msg)
            end
        elseif type == "boom" then
            local rand = math.random(stock.min, event.max)
            if stock.cost + rand > stock.max then
                stock.cost = stock.max
            else
                stock.cost = stock.cost + rand
            end
            for k,v in pairs(player.GetAll()) do
                stocks.server.net.broadcast(stock.name, "Is booming! look bellow for details")
                stocks.server.net.broadcast(event.name, event.msg)
            end
        end

        net.Start("stocks_request_data")
        net.WriteTable(stocks.server.data)
        net.WriteTable(stocks.server.pdata)
        net.Broadcast()
    end
end

function stocks.server.handler.init()
    local stock = stocks.server.handler.randomStock()
    stocks.server.handler.stockChange(stock)

    local flip = math.random(1, 1000)
    if flip <= 5 then
        local event = stocks.server.handler.randomEvent()
        local stock = stocks.server.handler.randomStock()
        stocks.server.handler.stockEvent(stock,event)
    end
end

timer.Create("stocks.server.handler", 1, 0, stocks.server.handler.init)