local DISCORD_WEBHOOK = "Insert-Webhook"
local WHITELISTED_INVITE = "invite" -- Change this to your server's invite code only

local function sendToDiscord(name, message)
    local embed = {
        {
            color = 16711680,
            title = "SFS Moderation",
            description = message,
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers)
        if err ~= 200 then
            print("Failed to send Discord webhook:", err, text)
        end
    end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('chatMessage', function(source, name, msg)
    local lowerMsg = string.lower(msg)
    local sanitizedMessage = lowerMsg:gsub("[^%w%s]", "") 

    local function handleViolation(actionMessage, kick, warning)
        CancelEvent()
        sendToDiscord(name, "Name: `" .. name .. "`\nMessage: `" .. msg .. "`\n\nAction: " .. actionMessage)
        if kick then
            DropPlayer(source, "You have been kicked for inappropriate behavior.\n\nIf this is a mistake, please make a ticket at https://discord.gg/" .. WHITELISTED_INVITE)
        end
        if warning then
            TriggerClientEvent('chatMessage', -1, "^1[SFS-Moderation] ^7" .. name .. " - " .. actionMessage, {255, 255, 0})
        end
    end

    local offensiveWords = {
        "nigga", "nigger", "n i g g a", "n i g g e r", "chink", "gook", "spic", "kike", "coon", "wetback", "beaner", 
        "raghead", "sandnigger", "faggot", "f a g g o t", "fag"
    }

    for _, word in ipairs(offensiveWords) do
        if sanitizedMessage:match(word) then
            handleViolation("Player kicked for sending offensive messages.", true, true)
            return
        end
    end

    if sanitizedMessage:match("discord%.gg") and not sanitizedMessage:match("discord%.gg/" .. WHITELISTED_INVITE) then
        if not IsPlayerAceAllowed(source, "staff-p") then
            handleViolation("Player attempted to post unauthorized Discord invite link.", false, true)
            return
        end
    end

    if sanitizedMessage:match("dsc%.gg") and not sanitizedMessage:match("dsc%.gg/" .. WHITELISTED_INVITE) then
        if not IsPlayerAceAllowed(source, "staff-p") then
            handleViolation("Player attempted to post unauthorized dsc.gg invite link.", false, true)
            return
        end
    end
end)
