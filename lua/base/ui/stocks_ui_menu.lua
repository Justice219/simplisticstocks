stocks = stocks or {}
stocks.client = stocks.client or {}
stocks.client.menus = stocks.client.menus or {}
stocks.client.data = stocks.client.data or {}
stocks.client.pdata = stocks.client.pdata or {}

function stocks.client.menus.main()
    stocks.client.pdata[LocalPlayer():SteamID()] = stocks.client.pdata[LocalPlayer():SteamID()] or {}

    local frame = vgui.Create("jlib_frame")
    frame:ShowNavbar(true)
    frame:SetTitle("Stocks Menu")

    -- Setup our navbar
    frame.Navbar:AddButton("Dash", jlib.Colors.Primary, jlib.Icons.Info, function(pnl)
        pnl:Clear()

        local label = pnl:Add("DLabel")
        label:SetText("Stocks Dashboard")
        label:SetFont("jlib.font.title")
        label:SetTextColor(jlib.Colors.White)
        label:SetPos(jlib.Scaling.ScaleW(10), jlib.Scaling.ScaleH(5))
        label:SizeToContents()

        local dashboard = vgui.Create("jlib_table", pnl)
        dashboard:SetSize(pnl:GetWide(), pnl:GetTall())
        dashboard:SetPos(0,0)

        for k,v in pairs(stocks.client.pdata[LocalPlayer():SteamID()]) do
            dashboard:AddTableItem(k, {
                value = v,
            })
        end
        dashboard:Setup()
    end)
    frame.Navbar:AddButton("Buy", jlib.Colors.Primary, jlib.Icons.Buy, function(pnl)
        pnl:Clear()

        local sel = nil
        local num = 1

        local label = pnl:Add("DLabel")
        label:SetText("Buy Stocks")
        label:SetFont("jlib.font.title")
        label:SetTextColor(jlib.Colors.White)
        label:SetPos(jlib.Scaling.ScaleW(10), jlib.Scaling.ScaleH(5))
        label:SizeToContents()

        local buyPanel = vgui.Create("DPanel", pnl)
        buyPanel:SetSize(pnl:GetWide() - jlib.Scaling.ScaleW(30), jlib.Scaling.ScaleH(85))
        buyPanel:SetPos(jlib.Scaling.ScaleW(15), jlib.Scaling.ScaleH(185))
        buyPanel:TDLib()
        buyPanel:ClearPaint()
            :Background(jlib.Colors.Primary, 0)
            :Outline(jlib.Colors.White, 1)

        local stockName = buyPanel:Add("DLabel")
        stockName:SetText("Stock Name : Select a stock")
        stockName:SetFont("jlib.font.button")
        stockName:SetTextColor(jlib.Colors.White)
        stockName:Dock(TOP)
        stockName:DockMargin(5,5,5,5)
        stockName:SizeToContents()

        local stockPrice = buyPanel:Add("DLabel")
        stockPrice:SetText("Sell Price  : Select a stock")
        stockPrice:SetFont("jlib.font.button")
        stockPrice:SetTextColor(jlib.Colors.White)
        stockPrice:Dock(TOP)
        stockPrice:DockMargin(5,0,5,0)
        stockPrice:SizeToContents()

        local buyButton = buyPanel:Add("jlib_button")
        buyButton:Dock(BOTTOM)
        buyButton:DockMargin(5,5,5,5)
        buyButton:SetText("Buy")
        buyButton:SetFont("jlib.font.button")
        buyButton:Inverse()
        buyButton.DoClick = function()
            if !sel then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must select a stock first!")
            return end
            if !num or num == 0 then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must enter a number of stocks to buy!")
            return end

            net.Start("stocks_stocks_buy")
            net.WriteString(sel.name)
            net.WriteInt(tonumber(num), 32)
            net.SendToServer()
            frame:Remove()
        end

        local buyNumber = buyPanel:Add("jlib_entry")
        buyNumber:SetText("1")
        buyNumber:SetFont("jlib.font.button")
        buyNumber:SetTextColor(jlib.Colors.White)
        buyNumber:Dock(BOTTOM)
        buyNumber:DockMargin(5,5,5,5)
        buyNumber:SetUpdateOnType(true)
        buyNumber:InversePaint(true)
        function buyNumber:OnValueChange(val)
            local test = tonumber(val)
            if !test then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must enter a number!")    
            return end
            num = test
        end

        local buyList = vgui.Create("jlib_list", pnl)
        buyList:SetSize(pnl:GetWide() - jlib.Scaling.ScaleW(30), jlib.Scaling.ScaleH(150))
        buyList:SetPos(jlib.Scaling.ScaleW(15), jlib.Scaling.ScaleH(25))
        buyList:ShowListOutline(true, 1)
        buyList:ListRounded(false, 0)

        for k,v in pairs(stocks.client.sdata) do
            buyList:AddButton(v.name .. " : " .. v.cost, {
                buttonText = "Select",
                callback = function(button)
                    sel = v

                    stockName:SetText("Stock Name : " .. v.name)
                    stockPrice:SetText("Stock Price  : " .. v.cost)

                    chat.AddText(Color(255,255,0), "[Enigma Stocks]", Color(255,255,255), " Selected " .. v.name)
                end
            })
        end


        buyList:Setup()
    end)
    frame.Navbar:AddButton("Sell", jlib.Colors.Primary, jlib.Icons.Sell, function(pnl)
        pnl:Clear()

        local sel = nil
        local num = 1

        local label = pnl:Add("DLabel")
        label:SetText("Buy Stocks")
        label:SetFont("jlib.font.title")
        label:SetTextColor(jlib.Colors.White)
        label:SetPos(jlib.Scaling.ScaleW(10), jlib.Scaling.ScaleH(5))
        label:SizeToContents()

        local buyPanel = vgui.Create("DPanel", pnl)
        buyPanel:SetSize(pnl:GetWide() - jlib.Scaling.ScaleW(30), jlib.Scaling.ScaleH(85))
        buyPanel:SetPos(jlib.Scaling.ScaleW(15), jlib.Scaling.ScaleH(185))
        buyPanel:TDLib()
        buyPanel:ClearPaint()
            :Background(jlib.Colors.Primary, 0)
            :Outline(jlib.Colors.White, 1)

        local stockName = buyPanel:Add("DLabel")
        stockName:SetText("Stock Name : Select a stock")
        stockName:SetFont("jlib.font.button")
        stockName:SetTextColor(jlib.Colors.White)
        stockName:Dock(TOP)
        stockName:DockMargin(5,0,5,0)
        stockName:SizeToContents()

        local stockPrice = buyPanel:Add("DLabel")
        stockPrice:SetText("Stock Price : Select a stock")
        stockPrice:SetFont("jlib.font.button")
        stockPrice:SetTextColor(jlib.Colors.White)
        stockPrice:Dock(TOP)
        stockPrice:DockMargin(5,0,5,0)
        stockPrice:SizeToContents()

        local shares = buyPanel:Add("DLabel")
        shares:SetText("Shares Owned : Select a stock")
        shares:SetFont("jlib.font.button")
        shares:SetTextColor(jlib.Colors.White)
        shares:Dock(TOP)
        shares:DockMargin(5,0,5,0)
        shares:SizeToContents()

        local sellButton = buyPanel:Add("jlib_button")
        sellButton:Dock(BOTTOM)
        sellButton:DockMargin(5,5,5,5)
        sellButton:SetText("Sell")
        sellButton:SetFont("jlib.font.button")
        sellButton:Inverse()
        sellButton.DoClick = function()
            if !sel then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must select a stock first!")
            return end
            if !num or num == 0 then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must enter a number of stocks to buy!")
            return end

            net.Start("stocks_stocks_sell")
            net.WriteString(sel)
            net.WriteInt(tonumber(num), 32)
            net.SendToServer()
            frame:Remove()
        end

        local sellNumber = buyPanel:Add("jlib_entry")
        sellNumber:SetText("1")
        sellNumber:SetFont("jlib.font.button")
        sellNumber:SetTextColor(jlib.Colors.White)
        sellNumber:Dock(BOTTOM)
        sellNumber:DockMargin(5,5,5,5)
        sellNumber:SetUpdateOnType(true)
        sellNumber:InversePaint(true)
        function sellNumber:OnValueChange(val)
            local test = tonumber(val)
            if !test then
                chat.AddText(Color(255,255,0), "[Enigma Stocks]" , Color(255,255,255), " You must enter a number!")    
            return end
            num = test
        end

        local sellList = vgui.Create("jlib_list", pnl)
        sellList:SetSize(pnl:GetWide() - jlib.Scaling.ScaleW(30), jlib.Scaling.ScaleH(150))
        sellList:SetPos(jlib.Scaling.ScaleW(15), jlib.Scaling.ScaleH(25))
        sellList:ShowListOutline(true, 1)
        sellList:ListRounded(false, 0)

        for k,v in pairs(stocks.client.pdata[LocalPlayer():SteamID()]) do
            sellList:AddButton(k .. " : " .. v, {
                buttonText = "Select",
                callback = function(button)
                    sel = k
                    local stock = stocks.client.sdata[k]

                    stockName:SetText("Stock Name : " .. k)
                    stockPrice:SetText("Share Value  : " .. stock.cost)
                    shares:SetText("Shares Owned : " .. v)

                    chat.AddText(Color(255,255,0), "[Enigma Stocks]", Color(255,255,255), " Selected " .. k)
                end
            })
        end


        sellList:Setup()

    end)

    frame:Setup()
    frame.Navbar:SetTab(1)
