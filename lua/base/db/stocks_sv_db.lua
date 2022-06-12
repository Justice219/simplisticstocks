stocks = stocks or {}
stocks.server = stocks.server or {}
stocks.server.db = stocks.server.db or {}
stocks.server.errors = stocks.server.errors or {}
stocks.server.data = stocks.server.data or {}
stocks.server.stocks = stocks.server.stocks or {}
stocks.server.net = stocks.server.net or {}

function stocks.server.db.query(query)
    gm.server.errors.debug("Query: " .. query)
    sql.Query(query)
end

function stocks.server.db.create(name, values)
    local str = ""
    local i = 0
    local max = table.maxn(values)
    for k,v in pairs(values) do
        -- the string needs to look something like id NUMBER, name TEXT
        i = i + 1
        if i == max then 
            str = str .. v.name .. " " .. v.type
        else
            str = str .. v.name .. " " .. v.type .. ", "
        end
    end

    sql.Query("CREATE TABLE IF NOT EXISTS " .. name .. " ( " .. str .. " )")
    stocks.server.errors.change("Created new DB table: " .. name)
    if !sql.LastError() then return end
    stocks.server.errors.change("Printing last SQL Error for debugging purposes, ")
    print(sql.LastError())
end

function stocks.server.db.remove(name)
    sql.Query("DROP TABLE " .. name)

    stocks.server.errors.change("Removed DB table: " .. name)
    if !sql.LastError() then return end
    stocks.server.errors.change("Printing last SQL Error for debugging purposes, ")
end

function stocks.server.db.updateSpecific(name, row, method, value, key)
    local data = sql.Query("SELECT " .. row .. " FROM " .. name .. " WHERE " .. method .. " = " ..sql.SQLStr(key).. ";")
    if (data) then
        sql.Query("UPDATE " .. name .. " SET " .. row .. " = " .. sql.SQLStr(value) .. " WHERE " .. method .. " = " ..sql.SQLStr(key).. ";")
    else
        sql.Query("INSERT INTO " .. name .. " ( "..method..", "..row.." ) VALUES( "..sql.SQLStr(key)..", "..sql.SQLStr(value).." );")
    end
end

function stocks.server.db.updateAll(name, row, value)
    stocks.server.errors.change("Updating all entries in DB table: " .. name)
    value = sql.SQLStr(value)
    local data = sql.Query("SELECT * FROM " .. name .. ";")
    if (data) then
        sql.Query("UPDATE " .. name .. " SET " .. row .. " = " .. value .. ";")
    else
        sql.Query("INSERT INTO " .. name .. " ( "..row.." ) VALUES( "..value.." )") 
    end
end

function stocks.server.db.load(name, method)
    local val = sql.QueryValue("SELECT * FROM " .. name .. " WHERE " .. method .. " = " .. sql.SQLStr(method) .. ";")
    if !val then
        stocks.server.errors.severe("Could not load data from DB table: " .. name .. " with method: " .. method)    
        return false
    else
        return val
    end
end

function stocks.server.db.loadSpecific(name, row, method, key)
    local val = sql.QueryValue("SELECT " .. row .. " FROM " .. name .. " WHERE " .. method .. " = " .. sql.SQLStr(key) .. ";")
    if !val then
        stocks.server.errors.severe("Could not load data from DB table: " .. name .. " with method: " .. method)    
        return false
    else
        return val
    end
end

function stocks.server.db.loadAll(name, row)
    local val = sql.QueryValue("SELECT "..row.." FROM " .. name .. ";")
    if !val then
        stocks.server.errors.severe("Could not load data from DB table: " .. name)    
        return false
    else
        return val
    end
end