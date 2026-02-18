local randomRejoin;randomRejoin=function()
    local p = game:GetService("Players").LocalPlayer
    local to = Instance.new("TeleportOptions")

    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = message
    }
    local body = http:JSONEncode(data)
    local url = "https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100"
    local response = request({
        Url = url,
        Method = "GET",
        Headers = headers,
        Body = body
    })
    local connect;
    connect = TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage, placeId, jobId)
        connect:Disconnect()
        task.wait(1)
        randomRejoin()
    end)
    if response.Success then
        writefile("baddieWebRequestLoggs.json",response.Body)
        local json = http:JSONDecode(response.Body)
        local data = json.data
        local id = data[math.ceil(math.random()*#data)].id
        if not tp(game.PlaceId,id , p) then
            randomRejoin()
        end
    else
        local json = http:JSONDecode(readfile("baddieWebRequestLoggs.json"))
        local data = json.data
        local id = data[math.ceil(math.random()*#data)].id
        if not tp(game.PlaceId,id, p) then
            randomRejoin()
        end
    end
    --connect:Disconnect()
    --https://games.roblox.com/v1/games/79305036070450/servers/Public?sortOrder=Desc&limit=100
end
return randomRejoin
