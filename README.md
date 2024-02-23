Required Addons :https://github.com/kac5a/k5_skillcheck

How to install Icons 

copy files from icons and place inside of ox_inventory\web\images

open ox_inventory\data\items.lua

paste --shear this line
	["pickaxe"] = {
		label = "Pickaxe",
		weight = 20,
		consume = 0.05,  --Change this to use as much as you want everyitme the player uses item 0.5 is half of its duability 
        stack = false,
        close = true,
		client = {
            export = "Mining.PerformMiningSkillChecks"  -- DO NOT CHANGE UNLESS YOU UNDERSTAND WHAT YOU ARE DOING
		},
	},

	["ruby"] = {
		label = "Ruby",
		weight = 10,
	},

	["gold"] = {
		label = "Gold",
		weight = 10,
	},
	["diamond"] = {
		label = "Diamond",
		weight = 10,
	},
	["copper"] = {
		labal = "Copper",
		weight = 15,
	}, 


how to install Mining script drag and drop mining folder into your resources folder and then in server.cfg paste 
ensure Mining

start up server and head to the mine and all should be good make sure you ensure k5 skill check before Mining it should look like this 

Ensure K9skillcheck
ensure Mining
