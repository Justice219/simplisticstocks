stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}
stocks.server.events = stocks.server.events or {}

MsgC(Color(255,255,255),"\n")
stocks.server.events.create("Wallstreet Bets", { // event name
    type = "boom", // crash, boom
    msg = "A random reddit pump and dump has occured!", // The message to display to the users
    max = 700, // Minimun a stock can drop too
})
stocks.server.events.create("Company Layoff", { // event name
    type = "crash", // crash, boom
    msg = "A company has layed off a portion of their supply force!", // The message to display to the users
    min = 100, // Minimun a stock can drop too
})
stocks.server.events.create("To The Moon!", { // event name
    type = "boom", // crash, boom
    msg = "Elon Musk has tweeted about this company!", // The message to display to the users
    max = 1000, // Minimun a stock can drop too
})