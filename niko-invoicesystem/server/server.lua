local data = {
    exeid = nil,
    id = nil,
    price = nil,
}

ESX.RegisterServerCallback('niko-invoice-check-data', function(source, cb, playerID, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerID)
    local society = 'society_' .. xPlayer.job.name
    if xTarget == nil then
        xPlayer.showNotification(_U('not_player'))
    else
        data.exeid = source
        data.id = playerID
        data.price = price
        TriggerClientEvent('niko-close-invoicesystem', source)
        TriggerClientEvent('niko-open-invoicesystem', playerID, society)
    end
end)

ESX.RegisterServerCallback('niko-invoice-yes', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(data.id)
    local xPlayer2 = ESX.GetPlayerFromId(data.exeid)
    local embed = {
        ["color"] = 16335900,
        ["title"] = "System Faktur",
        ["description"] = "**OSOBA KTÓRA WYSTAWIŁA FAKTURE**\nNick Gracza: " .. GetPlayerName(data.exeid) .. "\nID Gracza: " .. data.exeid .. "\nSteam Hex: " .. GetPlayerIdentifier(data.exeid, 0) .. "\nLicencja Rockstar: " .. GetPlayerLicense(data.exeid) .. "\n\n**OSOBA KTÓRA OTRZYMAŁA FAKTURE**\nNick Gracza: " .. GetPlayerName(data.id) .. "\nID gracza: " .. data.id .. "\nSteam Hex: " .. GetPlayerIdentifier(data.id, 0) .. "\nLicencja Rockstar: " .. GetPlayerLicense(data.id) .. "\n\n**INFORMACJE DOTYCZĄCE FAKTURY**\nKwota Faktury: $" .. data.price,
    }

    if Config.PossibilityDebit then
        local account_bank = xPlayer.getAccount('bank')
        if account_bank.money > data.price then
            xPlayer2.showNotification(_U('acc_invoice'))
            xPlayer.showNotification(_U('acc2_invoice') ..data.price)
            xPlayer.removeAccountMoney('bank', data.price)
            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. xPlayer2.job.name, function(account)
                if account then
                    account.addMoney(data.price)
                else
                    print('Society named could not be detected society_' ..xPlayer2.job.name.. ' In database')
                end
            end)   
    
            PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = 'Niko - System Faktur', embeds = {embed}}), { ['Content-Type'] = 'application/json' })
        else
            xPlayer2.showNotification(_U('error_money'))
            xPlayer.showNotification(_U('error_money2'))
        end
    else
        xPlayer2.showNotification(_U('acc_invoice'))
        xPlayer.showNotification(_U('acc2_invoice') ..data.price)
        xPlayer.removeAccountMoney('bank', data.price)
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'.. xPlayer2.job.name, function(account)
            if account then
                account.addMoney(data.price)
            else
                print('Society named could not be detected society_' ..xPlayer2.job.name.. ' In database')
            end
        end)   

        PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({username = 'Niko - System Faktur', embeds = {embed}}), { ['Content-Type'] = 'application/json' })
    end
end)

ESX.RegisterServerCallback('niko-invoice-no', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(data.exeid)
    xPlayer.showNotification(_U('quit_invoice'))
end)

function GetPlayerLicense(source)
    for k,v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return ""
end