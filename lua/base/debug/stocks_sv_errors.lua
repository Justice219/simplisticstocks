stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}

function stocks.server.errors.severe(message)
    MsgC(Color(0, 110, 255), "[STOCKS SEVERE] ", Color(255, 255, 255), message, "\n")
end
function stocks.server.errors.normal(message)
    MsgC(Color(0, 110, 255), "[STOCKS SYSTEM] ", Color(255, 255, 255), message, "\n")
end
function stocks.server.errors.debug(message)
    MsgC(Color(0, 110, 255), "[STOCKS DEBUG] ", Color(255, 255, 255), message, "\n")
end
function stocks.server.errors.change(message)
    MsgC(Color(0, 110, 255), "[STOCKS CHANGE] ", Color(255, 255, 255), message, "\n")
end