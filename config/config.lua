Config = {}

Config.Enable = true -- If true then soldier will spawn
Config.Target = 'ox_target' -- 'ox_target' or 'prompts' (When you are using prompts, then you will need lunar_bridge)
Config.progressPerBuy = 0.2 -- The progress per one weapon bought

Config.Location = {
    buyAccount = 'money',
    sellAccount = 'money',
    model = 's_m_y_blackops_01', -- The ped model
    locations = {
        vector4(660.8720, 1281.1411, 360.2959, 274.4451),
    },
    blip = {
        name = 'Corrupt soldier',
        sprite = 119,
        color = 40,
        scale = 0.7
    },
}

Config.Items = {
    { name = 'weapon_carbinerifle', price = 1250000, minLevel = 3 },
    { name = 'weapon_appistol', price = 850000, minLevel = 2 },
    { name = 'weapon_machinepistol', price = 500000, minLevel = 1 },
    { name = 'weapon_pumpshotgun', price = 1250000, minLevel = 3 },
    { name = 'at_clip_drum_rifle', price = 650000, minLevel = 2 },
}

Config.Sold = {
    ['WEAPON_MINISMG'] = { price = 500000 },
    ['WEAPON_ASSAULTRIFLE'] = { price = 1250000 },
    ['WEAPON_ASSAULTRIFLE_MK2'] = { price = 2000000 },
    ['WEAPON_CARBINERIFLE_MK2'] = { price = 2000000 },
    ['WEAPON_CARBINERIFLE'] = { price = 1000000 },
    ['WEAPON_MACHINEPISTOL'] = { price = 350000 },
    ['WEAPON_APPISTOL'] = { price = 750000 },
    ['WEAPON_MICROSMG'] = { price = 600000 },
    ['WEAPON_SMG'] = { price = 800000 },
    ['WEAPON_COMBATPDW'] = { price = 850000 },
    ['WEAPON_REVOLVER'] = { price = 700000 },
    ['WEAPON_DOUBLEACTION'] = { price = 450000 },
    ['WEAPON_PISTOL50'] = { price = 90000 },
    ['WEAPON_SNSPISTOL'] = { price = 50000 },
    ['WEAPON_PISTOL'] = { price = 60000 },
    ['WEAPON_HEAVYPISTOL'] = { price = 75000 },
    ['at_clip_drum_rifle'] = { price = 350000 },
}