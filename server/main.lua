math.randomseed(os.time())

---@param first { price: integer }
---@param second { price: integer }
local function sortByPrice(first, second)
    return first.price < second.price
end

table.sort(Config.Items, sortByPrice)
table.sort(Config.Sold, sortByPrice)


---@param source integer
---@param weapon string
---@param amount integer
lib.callback.register('andrew_soldier:sellWeapon', function(source, weapon, amount)
    local item = Config.Sold[weapon]
    local price = type(item.price) == 'number' and item.price or math.random(item.price.min, item.price.max)

    ---@cast price number

    if not item or amount <= 0 then return end

    local player = Framework.getPlayerFromId(source)
    
    if not player then return end
    
    if player:getItemCount(weapon) >= amount then
        SetTimeout(3000, function()
            if player:getItemCount(weapon) < amount then return end

            player:removeItem(weapon, amount)
            player:addAccountMoney(Config.Location.sellAccount, price * amount)
        end)

        return true
    end

    return false
end)

---@param source integer
---@param amount integer
lib.callback.register('andrew_soldier:buy', function(source, data, amount)
    local type, index in data

    local item = Config[type][index]
    local price = item.price * amount

    if not item or amount <= 0 then return end

    local player = Framework.getPlayerFromId(source)

    if not player then return end
    
    if player:getAccountMoney(Config.Location.buyAccount) >= price then
        SetTimeout(3000, function()            
            if player:getAccountMoney(Config.Location.buyAccount) < price then return end
            
            player:removeAccountMoney(Config.Location.buyAccount, price)
            player:addItem(item.name, amount)           
        end)
        
        AddPlayerLevel(player, Config.progressPerBuy)      
        return true
    end

    return false
end)