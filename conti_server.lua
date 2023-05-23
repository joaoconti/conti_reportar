local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

conti = {}
Tunnel.bindInterface("conti_reportar", conti)

vRP.prepare("conti_reportar/vrp_user_identities", "SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
vRP.prepare("conti_reportar/vrp_user_ids", "SELECT identifier FROM vrp_user_ids WHERE user_id = @user_id")

function conti.report(id_quem_reportou, id_reportadado, motivo)
    local identidade = vRP.query("conti_reportar/vrp_user_identities", {
        user_id = id_reportadado
    })
    if #identidade >= 1 then
        local identidade = identidade[1]
        local informacoes = vRP.query("conti_reportar/vrp_user_ids", {
            user_id = id_reportadado
        })
        local embed = {{
            ["color"] = 16711680,
            ["fields"] = {{
                ["name"] = "> QUEM REPORTOU:",
                ["value"] = '',
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔹 **Id:** ' .. id_quem_reportou,
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔹 **Motivo:** ' .. motivo,
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔹 **Discord:** <@' .. string.gsub(
                    vRP.query("conti_reportar/vrp_user_ids", {
                        user_id = id_quem_reportou
                    })[1].identifier, "discord:", "") .. '>',
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '',
                ["inline"] = false
            }, {
                ["name"] = "> REPORTADO:",
                ["value"] = '',
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Nome:** ' .. ' ' .. identidade.name .. ' ' .. identidade.firstname,
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Id:** ' .. id_reportadado,
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Ip:** ' .. vRP.getPlayerEndpoint(id_reportadado),
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Steam:** ' .. string.gsub(informacoes[4].identifier, "steam:", ""),
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Licensa:** ' .. string.gsub(informacoes[2].identifier, "license:", ""),
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Xbox:** ' .. string.gsub(informacoes[3].identifier, "xbl:", ""),
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Live:** ' .. string.gsub(informacoes[4].identifier, "live:", ""),
                ["inline"] = false
            }, {
                ["name"] = "",
                ["value"] = '🔸 **Discord:** ' .. '<@' .. string.gsub(informacoes[1].identifier, "discord:", "") ..
                    '>',
                ["inline"] = false
            }}
        }}

        PerformHttpRequest(Config.webhook, function(err, text, headers)
        end, 'POST', json.encode({
            username = 'Reporte',
            embeds = embed
        }), {
            ['Content-Type'] = 'application/json'
        })
        return true
    else
        return false
    end
end

function conti.getPlayer()
    local source = source
    local user_id = vRP.getUserId(source)
    return user_id
end
