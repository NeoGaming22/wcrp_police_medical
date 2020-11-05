local VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

Inventory = exports.vorp_inventory:vorp_inventoryApi()



RegisterCommand('med', function(source, args, rawCommand)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    if job == 'medic' then
        TriggerClientEvent('police_medical:open', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, _U('no_autorizado'), 4000) -- from server side
    end
end)


RegisterCommand('med2', function(source, args, rawCommand)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    if job == 'police' then
        TriggerClientEvent('police_medical:open', _source)
    else
        TriggerClientEvent("vorp:TipBottom", _source, _U('no_autorizado'), 4000) -- from server side
    end
end)


RegisterServerEvent('police_medical:getjob')
AddEventHandler('police_medical:getjob', function(type)
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job = Character.job
    local count = Inventory.getItemCount(_source, "medicalcert")
    if count > 0 then
        TriggerClientEvent('police_medical:auth', _source, type)
    else
        TriggerClientEvent("vorp:TipBottom", source, 'You need a Medical Certificate, register in Saint Denis Doctor Office', 6000)    
    end
end)

RegisterServerEvent('police_medical:reviveplayer')
AddEventHandler('police_medical:reviveplayer', function(closestPlayer)
    local _source = source
    local count = Inventory.getItemCount(_source, "syringe")
    local count2 = Inventory.getItemCount(_source, "syringecert")
    if count > 0 and count2 > 0 then
        Inventory.subItem(_source, "syringe", 1)
        TriggerClientEvent('police_medical:revive', closestPlayer)
    else
        TriggerClientEvent("vorp:TipBottom", _source, _U('do_not_have', _U('syringe')), 3000)
    end
end)

RegisterServerEvent('police_medical:healplayer')
AddEventHandler('police_medical:healplayer', function(closestPlayer)
    local _source = source
    local count = Inventory.getItemCount(_source, "bandage")
    if count > 0 then
        Inventory.subItem(_source, "bandage", 1)
        TriggerClientEvent('police_medical:heal', closestPlayer)
    else
        TriggerClientEvent("vorp:TipBottom", _source, _U('do_not_have', _U('bandage')), 3000)
    end
end)

RegisterServerEvent('police_medical:takeItems')
AddEventHandler('police_medical:takeItems', function()
    local _source = source
    Inventory.addItem(_source, "bandage", Config.giveItemCount)
    Inventory.addItem(_source, "syringe", Config.giveItemCount)
    local count = Inventory.getItemCount(_source, "syringe")
    local count2 = Inventory.getItemCount(_source, "bandage")
    if count > 0 then 
        TriggerClientEvent("vorp:TipBottom", source, 'You took 10 Bandages and 10 Syringes from Cabinet', 3000)
    end


end)