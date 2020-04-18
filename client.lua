print("test")

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

function alert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        for i = 1, #v.LocationPos, 1 do

            local hash = GetHashKey("s_m_y_uscg_01")
            while not HasModelLoaded(hash) do
                RequestModel(hash)
                Wait(20)
            end

            ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_uscg_01", v.LocationPos[i].x, v.LocationPos[i].y, v.LocationPos[i].z, v.LocationPos[i].angle, false, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
        end

    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Zones) do
        for i = 1, #v.LocationPos, 1 do
            local blip = AddBlipForCoord(v.LocationPos[i].x, v.LocationPos[i].y, v.LocationPos[i].z)

            SetBlipSprite (blip,427)
            SetBlipScale  (blip, 0.7)
            SetBlipColour (blip, 3)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName('Location Maritime')
            EndTextCommandSetBlipName(blip)
         end
     end
end)

_menuPool = NativeUI.CreatePool()
locationmenu = NativeUI.CreateMenu("Location Maritime","~w~Bievenue à la ~r~Location Maritime ~w~!")
_menuPool:Add(locationmenu)

function AddLocationMenu(menu)

    local jetmenu = _menuPool:AddSubMenu(menu, "Jet-Ski", "Appuyez sur ~y~[ENTRER] ~w~pour voir les ~b~Jet-Ski~w~.")
    jetmenu.Item:RightLabel("→→")

    local bateaumenu = _menuPool:AddSubMenu(menu, "Bateaux", "Appuyez sur ~y~[ENTRER] ~w~pour voir les ~b~Bateaux~w~.")
    bateaumenu.Item:RightLabel("→→")
    

    
    local jet = NativeUI.CreateItem("Jet-Ski", "Louer un ~b~Jet-Ski~w~.")
    jetmenu.SubMenu:AddItem(jet)
    jet:RightLabel("~g~550$")
    
    local bat = NativeUI.CreateItem("Bateau - Dinghy", "Louer un ~b~Bateau~w~.")
    bateaumenu.SubMenu:AddItem(bat)
    bat:RightLabel("~g~1500$")


    jetmenu.SubMenu.OnItemSelect = function(menu, item)
        if item == jet then
            TriggerServerEvent('Kaazy_LocationMaritime:buyJet')

            PlaySoundFrontend( -1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", 1)

            ESX.Game.SpawnVehicle('seashark', vector3(-1628.96, -1164.95, 0.98), 121.5, function(vehicle)
            end)

            ESX.ShowAdvancedNotification("Location Maritime", "Vous avez loué un ~b~Jet-Ski", "", "CHAR_BOATSITE", 1)

            Citizen.Wait(1)
    	end
    end
    
    bateaumenu.SubMenu.OnItemSelect = function(menu, item)
        if item == bat then
            TriggerServerEvent('Kaazy_LocationMaritime:buyBat')

            PlaySoundFrontend( -1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", 1)

            ESX.Game.SpawnVehicle('dinghy3', vector3(-1626.46, -1167.25, 0.55), 44.0, function(vehicle)
            end)

            ESX.ShowAdvancedNotification("Location Maritime", "Vous avez loué un ~b~Bateau", "", "CHAR_BOATSITE", 1)

            Citizen.Wait(1)
    	end
    end
        
end


AddLocationMenu(locationmenu)
_menuPool:RefreshIndex()




Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false)

        for k,v in pairs(Config.Zones) do

            for i = 1, #v.LocationPos, 1 do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.LocationPos[i].x, v.LocationPos[i].y, v.LocationPos[i].z, true)
                if distance < 2.2 then
                    alert('Appuyez sur ~INPUT_CONTEXT~ pour intéragir \navec ~b~Léo~w~.')
                    if IsControlJustPressed(1,51) then
                        locationmenu:Visible(not locationmenu:Visible())
                    end
                end
            end

        end
    end
end)
