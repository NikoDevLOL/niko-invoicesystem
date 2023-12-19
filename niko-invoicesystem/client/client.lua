local invoiceSystem = function()
    local jobCheck = false
    for _, job in pairs(Config.AuthorizedJobs) do
        if ESX.PlayerData.job.name == job then
            jobCheck = true
        end
    end
    if jobCheck then
        SendNUIMessage({
            action = 'open',
        })
        SetNuiFocus(true, true)
    else
        ESX.ShowNotification(_U('error'))
    end
end

RegisterNuiCallback('error-notify', function()
    ESX.ShowNotification(_U('info'))
end)

RegisterNuiCallback('pressed-button-invoice', function(data)
    local playerID = data.idplayer
    local price = data.price
    ESX.TriggerServerCallback('niko-invoice-check-data', function(cb)
    end, playerID, price)
end)

RegisterNetEvent('niko-open-invoicesystem')
AddEventHandler('niko-open-invoicesystem', function(society)
    SendNUIMessage({
        action = 'openinvoice',
        jobname = society
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('niko-close-invoicesystem')
AddEventHandler('niko-close-invoicesystem', function()
    SendNUIMessage({
        action = 'close',
    })
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('invoice-accept', function()
    ESX.TriggerServerCallback('niko-invoice-yes', function(cb)
    end)
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('invoice-no-accept', function()
    ESX.TriggerServerCallback('niko-invoice-no', function(cb)
    end)
    SetNuiFocus(false, false)
end)

RegisterNuiCallback('close-esc', function()
    SetNuiFocus(false, false)
end)

exports('invoiceSystem', invoiceSystem)

RegisterCommand('testinvoice', function()
    exports['niko-invoicesystem']:invoiceSystem()
end)