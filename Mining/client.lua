-- Check if player is inside the Mine 
local InsideMine = false  


-- Define the coordinates for the box
local boxMin = vector3(2918.6270, 2786.0713, 39.6802)
local boxMax = vector3(2964.3083, 2799.7097, 45.1353)

-- Function to check if a player is inside the box
function IsPlayerInsideBox(playerId)
    local playerCoords = GetEntityCoords(GetPlayerPed(playerId))

    -- Check if the player's coordinates are within the defined box
    if playerCoords.x >= boxMin.x and playerCoords.x <= boxMax.x and
       playerCoords.y >= boxMin.y and playerCoords.y <= boxMax.y and
       playerCoords.z >= boxMin.z and playerCoords.z <= boxMax.z then
        return true -- Player is inside the box
    else
        return false -- Player is outside the box
    end
end

--[[ Function to draw the box on the screen
function DrawBoxOnScreen(minX, minY, minZ, maxX, maxY, maxZ, r, g, b, a)
    -- Draw the box using the DrawBox function
    DrawBox(minX, minY, minZ, maxX, maxY, maxZ, r, g, b, a)
end
--]]


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1200)

        local playerId = PlayerId()

        if IsPlayerInsideBox(playerId) then
         --Debug Only--   print("Player is inside the box.")
            InsideMine = true
        else
          --Debug Only --   print("Player is outside the box.")
            InsideMine = false
        end
    end
end)


-- Code For our animation

function PlayMiningAnimation()

    local ped = GetPlayerPed(-1)
    RequestAnimDict("random@domestic")
    while not HasAnimDictLoaded("random@domestic") do
        Citizen.Wait(100)
    end
   TaskPlayAnim((ped), 'random@domestic', 'pickup_low', 12.0, 12.0, -1, 80, 0, 0, 0, 0)
   SetEntityHeading(ped, 270.0)
end








--                   THIS IS USED IF THE SERVER IS USING INVENTORY SYSTEM ITEMS OX-INVENTORY                    -- 



-- Define the function
local isMiningCooldown = false
local isMiningInProgress = false
local useitemplease = false



local NDCore = exports["ND_Core"]

local player = NDCore:getPlayer(source)
local source = source



function PerformMiningSkillChecks()

    if InsideMine == false then
        useitemplease = false
        return
    end

    isMiningInProgress = true

    Citizen.Wait(1000)
    PlayMiningAnimation()

    if exports["k5_skillcheck"]:skillCheck("easy") then
        Citizen.Wait(5)
        PlayMiningAnimation()
        if exports["k5_skillcheck"]:skillCheck("normal") then
            Citizen.Wait(5)
            PlayMiningAnimation()
            if exports["k5_skillcheck"]:skillCheck("normal") then
                TriggerEvent('Mining:SuccessFunction') -- This is the event that happens if all 3
                
                                                        -- of the skill checks succeed
                                                        isMiningInProgress = false
                                                        useitemplease = true
                                                        

                -- Trigger the server event with a message
                triggerServerEventFromScript("Success: Mining skill checks passed!")
            else
                TriggerEvent('Mining:FailFunction1') -- This is the event that happens if
                                                      -- the user misses the 3rd skill check
                                                      isMiningInProgress = false
                                                      useitemplease = true

                -- Trigger the server event with a message

            
            end
        else
            TriggerEvent('Mining:FailFunction2') -- This is the event that happens if
                                                  -- the user misses the 2nd skill check
                                                  isMiningInProgress = false
                                                  useitemplease = true
            -- Trigger the server event with a message
        
        end
    else
        TriggerEvent('Mining:FailFunction3') -- This is the event that happens if
                                              -- the user misses the 1st skill check
                                              isMiningInProgress = false
                                              useitemplease = true
        -- Trigger the server event with a message
    
    end

end

function triggerServerEventFromScript(message)
    local success, error = pcall(function()
        TriggerServerEvent("miningGive", message)
    end)
    if not success then
        print("Error triggering miningGive event:", error)
    end
end

exports("PerformMiningSkillChecks", function(data, slot)
    local _, used = PerformMiningSkillChecks()


if useitemplease == true then 
    exports.ox_inventory:useItem(data)
end
end)


 -- local playerPed = GetPlayerPed(-1)  -- Get the player's ped





-------------------            THIS IS FOR OX-TARGET ---------- 

--[[
exports.ox_target:addBoxZone({
    coords = vec3(2951.9004, 2795.9575, 40.8942), -- this is the coords for mining
    size = vec3(50,50,23),
    rotation = 45,
    debug = drawZones,
 
        options = 
        {
        {
            name = 'box',
            event = 'PerformMiningSkillChecksEvent',
            icon = 'fa-solid fa-cube',
            label = ('Debug Box'),
            items = {['pickaxe'] =1}, --Item The person must have
        }
    }
})


RegisterNetEvent("PerformMiningSkillChecksEvent")

local isMiningCooldown = false
local isMiningInProgress = false

local NDCore = exports["ND_Core"]

local player = NDCore:getPlayer(source)
local source = source

AddEventHandler("PerformMiningSkillChecksEvent", function(data, slot)
    local _, used = PerformMiningSkillChecks()

    if isMiningInProgress == false then 
        exports.ox_inventory:useItem(items)
    end
end)

function PerformMiningSkillChecks()
    if isMiningInProgress then
        print("Mining is already in progress")
        return false
    end

    isMiningInProgress = true
    TriggerEvent('playAnimation', '_leadin_trevor', 'missmic1leadinoutmic_1_mcs_2')
    Citizen.Wait(1000)

    if exports["k5_skillcheck"]:skillCheck("easy") then
        Citizen.Wait(5)

        if exports["k5_skillcheck"]:skillCheck("normal") then
            Citizen.Wait(5)

            if exports["k5_skillcheck"]:skillCheck("normal") then
                TriggerEvent('Mining:SuccessFunction') -- This is the event that happens if all 3
                                                        -- of the skill checks succeed
                isMiningInProgress = false

                -- Trigger the server event with a message
                triggerServerEventFromScript("Success: Mining skill checks passed!")
            else
                TriggerEvent('Mining:FailFunction1') -- This is the event that happens if
                                                      -- the user misses the 3rd skill check
                isMiningInProgress = false

                -- Trigger the server event with a message
                triggerServerEventFromScript("Fail: Missed 3rd skill check!")
            end
        else
            TriggerEvent('Mining:FailFunction2') -- This is the event that happens if
                                                  -- the user misses the 2nd skill check
            isMiningInProgress = false

            -- Trigger the server event with a message
            triggerServerEventFromScript("Fail: Missed 2nd skill check!")
        end
    else
        TriggerEvent('Mining:FailFunction3') -- This is the event that happens if
                                              -- the user misses the 1st skill check
        isMiningInProgress = false

        -- Trigger the server event with a message
        triggerServerEventFromScript("Fail: Missed 1st skill check!")
    end
end

function triggerServerEventFromScript(message)
    local success, error = pcall(function()
        TriggerServerEvent("miningGive", message)
    end)
    if not success then
        print("Error triggering miningGive event:", error)
    end
end






--]]
