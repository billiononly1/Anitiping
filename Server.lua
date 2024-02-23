if Cfg.Hp.Use then
    local PingLimit =  Cfg.Hp.limit
    local CheckInterval = Cfg.Hp.Interval * 60000
    local KickThreshold = Cfg.Hp.KickPeriod
  
    local ExemptPlayers = Cfg.Hp.Exempt
	local OnlineTimeBeforeCheck = Cfg.Hp.online * 60000
    local HighPingWebhookURL = Cfg.Hp.Discord.Webhook
    local HighPingCount = {}

    local function IsPlayerExempt(playerId)
        local playerIdentifier = GetPlayerIdentifier(playerId, 0)
        for _, exemptIdentifier in ipairs(ExemptPlayers) do
            if exemptIdentifier == playerIdentifier then
                return true
            end
        end
        return false
    end
    local function sendToDiscord(name, message, color)
        local embeds = {
            {
                ["title"] = name,
                ["description"] = message,
                ["type"] = "rich",
                ["color"] = color,
                ["footer"] = {
                    ["text"] = "High Ping Alert System"
                }
            }
        }
        PerformHttpRequest(HighPingWebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Server", embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end
    local function KickPlayer(playerId, reason)

            sendToDiscord("High Ping Alert", "Player " .. GetPlayerName(playerId) .. " (" .. playerId .. ") HighPingCount (" .. GetPlayerPing(playerId) .. "ms).", 16711680)

        DropPlayer(playerId, reason)
      
    end

    local function CheckPlayerPing(playerId)
        Citizen.CreateThread(function()
			Wait(OnlineTimeBeforeCheck)
            local PlayerId = playerId
            while true do
                Wait(CheckInterval)
               
                if IsPlayerExempt(PlayerId) then
                    return 
                end
                if not GetPlayerPing(PlayerId) then return end 
                
                local ping = GetPlayerPing(PlayerId)
                if ping >= PingLimit then
                    if HighPingCount[PlayerId] then
                        HighPingCount[PlayerId] = HighPingCount[PlayerId] + 1
                    else
                        HighPingCount[PlayerId] = 1
                    end
                    
                    if HighPingCount[PlayerId] >= KickThreshold then
                        KickPlayer(PlayerId, "HighPingCount (" .. ping .. "ms).")
                       
                        HighPingCount[PlayerId] = nil
                    end
                else
                    HighPingCount[PlayerId] = nil
                end
            end
        end)
    end



    local function CheckPO()
        local playerId = source
        if not IsPlayerExempt(playerId) then
            CheckPlayerPing(playerId)
        end
    end
    AddEventHandler('playerSpawned', CheckPO)
    AddEventHandler('esx:onPlayerSpawn', CheckPO)
end