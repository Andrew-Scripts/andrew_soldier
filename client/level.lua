local level = 1

---@param l number
local function updated(l)
    if not l then return end
    
    level = l
end

lib.callback('andrew_soldier:getLevel', false, updated)

RegisterNetEvent('esx:playerLoaded', function()
    lib.callback('andrew_soldier:getLevel', 100, updated)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    lib.callback('andrew_soldier:getLevel', 100, updated)
end)

RegisterNetEvent('andrew_soldier:updateLevel', updated)

function GetCurrentLevel()
    return math.floor(level)
end

function GetCurrentLevelProgress()
    return level - math.floor(level)
end