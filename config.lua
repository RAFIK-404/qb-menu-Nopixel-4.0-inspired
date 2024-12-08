local QBCore = exports['qb-core']:GetCoreObject()

local isJudge = false
local isPolice = false
local isTow = false
local isTaxi = false
local isMedic = false
local isDead = false
local myJob = "Unemployed"
local isHandcuffed = false
local hasOxygenTankOn = false
local bennyscivpoly = false
local onDuty = false
local inGarage = false
local inDepots = false

rootMenuConfig =  {
    {
        id = "blips",
        displayName = "GPS",
        icon = "#blips",
        enableMenu = function()
            local src = source
            local Player = QBCore.Functions.GetPlayerData(src)
            local inlaststand = Player.metadata["inlaststand"]
            local isdead = Player.metadata["isdead"]

            return not isdead and not inlaststand
        end,
        subMenus = { "blips:gasstations", --[["blips:trainstations",]] "blips:barbershop", "blips:tattooshop", "fk:karakol", "fk:hastane", "fk:galeri", "fk:motel"}
    },
    {
        id = "General",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            local src = source
            local Player = QBCore.Functions.GetPlayerData(src)
            local inlaststand = Player.metadata["inlaststand"]
            local isdead = Player.metadata["isdead"]

            return not inlaststand and not isdead
        end,
        subMenus = {"general:givenum", "drug:sell", "interact:carry"}
    },
    {
        id = "Interaction",
        displayName = "Interaction",
        icon = "#general",
        enableMenu = function()
            local src = source
            local Player = QBCore.Functions.GetPlayerData(src)
            local inlaststand = Player.metadata["inlaststand"]
            local isdead = Player.metadata["isdead"]

            return not isdead and not inlaststand
        end,
        
        subMenus = {"general:rob", "general:playerinvehicle", "general:playeroutvehicle", }
    },
	{   
        id = "Vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "carmenuevent",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), true))
        end
    },
    {
        id = "copDead",
         displayName = "11-A",
         icon = "#police-dead",
         functionName = "police:client:SendPoliceEmergencyAlert",
         enableMenu = function()
            local src = source
            local Player = QBCore.Functions.GetPlayerData(src)
            local inlaststand = Player.metadata["inlaststand"]
            local isdead = Player.metadata["isdead"]

            return isPolice and inlaststand and isdead -- and onDuty 
          end,
     },
    {
		id = "k9",
		displayName = "K9",
		icon = "#k9",
		enableMenu = function()
			local Player = QBCore.Functions.GetPlayerData()
			local inLastStand = Player.metadata["inlaststand"]
			local isDead = Player.metadata["isdead"]
			local isPolice = Player.job.name == "police"  -- Assuming the police job name is "police"

			-- Show the menu only if the player is police, not in last stand, and not dead
			return (isPolice and not inLastStand and not isDead)
		end,
		subMenus = {"k9:follow", "k9:vehicle",  "k9:sniffvehicle", "k9:huntfind", "k9:sit", "k9:stand", "k9:sniff", "k9:lay", }
    },
    {    
        id = "Police",
        displayName = "Police Interaction",
        icon = "#police-action",
        enableMenu = function()
			local Player = QBCore.Functions.GetPlayerData()
			local inLastStand = Player.metadata["inlaststand"]
			local isDead = Player.metadata["isdead"]
			local isPolice = Player.job.name == "police"  

			return (isPolice and not inLastStand and not isDead)
		end,
        subMenus = {"police:mdt", "general:cuff", "police:seizecash", "police:takedriverlicense", "police:statuscheck", "police:searchplayer", "police:jail", "police:clearcasings", "police:clearblood", "police:flagmenu" }
    },
    {    
        id = "PoliceObjects",
        displayName = "Police Objects",
        icon = "#police-action",
        enableMenu = function()
			local Player = QBCore.Functions.GetPlayerData()
			local inLastStand = Player.metadata["inlaststand"]
			local isDead = Player.metadata["isdead"]
			local isPolice = Player.job.name == "police"  

			return (isPolice and not inLastStand and not isDead)
		end,
        subMenus = {"police:spawn1", "police:spawn2", "police:spawn3", "police:spawn4", "police:spawn5", "police:spawn6", "police:del"}
        },
    {
		id = "Ambulance",
		displayName = "Ambulance",
		icon = "#hospital-amb",
		enableMenu = function()
			local Player = QBCore.Functions.GetPlayerData()
			local isMedic = Player.job.name == "ambulance"  -- Assuming the medic job name is "ambulance"
			local isDead = Player.metadata["isdead"]
			local onduty = Player.job.onduty

			-- Show the menu only if the player is a medic, alive, and on duty
			return (isMedic and not isDead and onduty)
		end,
		subMenus = {"medic:mdt", "medic:status", "medic:revive", "medic:treat", "medic:stretcherspawn", "medic:stretcherremove"}
	},
	{
		id = "Tow",
		displayName = "Tow",
		icon = "#tow-job",
		enableMenu = function()
			local src = source
			local Player = QBCore.Functions.GetPlayerData(src)
			local inlaststand = Player.metadata["inlaststand"]
			local isdead = Player.metadata["isdead"]

			return isTow and not isDead and onduty
		end,
		subMenus = {"tow:togglenpc", "tow:vehicle"}
	},
	{
		id = "Taxi",
		displayName = "Taxi",
		icon = "#tow-job",
		enableMenu = function()
			local src = source
			local Player = QBCore.Functions.GetPlayerData(src)
			local inlaststand = Player.metadata["inlaststand"]
			local isdead = Player.metadata["isdead"]

			return isTaxi and not isDead and onduty
		end,
		subMenus = {"taxi:npc", "taxi-meter", "taxi:startmeter"}
	},
	{    
		id = "Escort",
		displayName = "Escort",
		icon = "#general-escort",
		functionName = "police:client:EscortPlayer",
		enableMenu = function()
			local src = source
			local Player = QBCore.Functions.GetPlayerData(src)
			local inlaststand = Player.metadata["inlaststand"]
			local isdead = Player.metadata["isdead"]

			return not isdead and not inlaststand
		end
    },
    {
        id = "general:parkvehicle",
        displayName = "Park Vehicle",
        icon = "#general-parking",
        functionName = "qb-garages:putingarage",
        enableMenu = function()
            return (not isDead and inGarage and isCloseVeh() and not IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },
    {    
        id = "Emotes",
        displayName = "Emotes",
        icon = "#general-emotes",
        functionName = "elixir:emotes",
        -- eventType = "command",
        enableMenu = function()
            local src = source
            local Player = QBCore.Functions.GetPlayerData(src)
            local inlaststand = Player.metadata["inlaststand"]
            local isdead = Player.metadata["isdead"]

            return not isdead and not inlaststand 
        end
    },
    {
        id = "GiveKeys",
        displayName = "Give Keys",
        icon = "#general-keys-give",
        functionName = "qb-vehiclekeys:client:GiveKeys",
        enableMenu = function()
            return (isCloseVeh())
        end
    },
   {
    
        id = "general:depots",
        displayName = "Depots",
        icon = "#general-keys-give",
        functionName = "qb-garages:takeoutveh:depot",
        enableMenu = function()
            return (not isDead and inDepots and not IsPedInAnyVehicle(PlayerPedId(), false))
        end
    } -- add `,` after `}` if you gonna add new button but last button should ended w/o `,`

    -- NOTE
    -- for add a new function button to menu:
    -- {
    --     id = "generalgarage", -- type group id name, can be any name
    --     displayName = "Garage", -- Display Name
    --     icon = "#general-garage", -- Icon, should be with `#` cuz from HTML and check HTML for edits
    --     functionName = "qb-garages:takeout", -- THIS IS THE FUNCTION NAME THAT WILL BE TRIGGERED AFTER CLICKING THE BUTTON
    --     enableMenu = function()
    --         return (not isDead and inGarage and not isCloseVeh() and not IsPedInAnyVehicle(PlayerPedId(), false)) -- if person is dead or in vehicle. we don't want dead people to see this button if dead
    --     end
    -- }

    -- for open a new menu from the button:
    -- {
    --     id = "general", -- type group id name, can be any name
    --     displayName = "General", -- Display Name
    --     icon = "#globe-europe", -- Icon, should be with `#` cuz from HTML and check HTML for edits
    --     enableMenu = function()
    --         return not isDead -- if person is dead or in vehicle. we don't want dead people to see this button if dead
    --     end,
    --     subMenus = {"general:escort", "general:emotes", "general:putinvehicle", "general:unseatnearest"} -- add submenu names that will be shown after clicking General button
    -- }

    -- NOTE
    -- EXAMPLE:
    -- {
    --     id = "copDead",
    --     displayName = "11-A",
    --     icon = "#police-dead",
    --     enableMenu = function()
    --         return isPolice and isDead and onDuty -- here button checks if person is cop and dead and on duty. if 3 of them true then this will be shown
    --     end,
    --     subMenus = {"general:escort", "general:emotes", "general:putinvehicle", "general:unseatnearest"}
    -- }
}

newSubMenus = { -- NOTE basicly, what will be happen after clicking these buttons and icon of them
    ['general:givenum'] = {
        title = "Give contact",
        icon = "#contact-share",
        functionName = "qb-phone:client:GiveContactDetails" -- must be client event, work same as TriggerEvent('emotes:OpenMenu')
    }, 
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "elixir:exp1",
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "elixir:exp2",
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "elixir:exp3",
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "elixir:exp4",
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "elixir:exp5",
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "elixir:exp8",
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "elixir:exp9",
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "elixir:exp10",
    },
    ["expressions:mouthbreather"] = {
        title="Mouth Breather",
        icon="#expressions-mouthbreather",
        functionName = "elixir:exp11",
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "elixir:exp12",
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "elixir:exp13",
    },
    ["expressions:smug"]  = {
        title="smug",
        icon="#expressions-smug",
        functionName = "elixir:exp14",
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "elixir:exp15",
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "elixir:exp16",
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "elixir:exp17",
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "elixir:exp18",
    },
    ["expressions:weird2"]  = {
        title="Weird2",
        icon="#expressions-weird2",
        functionName = "elixir:exp19",
    },
    ['blips:gasstations'] = {
        title = "Gas Station",
        icon = "#blips-gasstations",
        functionName = "ygx:togglegas"
    },
   --[[ ['blips:trainstations'] = {
        title = "Tren istasyonları",
        icon = "#blips-trainstations",
        functionName = "Trains:ToggleTainsBlip"
    },--]]
    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "Garages:ToggleGarageBlip"
    },
    ['blips:barbershop'] = {
        title = "Barber",
        icon = "#blips-barbershop",
        functionName = "ygx:togglebarber"
    },
    ['fk:galeri'] = {
        title = "PDM",
        icon = "#blips-garages",
        functionName = "fk:galeri"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    ['animations:hurry'] = {
        title = "Hurry",
        icon = "#animation-swagger",
        functionName = "AnimSet:Hurry"
    },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },	
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Swag",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Gangster",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Sassy3",
        icon = "#animation-sassy",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "Sassy2",
        icon = "#animation-sassy",
        functionName = "AnimSet:ChiChi"
    },
    ['animations:default'] = {
        title = "Normal",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },
    ['general:rob'] = {
        title = "Rob",
        icon = "#steal",
        functionName = "police:client:RobPlayer" -- must be client event, work same as TriggerEvent('emotes:OpenMenu')
    },
    ['general:playerinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:client:PutPlayerInVehicle" -- must be client event, work same as TriggerEvent('emotes:OpenMenu')
    },
    ['general:playeroutvehicle'] = {
        title = "Unseat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:client:SetPlayerOutVehicle" -- must be client event, work same as TriggerEvent('emotes:OpenMenu')
    }, 
    ['drug:sell'] = {
        title = "Cornersell",
        icon = "#ped-sell-stolen-items",
        functionName = "qb-drugs:client:cornerselling"
    },
    ['general:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:client:CuffPlayer"
    },
    -- POLICE 
    ['police:statuscheck'] = {
        title = "Take Dna",
        icon = "#cocaine-status",
        functionName = "police:takedna"
    },
    ['police:searchplayer'] = {
        title = "Search player",
        icon = "#police-action-frisk",
        functionName = "police:client:RobPlayer"
    },
    ['police:jail'] = {
        title = "Jail Player",
        icon = "#heroin-lock-door",
        functionName = "police:client:JailPlayer"
    },
    ['police:seizecash'] = {
        title = "Seize Cash",
        icon = "#dollar-new",
        functionName = "police:client:SeizeCash"
    },
    ['police:bill'] = {
        title = "Bill",
        icon = "#general-cuff",
        functionName = "police:client:BillPlayer"
    },  
    ['police:mdt'] = {
        title = "MDT",
        icon = "#mdt",
        functionName = "mdt:client:OpenMDT"    
    },
	['police:clearcasings'] = {
        title = "Clear Casings",
        icon = "#clearcasings",
        functionName = "evidence:client:ClearCasingsInArea"    
    },
	['police:clearblood'] = {
        title = "Clear Blood",
        icon = "#clearblood",
        functionName = "evidence:client:ClearBlooddropsInArea"    
    },
	['police:flagmenu'] = {
        title = "Flag Plate",
        icon = "#flag",
        functionName = "police:openFlagPlateMenu"    
    },
    ['police:takedriverlicense'] = {
        title = "Revoke Drivers License",
        icon = "#driver-license",
        functionName = "police:client:SeizeDriverLicense"     
    },  
    -- POLICE
    ['police:spawn1'] = {
        title = "Cone",
        icon = "#triangle-exclamation",
        functionName = "police:client:spawnCone"     
    },   
	['police:spawn2'] = {
		title = "Gate",
		icon = "#torii-gate",
		functionName = "police:client:spawnBarrier" 
	},
	['police:spawn3'] = {
		title = "sign",
		icon = "#signs-post",
		functionName = "police:client:spawnRoadSign" 
	},
	['police:spawn4'] = {
		title = "Tent",
		icon = "#police-tent",
		functionName = "police:client:spawnTent" 
	},
	['police:spawn5'] = {
		title = "Lighting",
		icon = "#police-light",
		functionName = "police:client:spawnLight" 
	},
	['police:spawn6'] = {
		title = "Spike Strips",
		icon = "#road-spikes",
		functionName = "police:client:SpawnSpikeStrip" 
	},
    ['police:del'] = {
        title = "Remove object",
        icon = "#remove-str",
        functionName = "police:client:deleteObject"     
    },
    -- HOSPITAL
    ['medic:status'] = {
        title = "StatusCheck",
        icon = "#general-cuff",
        functionName = "hospital:client:CheckStatus" 
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#hospital-revivep",
        functionName = "hospital:client:RevivePlayer"
    },
    ['medic:treat'] = {
        title = "Heal wounds",
        icon = "#hospital-treat",
        functionName = "hospital:client:TreatWounds"
    },
    ['medic:stretcherspawn'] = {
        title = "Stretcher",
        icon = "#add-str",
        functionName = "hospital:client:TakeStretcher" 
    }, 
    ['medic:stretcherremove'] = {
        title = "Stretcher Remove",
        icon = "#remove-str",
        functionName = "hospital:client:RemoveStretcher" 
    }, 
	['medic:mdt'] = {
        title = "MDT",
        icon = "#mdt",
        functionName = "mdt:client:OpenMDT"    
    },--TOW --TOW
    ['tow:togglenpc'] = {
        title = "Toggle Npc",
        icon = "#tow-mission",
        functionName = "jobs:client:ToggleNpc"
    }, 
    ['tow:vehicle'] = {
        title = "Tow vehicle",
        icon = "#tow-tow",
        functionName = "qb-tow:client:TowVehicle"
    },  -- Taxi
    ['taxi-meter'] = {
        title = "Toggle Npc",
        icon = "#tow-mission",
        functionName = "qb-taxi:client:toggleMeter"
    }, 
    ['taxi:npc'] = {
        title = "Taxi mission",
        icon = "#tow-tow",
        functionName = "qb-taxi:client:DoTaxiNpc"
    },  
    ['taxi:startmeter'] = {
        title = "Start/Stop meter",
        icon = "#tow-tow",
        functionName = "qb-taxi:client:enableMeter"
    },
    ['k9:spawn'] = {
		title = "Summon",
		icon = "#k9-spawn",
		functionName = "K9:Create"
	},
	['k9:delete'] = {
		title = "Dismiss",
		icon = "#k9-dismiss",
		functionName = "K9:Delete"
	},
    ['k9:follow'] = {
        title = "Follow",
        icon = "#k9-follow",
        functionName = "elixir-k9:Follow"
    },
    ['k9:vehicle'] = {
        title = "Get In/Out",
        icon = "#k9-vehicle",
        functionName = "elixir-k9:EnterVeh"
    },
    ['k9:sit'] = {
        title = "Sit",
        icon = "#k9-sit",
        functionName = "elixir-k9:Sit"
    },
    ['k9:lay'] = {
        title = "Lay",
        icon = "#k9-lay",
        functionName = "elixir-k9:laydown"
    },
    ['k9:stand'] = {
        title = "Stand",
        icon = "#k9-stand",
        functionName = "elixir-k9:Follow"
    },
    ['k9:sniff'] = {
        title = "Sniff Person",
        icon = "#k9-sniff",
        functionName = "elixir-k9:searchdude"
    },
    ['k9:sniffvehicle'] = {
        title = "Sniff Vehicle",
        icon = "#k9-sniff-vehicle",
        functionName = "elixir-k9:searchcar"
    },
    ['k9:huntfind'] = {
        title = "Search Area",
        icon = "#k9-huntfind",
        functionName = "elixir-k9:searcharea"
    },
}
    