end
    --[[local tabs = {}
    local data = {}
    local funcs = {}

    local function ScaleW(size)
        return ScrW() * size/1920
    end
    local function ScaleH(size)
        return ScrH() * size/1080        
    end

    surface.CreateFont("menu_title", {
        font = "Roboto",
        size = ScaleH(20),
        weight = 500,
        antialias = true,
        shadow = false
    })
    surface.CreateFont("menu_button", {
        font = "Roboto",
        size = ScaleH(22.5),
        weight = 500,
        antialias = true,
        shadow = false
    })

    local panel = vgui.Create("DFrame")
    panel:TDLib()
    panel:SetTitle("")
    panel:ShowCloseButton(false)
    panel:SetSize(ScaleW(960), ScaleH(540))
    panel:Center()
    panel:MakePopup()
    panel:ClearPaint()
        :Background(Color(40, 41, 40), 6)
        :Text("Enigma Stocks", "DermaLarge", Color(255,255,0), TEXT_ALIGN_LEFT, ScaleW(405), ScaleH(-240))
        --:Text("v1.0", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(5),ScaleH(250))
        :CircleHover(Color(59, 59, 59), 5, 20)

    local panel2 = panel:Add("DPanel")
    panel2:TDLib()
    panel2:SetPos(ScaleW(0), ScaleH(60))
    panel2:SetSize(ScaleW(1920), ScaleH(5))
    panel2:ClearPaint()
        :Background(Color(255, 255, 255), 0)
    local panel3 = panel:Add("DPanel")
    panel3:TDLib()
    panel3:SetPos(ScaleW(275), ScaleH(60))
    panel3:SetSize(ScaleW(5), ScaleH(1000))
    panel3:ClearPaint()
        :Background(Color(255, 255, 255), 0)    local panel3 = panel:Add("DPanel")
        panel3:TDLib()
        panel3:SetPos(ScaleW(275), ScaleH(60))
        panel3:SetSize(ScaleW(5), ScaleH(1000))
        panel3:ClearPaint()
            :Background(Color(255, 255, 255), 0)


    local close = panel:Add("DImageButton")
    close:SetPos(ScaleW(925),ScaleH(10))
    close:SetSize(ScaleW(20),ScaleH(20))
    close:SetImage("icon16/cross.png")
    close.DoClick = function()
        panel:Remove()
    end

    local scroll = panel:Add("DScrollPanel")
    scroll:SetPos(ScaleW(17.5), ScaleH(75))
    scroll:SetSize(ScaleW(240), ScaleW(425))
    scroll:TDLib()
    scroll:ClearPaint()
        --:Background(Color(0, 26, 255), 6)
        :CircleHover(Color(59, 59, 59), 5, 20)

    local function ChangeTab(name)
        print("Changing Tab")
        for k,v in pairs(data) do
            table.RemoveByValue(data, v)
            v:Remove()
            print("Removed")
        end

        local tbl = tabs[name]
        tbl.change()

    end
    
    local function CreateTab(name, tbl)
        local scroll = scroll:Add( "DButton" )
        scroll:SetText( name)
        scroll:Dock( TOP )
        scroll:SetTall( 50 )
        scroll:DockMargin( 0, 5, 0, 5 )
        scroll:SetTextColor(Color(255,255,255))
        scroll:TDLib()
        scroll:SetFont("menu_button")
        scroll:SetIcon(tbl.icon)
        scroll:ClearPaint()
            :Background(Color(59, 59, 59), 5)
            :BarHover(Color(255, 255, 255), 3)
            :CircleClick()
        scroll.DoClick = function()
            ChangeTab(name)
        end

        if tabs[name] then return end
        tabs[name] = tbl
    end
    CreateTab("Dashboard", {
        icon = "icon16/application_view_tile.png",
        change = function()
            local d = {}
            local p = nil
            local pdata = stocks.client.pdata[LocalPlayer():SteamID()] or {}
            local sowned = 0
            for k,v in pairs(pdata) do
                sowned = sowned + v
            end

            main = panel:Add("DPanel")
            main:SetPos(ScaleW(290), ScaleH(75))
            main:SetSize(ScaleW(660), ScaleH(455))
            main:TDLib()
            main:ClearPaint()
                :Background(Color(59, 59, 59), 6)
                :Text("Dashboard", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(255),ScaleH(-202.5))
            table.insert(d, #d, main)

            stockList = main:Add("DScrollPanel")
            stockList:SetPos(ScaleW(15), ScaleH(45))
            stockList:SetSize(ScaleW(250), ScaleH(400))
            stockList:TDLib()
            stockList:ClearPaint()
                :Background(Color(41,41,41), 6)

            infoPanel = main:Add("DPanel")
            infoPanel:SetPos(ScaleW(275), ScaleH(45))
            infoPanel:SetSize(ScaleW(365), ScaleH(400))
            infoPanel:TDLib()
            infoPanel:ClearPaint()
                :Background(Color(41,41,41), 6)
                :Text("Stocks Owned: " .. sowned, "menu_button", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(10),ScaleH(-180))

            for k,v in pairs(pdata) do
                local stock = stockList:Add("DButton")
                stock:SetText(k .. ": " .. v)
                stock:Dock( TOP )
                stock:SetTall( 50 )
                stock:DockMargin( 5, 5, 5, 5 )
                stock:SetTextColor(Color(255,255,255))
                stock:TDLib()
                stock:SetFont("menu_button")
                stock:SetIcon("icon16/application_view_tile.png")
                stock:ClearPaint()
                    :Background(Color(59, 59, 59), 5)
                    :BarHover(Color(255, 255, 255), 3)
            end




            for k,v in pairs(d) do
                table.insert(data, #data, v)
            end
        end
    })
    CreateTab("Buy", {
        icon = "icon16/cart_add.png",
        change = function()
            local d = {}
            local p = nil
            local sel = nil

            main = panel:Add("DPanel")
            main:SetPos(ScaleW(290), ScaleH(75))
            main:SetSize(ScaleW(660), ScaleH(455))
            main:TDLib()
            main:ClearPaint()
                :Background(Color(59, 59, 59), 6)
                :Text("Buy Stocks", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(250),ScaleH(-202.5))
            table.insert(d, #d, main)

            stockList = main:Add("DScrollPanel")
            stockList:SetPos(ScaleW(15), ScaleH(45))
            stockList:SetSize(ScaleW(250), ScaleH(400))
            stockList:TDLib()
            stockList:ClearPaint()
                :Background(Color(41,41,41), 6)

            infoPanel = main:Add("DPanel")
            infoPanel:SetPos(ScaleW(275), ScaleH(45))
            infoPanel:SetSize(ScaleW(365), ScaleH(400))
            infoPanel:TDLib()
            infoPanel:ClearPaint()
                :Background(Color(41,41,41), 6)

            selStock = infoPanel:Add("DLabel")
            selStock:SetPos(ScaleW(10), ScaleH(10))
            selStock:SetSize(ScaleW(350), ScaleH(30))
            selStock:SetText("Select a stock")
            selStock:SetFont("menu_button")

            ammountLabel = infoPanel:Add("DLabel")
            ammountLabel:SetPos(ScaleW(10), ScaleH(280))
            ammountLabel:SetSize(ScaleW(350), ScaleH(30))
            ammountLabel:SetText("Ammount to buy!")

            buyButton = infoPanel:Add("DButton")

            ammount = infoPanel:Add("DTextEntry")
            ammount:SetPos(ScaleW(10), ScaleH(310))
            ammount:SetSize(ScaleW(345), ScaleH(30))
            ammount:SetText("1")
            ammount:SetFont("menu_button")
            ammount:SetUpdateOnType(true)
            ammount.Paint = function(self, w, h)
                draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
                self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
            end
            ammount.OnValueChange = function(self)
                if !sel then return end
                local num = tonumber(self:GetValue())
                if !num then return end
                buyButton:SetText("Buy: " .. num * sel.cost)
            end

            buyButton:SetText("Buy")
            buyButton:SetTextColor(Color(255,255,255))
            buyButton:SetFont("menu_button")
            buyButton:SetPos(ScaleW(10), ScaleH(350))
            buyButton:SetSize(ScaleW(345), ScaleH(40))
            buyButton:TDLib()
            buyButton:ClearPaint()
                :Background(Color(59, 59, 59), 5)
                :BarHover(Color(41, 161, 47), 3)
            buyButton.DoClick = function()
                local num = tonumber(ammount:GetValue())
                if !num then
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You must enter a number!")   
                return end
                if !sel then
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You must select a stock!")
                return end
                net.Start("stocks_stocks_buy")
                net.WriteString(sel.name)
                net.WriteInt(tonumber(ammount:GetText()), 32)
                net.SendToServer()
                panel:Close()
            end

            for k,v in pairs(stocks.client.sdata) do
                local stock = stockList:Add("DButton")
                stock:SetText(v.name .. ": " .. v.cost)
                stock:Dock( TOP )
                stock:SetTall( 50 )
                stock:DockMargin( 5, 5, 5, 5 )
                stock:SetTextColor(Color(255,255,255))
                stock:TDLib()
                stock:SetFont("menu_button")
                stock:SetIcon("icon16/application_view_tile.png")
                stock:ClearPaint()
                    :Background(Color(59, 59, 59), 5)
                    :BarHover(Color(255, 255, 255), 3)
                stock.Think = function(self)
                    stock:TDLib()
                    stock:ClearPaint()
                    :Background(Color(59, 59, 59), 5)
                    :BarHover(Color(255, 255, 255), 3)
                    local stock = stocks.client.sdata[v.name]
                    self:SetText(stock.name .. ": " .. stock.cost)
                    if stock.up then
                        self:SetIcon("icon16/arrow_up.png")
                    else
                        self:SetIcon("icon16/arrow_down.png")
                    end
                end
                stock.DoClick = function()
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You have selected " .. v.name .. ".")
                    selStock:SetText("Selected: " .. v.name)
                    sel = v
                end
                stock:IsVisible(true)

            end

            for k,v in pairs(d) do
                table.insert(data, #data, v)
            end
        end
    })
    CreateTab("Sell", {
        icon = "icon16/cart_delete.png",
        change = function()
            local d = {}
            local p = nil

            local sel = nil

            main = panel:Add("DPanel")
            main:SetPos(ScaleW(290), ScaleH(75))
            main:SetSize(ScaleW(660), ScaleH(455))
            main:TDLib()
            main:ClearPaint()
                :Background(Color(59, 59, 59), 6)
                :Text("Sell Stocks", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(250),ScaleH(-202.5))
            table.insert(d, #d, main)

            stockList = main:Add("DScrollPanel")
            stockList:SetPos(ScaleW(15), ScaleH(45))
            stockList:SetSize(ScaleW(250), ScaleH(400))
            stockList:TDLib()
            stockList:ClearPaint()
                :Background(Color(41,41,41), 6)

            infoPanel = main:Add("DPanel")
            infoPanel:SetPos(ScaleW(275), ScaleH(45))
            infoPanel:SetSize(ScaleW(365), ScaleH(400))
            infoPanel:TDLib()
            infoPanel:ClearPaint()
                :Background(Color(41,41,41), 6)

            selStock = infoPanel:Add("DLabel")
            selStock:SetPos(ScaleW(10), ScaleH(10))
            selStock:SetSize(ScaleW(350), ScaleH(30))
            selStock:SetText("Select a stock")
            selStock:SetFont("menu_button")

            selPrice = infoPanel:Add("DLabel")
            selPrice:SetPos(ScaleW(10), ScaleH(45))
            selPrice:SetSize(ScaleW(350), ScaleH(30))
            selPrice:SetText("Select a stock")
            selPrice:SetFont("menu_button")


            ammountLabel = infoPanel:Add("DLabel")
            ammountLabel:SetPos(ScaleW(10), ScaleH(280))
            ammountLabel:SetSize(ScaleW(350), ScaleH(30))
            ammountLabel:SetText("Ammount to sell!")

            buyButton = infoPanel:Add("DButton")

            ammount = infoPanel:Add("DTextEntry")
            ammount:SetPos(ScaleW(10), ScaleH(310))
            ammount:SetSize(ScaleW(345), ScaleH(30))
            ammount:SetText("1")
            ammount:SetFont("menu_button")
            ammount:SetUpdateOnType(true)
            ammount.Paint = function(self, w, h)
                draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
                self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
            end
            ammount.OnValueChange = function(self)
                if !sel then
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You must select a stock!")
                return end
                local num = tonumber(self:GetValue())
                if !num then return end
                local stock = stocks.client.sdata[sel]
                buyButton:SetText("Sell: " .. num * stock.cost)
            end

            buyButton:SetText("Sell")
            buyButton:SetTextColor(Color(255,255,255))
            buyButton:SetFont("menu_button")
            buyButton:SetPos(ScaleW(10), ScaleH(350))
            buyButton:SetSize(ScaleW(345), ScaleH(40))
            buyButton:TDLib()
            buyButton:ClearPaint()
                :Background(Color(59, 59, 59), 5)
                :BarHover(Color(41, 161, 47), 3)
            buyButton.DoClick = function()
                local num = tonumber(ammount:GetValue())
                if !num then
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You must enter a number!")   
                return end
                if !sel then
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You must select a stock!")
                return end
                net.Start("stocks_stocks_sell")
                net.WriteString(sel)
                net.WriteInt(tonumber(ammount:GetText()), 32)
                net.SendToServer()
                panel:Close()
            end

            for k,v in pairs(stocks.client.pdata[LocalPlayer():SteamID()]) do
                local stock = stockList:Add("DButton")
                stock:SetText(k .. ": " .. v)
                stock:Dock( TOP )
                stock:SetTall( 50 )
                stock:DockMargin( 5, 5, 5, 5 )
                stock:SetTextColor(Color(255,255,255))
                stock:TDLib()
                stock:SetFont("menu_button")
                stock:SetIcon("icon16/application_view_tile.png")
                stock:ClearPaint()
                    :Background(Color(59, 59, 59), 5)
                    :BarHover(Color(255, 255, 255), 3)
                stock.DoClick = function()
                    chat.AddText(Color(255,255,0), "[Stocks]", Color(255,255,255), " You have selected " .. k .. ".")
                    selStock:SetText("Selected: " .. k)
                    sel = k

                    local stockCompare = stocks.client.sdata[k]
                    selPrice:SetText("Share Price: " .. stockCompare.cost)
                    selPrice.Think = function(self)
                        local stock = stocks.client.sdata[k]
                        self:SetText("Share Price: " .. stock.cost)
                    end
                end

            end

            for k,v in pairs(d) do
                table.insert(data, #data, v)
            end
        end
    })
    if LocalPlayer():GetUserGroup() == "superadmin" then
        CreateTab("Config", {
            icon = "icon16/cog.png",
            change = function()
                local d = {}
                local p = nil
    
                config = panel:Add("DPanel")
                config:SetPos(ScaleW(290), ScaleH(75))
                config:SetSize(ScaleW(660), ScaleH(455))
                config:TDLib()
                config:ClearPaint()
                    :Background(Color(59, 59, 59), 6)
                    :Text("Addon Configuration", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(210),ScaleH(-202.5))
                table.insert(d, #d, config)
    
                infop = config:Add("DPanel")
                infop:SetPos(ScaleW(15), ScaleH(50))
                infop:SetSize(ScaleW(630), ScaleH(385))
                infop:TDLib()
                infop:ClearPaint()
                    :Background(Color(40,41,40), 5)
                    :Text("Information", "DermaLarge", Color(255, 255, 255), TEXT_ALIGN_LEFT, ScaleW(210),ScaleH(-202.5))
    
                r = infop:Add("DButton")
                r:SetText("Panel Rank Access")
                r:SetSize(ScaleW(600), ScaleH(50))
                r:SetPos(ScaleW(15), ScaleH(30))
                r:SetFont("menu_button")
                r:SetTextColor(Color(255,255,255))
                r:TDLib()
                r:ClearPaint()
                    :Background(Color(59, 59, 59), 5)
                    :BarHover(Color(255, 255, 255), 3)
                    :CircleClick()
                r.DoClick = function()
                    local j = {}
                    panel:Remove()
    
                    pop = vgui.Create("DFrame")
                    pop:SetSize(ScaleW(600), ScaleH(200))
                    pop:Center()
                    pop:ShowCloseButton(false)
                    pop:MakePopup()
                    pop:SetTitle("Job Access")
                    pop:TDLib()
                    pop:ClearPaint()
                        :Background(Color(40,41,40), 6)
                        :CircleHover(Color(59, 59, 59), 5, 20)
    
                    local close = pop:Add("DImageButton")
                    close:SetPos(ScaleW(575), ScaleH(15))
                    close:SetSize(ScaleW(20), ScaleH(20))
                    close:SetImage("icon16/cross.png")
                    close:TDLib()
                    close.DoClick = function()
    
                        pop:Remove()
                    end
    
                    local scroll = pop:Add("DScrollPanel")
                    scroll:SetPos(ScaleW(15), ScaleH(65))
                    scroll:SetSize(ScaleW(570), ScaleH(100))
                    scroll:TDLib()
                    scroll:ClearPaint()
                        :Background(Color(40,41,40), 5)
                        :CircleClick()
    
                    local entry = pop:Add("DTextEntry")
                    entry:SetPos(ScaleW(15), ScaleH(30))
                    entry:SetSize(ScaleW(500), ScaleH(30))
                    entry:SetFont("menu_button")
                    entry:SetText("Test")
                    entry:SetTextColor(Color(255,255,255))
                    entry.Paint = function(self, w, h)
                        draw.RoundedBox( 6, 0, 0, w, h, Color(59, 59, 59))
                        self:DrawTextEntryText(Color(255, 255, 255), Color(255, 0, 0), Color(255, 255, 255))
                    end
    
                    local button = pop:Add("DButton")
                    button:SetPos(ScaleW(510), ScaleH(30))
                    button:SetSize(ScaleW(80), ScaleH(30))
                    button:SetText("Add")
                    button:SetFont("menu_button")
                    button:SetTextColor(Color(255,255,255))
                    button:TDLib()
                    button:ClearPaint()
                        :Background(Color(59, 59, 59), 5)
                        :BarHover(Color(255, 255, 255), 3)
                        :CircleClick()
                    button.DoClick = function()
                        if entry:GetValue() == "" then return end
    
                        t = scroll:Add("DCheckBoxLabel")
                        t:Dock(TOP)
                        t:DockMargin(5,5,5,5)
                        t:SetTall(25)
                        t:SetText(entry:GetValue())
                        t:SetFont("menu_button")
                        t:SetTextColor(Color(255,255,255))
                        t:TDLib()
                        t:ClearPaint()
                            :Background(Color(59, 59, 59), 5)
                            :BarHover(Color(255, 255, 255), 3)
                            :CircleClick()
                        function t:OnChange(val)
                            if val then
                                j[entry:GetValue()] = true
                            else
                                j[entry:GetValue()] = false
                            end
                        end
                    end


                    finish = pop:Add("DButton")
                    finish:SetPos(ScaleW(15), ScaleH(175))
                    finish:SetSize(ScaleW(570), ScaleH(20))
                    finish:SetText("Finish")
                    finish:SetFont("menu_title")
                    finish:SetTextColor(Color(255,255,255))
                    finish:TDLib()
                    finish:ClearPaint()
                        :Background(Color(59, 59, 59), 5)
                        :BarHover(Color(255, 255, 255), 3)
                        :CircleClick()
                    finish.DoClick = function()
                        net.Start("GM2:Net:PanelAccess")
                        net.WriteTable(j)
                        net.SendToServer()
    
                        pop:Remove()
                    end
    
                    for k,v in pairs(gm.client.data.main.ranks) do
                        t = scroll:Add("DCheckBoxLabel")
                        t:Dock(TOP)
                        t:DockMargin(5,5,5,5)
                        t:SetTall(25)
                        t:SetText(k)
                        t:SetFont("menu_button")
                        t:SetTextColor(Color(255,255,255))
                        t:TDLib()
                        t:ClearPaint()
                            :Background(Color(59, 59, 59), 5)
                            :BarHover(Color(255, 255, 255), 3)
                            :CircleClick()
                        function t:OnChange(val)
                            if val then
                                j[k] = true
                            else
                                j[k] = false
                            end
                        end
    
                        if gm.client.data.main.ranks[k] then
                            t:SetChecked(true)
                        end
                    end
                end
    
                
    
                for k,v in pairs(d) do
                    table.insert(data, #data, v)
                end
            end
        })
    end

    ChangeTab("Dashboard")
end
concommand.Add("stocks_menu", stocks.client.menus.main)]]