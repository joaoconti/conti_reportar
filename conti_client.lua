local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

conti = Tunnel.getInterface("conti_reportar")

local id_quem_reportou = nil

RegisterCommand(Config.comando, function()
    id_quem_reportou = GetPlayerServerId(PlayerId())
    ShowNui()
end)

RegisterNUICallback("botao", function(data, cb)
    if data.id ~= '' and data.desc ~= '' then
        if string.match(data.id, "^%d+$") ~= nil  then
            HideNui()
            if conti.report(id_quem_reportou,data.id,data.desc) then
                TriggerEvent("Notify","aviso","Sua denuncia foi enviada.",5000)
            end
        else
            TriggerEvent("Notify","aviso","O ID do jogador não é válido.",5000) 
            HideNui()
        end 
    else
        TriggerEvent("Notify","aviso","Você deve preencher todos os campos.",5000)
        HideNui()
    end
end)

function HideNui()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hide"
    })
end

function ShowNui()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "show"
    })
end