RegisterServerEvent("miningGive")
AddEventHandler("miningGive", function(message)
    local NDCore = exports["ND_Core"]
    local player = NDCore:getPlayer(source)
    local source = source
    
    -- Define the three items with their corresponding probabilities
    local items = {
        {name = "ruby", chance = 10},        -- 50% chance
        {name = "gold", chance = 20},     -- 30% chance
        {name = "diamond", chance = 10}, 
        {name = "copper", chance = 60}  -- 20% chance
    }
    
    -- Generate a random number between 1 and the total of all chances
    local totalChances = 0
    for _, item in ipairs(items) do
        totalChances = totalChances + item.chance
    end
    
    local randomNum = math.random(1, totalChances)
    
    -- Determine which item corresponds to the random number
    local selectedItem
    local cumulativeChances = 0
    for _, item in ipairs(items) do
        cumulativeChances = cumulativeChances + item.chance
        if randomNum <= cumulativeChances then
            selectedItem = item.name
            break
        end
    end
    
    -- Add the selected item to the player's inventory
    exports.ox_inventory:AddItem(source, selectedItem, 1)
    
    print("Selected item: " .. selectedItem)
end)