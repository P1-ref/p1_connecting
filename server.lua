AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local count = GetNumPlayerIndices()
    local maxPlayers = GetConvarInt("sv_maxclients", 64)
    
    deferrals.defer()
    
    Wait(1)

    local card = {
        type = "AdaptiveCard",
        body = {
            {
                type = "TextBlock",
                text = string.format("Welcome, %s. There are %s/%s players connected.\n\nDo you wish to connect?", playerName, count, maxPlayers),
                weight = "Bold",
                size = "Large",
            },
            {
                type = "ActionSet",
                actions = {
                    {
                        type = "Action.Submit",
                        title = "Yes",
                        style = "positive",
                        data = {
                            success = true,
                        },
                    },
                    {
                        type = "Action.Submit",
                        title = "No",
                        style = "negative",
                        data = {
                            success = false,
                        },
                    },
                },
            },
        },
    }

    local function CheckChoice(data)
        if (data.success) then
            if (count >= maxPlayers) then
                deferrals.done("Server is currently full, try again later!")
            else
                deferrals.done()
            end
        else
            deferrals.done("You chose not to connect.")
        end
    end

    deferrals.presentCard(card, CheckChoice)
end)