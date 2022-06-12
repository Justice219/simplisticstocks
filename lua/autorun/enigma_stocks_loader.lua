if SERVER then
    art = [[
-------------------------------------------------------
SIMPLISTIC STOCKS WILL NOW BEGIN ITS LOADING PROCESS!!!  
           A System Created by Justice#4956
-------------------------------------------------------
    ]]
    MsgC(Color(0, 110, 255), art, "\n")

    include("base/debug/stocks_sv_errors.lua")
    include("base/db/stocks_sv_db.lua")
    include("base/stocks/stocks_sv_events.lua")
    include("base/stocks/stocks_sv_stocks.lua")
    include("base/config/stocks_sv_config.lua")
    include("base/config/events_sv_config.lua")
    include("base/stocks/stocks_sv_handler.lua")
    include("base/net/stocks_sv_net.lua")
    include("base/chat/stocks_sv_chat.lua")

    AddCSLuaFile("base/ui/stocks_ui_menu.lua")
    AddCSLuaFile("base/net/stocks_cl_net.lua")
end

if CLIENT then
    include("base/ui/stocks_ui_menu.lua")
    include("base/net/stocks_cl_net.lua")
end