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

function stocks.server.events.create(name, tbl)
    stocks.server.edata[name] = {
        name = name,
        msg = tbl.msg,
        type = tbl.type,
        min = tbl.min or nil,
        max = tbl.max or nil,
        up = false,
    }
    stocks.server.errors.change("Event " .. name .. " created.")
end
