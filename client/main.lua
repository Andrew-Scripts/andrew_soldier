if not Config.Enable then return end

---@param first { price: integer }
---@param second { price: integer }
local function sortByPrice(first, second)
    return first.price < second.price
end

table.sort(Config.Items, sortByPrice)
table.sort(Config.Sold, sortByPrice)

local function sell(weapon)
    local fish = Config.Sold[weapon]
    local heading = type(fish.price) == 'number' 
                    and locale('sell_weapon_heading', Utils.getItemLabel(weapon), fish.price)
                    or locale('sell_weapon_heading2', Utils.getItemLabel(weapon), fish.price.min, fish.price.max)
    local amount = lib.inputDialog(heading, {
        {
            type = 'number',
            label = locale('amount'),
            min = 1,
            required = true
        }
    })?[1] --[[@as number?]]

    if not amount then
        lib.showContext('sell_weapon')
        return
    end

    local success = lib.callback.await('andrew_soldier:sellWeapon', false, weapon, amount)

    if success then
        ShowProgressBar(locale('selling'), 3000, false, {
            dict = 'misscarsteal4@actor',
            clip = 'actor_berating_loop'
        })
        ShowNotification(locale('sold_weapon'), 'success')
    else
        ShowNotification(locale('not_enough_weapon'), 'error')
    end
end

local function sellWeapon()
    local options = {}

    for weaponName, weapon in pairs(Config.Sold) do
        if Framework.hasItem(weaponName) then
            table.insert(options, {
                title = Utils.getItemLabel(weaponName),
                ---@diagnostic disable-next-line: unused-function, param-type-mismatch
                description = type(weapon.price) == 'number' and locale('gun_price', weapon.price)
                            or locale('gun_price2', weapon.price.min, weapon.price.max),
                image = GetInventoryIcon(weaponName),
                onSelect = sell,
                price = type(weapon.price) == 'number' and weapon.price or weapon.price.min,
                args = weaponName
            })
        end
    end

    if #options == 0 then
        ShowNotification(locale('nothing_to_sell'), 'error')
        return
    end

    table.sort(options, function(a, b)
        return a.price < b.price
    end)

    lib.registerContext({
        id = 'sell_weapon',
        title = locale('sell_weapon'),
        menu = 'weaponman',
        options = options
    })

    Wait(60)

    lib.showContext('sell_weapon')
end

---@param data { type: string, index: integer }
local function buy(data)
    local type, index in data
    local item = Config[type][index]
    local amount = lib.inputDialog(locale('buy_heading', Utils.getItemLabel(item.name), item.price), {
        {
            type = 'number',
            label = 'Množství',
            min = 1,
            required = true
        }
    })?[1] --[[@as number?]]

    if not amount then
        lib.showContext('buy_weapons')
        return
    end

    local success = lib.callback.await('andrew_soldier:buy', false, data, amount)

    if success then
        ShowProgressBar(locale('buying'), 3000, false, {
            dict = 'misscarsteal4@actor',
            clip = 'actor_berating_loop'
        })
        ShowNotification(locale('bought_item'), 'success')
    else
        ShowNotification(locale('not_enough_' .. Config.Location.buyAccount), 'error')
    end
end

local function buyWeapon()
    local options = {}

    for index, weapon in ipairs(Config.Items) do
        table.insert(options, {
            title = Utils.getItemLabel(weapon.name),
            description = locale('weapon_price', weapon.price),
            image = GetInventoryIcon(weapon.name),
            disabled = weapon.minLevel > GetCurrentLevel(),
            onSelect = buy,
            args = { type = 'Items', index = index }
        })
    end

    lib.registerContext({
        id = 'buy_weapons',
        title = locale('buy_weapons'),
        menu = 'weaponman',
        options = options
    })

    Wait(60)

    lib.showContext('buy_weapons')
end

local function open()
    local level, progress = GetCurrentLevel(), GetCurrentLevelProgress() * 100
    
    lib.registerContext({
        id = 'weaponman',
        title = locale('weaponman'),
        options = {
            {
                title = locale('level', level),
                description = locale('level_desc', math.floor(100 - progress)),
                icon = 'chart-simple',
                progress = math.max(progress, 0.01),
                colorScheme = 'lime'
            },
            {
                title = locale('buy_weapons'),
                description = locale('buy_weapon_desc'),
                icon = 'dollar-sign',
                arrow = true,
                onSelect = buyWeapon
            },
            {
                title = locale('sell_weapon'),
                description = locale('sell_weapon_desc'),
                icon = 'person-rifle',
                arrow = true,
                onSelect = sellWeapon
            }
        }
    })

    lib.showContext('weaponman')
end

for _, coords in ipairs(Config.Location.locations) do
    if Config.Target == 'prompts' then
        Utils.createPed(coords, Config.Location.model, false)

        exports.lunar_bridge:addPoint({
            coords = coords, -- vector3
            distance = 1.0, -- the distance at which the becomes interactable
            options = {
                {
                    label = locale('open_weaponman'),
                    icon = 'comment',
                    onSelect = open
                }
            }
        })
    elseif Config.Target == 'ox_target' or 'ox-target' then
        Utils.createPed(coords, Config.Location.model, {
            {
                label = locale('open_weaponman'),
                icon = 'comment',
                onSelect = open
            }
        })
    else
        return
    end

    if Config.Location.blip then
        Utils.createBlip(coords, Config.Location.blip)
    end
end