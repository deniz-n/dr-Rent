----   ____    ____         ----
----  /\  _`\ /\  _`\       ----
----  \ \ \/\ \ \ \L\ \     ----
----   \ \ \ \ \ \ ,  /     ----
----    \ \ \_\ \ \ \\ \    ----
----     \ \____/\ \_\ \_\  ----
----      \/___/  \/_/\/ /  ----

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('dr:RentServer')
AddEventHandler('dr:RentServer', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)


    local getMoney = xPlayer.getMoney(Config.RentPrice)
    local gerekli = Config.RentPrice - getMoney
    
        if getMoney >= Config.RentPrice then
            xPlayer.removeMoney(Config.RentPrice)
            TriggerClientEvent('dr:RentClient', _source)
        else
            if Config.SendAlert then
                TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Yeterli Paran Yok Gerekli : '..gerekli.. ' $', length = 5000 })
            else
                TriggerClientEvent('mythic_notify:client:DoHudText', _source, { type = 'error', text = 'Yeterli Paran Yok Gerekli : '..gerekli.. ' $', length = 5000 })
            end
            return
        end
end)