RegisterNetEvent("isJudge") -- these are all up to you and your job system, if person become Judge, script will see him as Judge too.
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff") -- opposite of the above
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("isTow") -- these are all up to you and your job system, if person become Judge, script will see him as Judge too.
AddEventHandler("isTow", function()
    isTow = true
end)

RegisterNetEvent("isTowOff") -- these are all up to you and your job system, if person become Judge, script will see him as Judge too.
AddEventHandler("isTowOff", function()
    isTow = false
end)

RegisterNetEvent("isTaxi") -- these are all up to you and your job system, if person become Judge, script will see him as Judge too.
AddEventHandler("isTaxi", function()
    isTaxi = true
end)

RegisterNetEvent("isTaxiOff") -- opposite of the above
AddEventHandler("isTaxiOff", function()
    isTaxi = false
end)

RegisterNetEvent("QBCore:Client:OnJobUpdate") -- dont edit this unless you don't use qb-core
AddEventHandler("QBCore:Client:OnJobUpdate", function(jobInfo)
    myJob = jobInfo.name
    if isMedic and myJob ~= "ambulance" then isMedic = false end
    if isPolice and myJob ~= "police" then isPolice = false end
    if isTow and myJob ~= "tow" then isTow = false end
    if isTaxi and myJob ~= "taxi" then isTaxi = false end
    if myJob == "police" then isPolice = true end
    if myJob == "tow" then isTow = true end
    if myJob == "taxi" then isTaxi = true end
    if myJob == "ambulance" then isMedic = true end
end)

RegisterNetEvent('QBCore:Client:SetDuty') -- dont edit this unless you don't use qb-core
AddEventHandler('QBCore:Client:SetDuty', function(duty)
    myJob = QBCore.Functions.GetPlayerData().job.name
    if isMedic and myJob ~= "ambulance" then isMedic = false end
    if isPolice and myJob ~= "police" then isPolice = false end
    if myJob == "police" then isPolice = true onDuty = duty end
    if myJob == "ambulance" then isMedic = true onDuty = duty end
end)

RegisterNetEvent('deathcheck') -- YOU SHOULD ADD THIS IN YOUR ambulancejob system, basically let the function trigger here when the ped playing anim and add this to
-- your revived function so everytime if person dies, this will be triggered to isDead = true, if he get revived this will be triggered to isDead = false
AddEventHandler('deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)


RegisterNetEvent("police:currentHandCuffedState") -- add this your police:client:GetCuffed @qb-policejob\client\interactions.lua
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed)
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank") -- add this to your oxygentank wear place, idk where is this for qb-inventory so find out please
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)


RegisterNetEvent('police:client:PutInVehicle')
AddEventHandler('police:client:PutInVehicle', function()
    if isEscorted then
    end
end)
