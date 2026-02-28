local TeleportService = game:GetService("TeleportService")
function tp(place,job,plr)
    local success, errorMessage,rv = pcall(function()
        return TeleportService:TeleportToPlaceInstance(place, job , plr)
    end)
    return success;
end

getgenv().isTeleporting = getgenv().isTeleporting and true or false 
local randomRejoin;randomRejoin=function(recursiveCall)
    if(getgenv().isTeleporting and (recursiveCall ==nil or recursiveCall == false)) then return end 
    getgenv().isTeleporting = true
    local p = game:GetService("Players").LocalPlayer
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
        --getgenv().isTeleporting = false --this should stay away since randomrejoin down there will automatically set it as true again
        connect:Disconnect()
        connect = nil;
        task.wait(1)
        randomRejoin(true)
    end)
    local json;
    if response.Success then
        writefile("baddieWebRequestLoggs.json",response.Body)
        json = http:JSONDecode(response.Body)
    else
        json = http:JSONDecode(readfile("baddieWebRequestLoggs.json"))
    end
    local data = json.data
    if #data == 0 then
        TeleportService:Teleport(game.PlaceId)
    else
        local id = data[math.ceil(math.random()*#data)].id
        if not tp(game.PlaceId,id , p) then
            if connect then connect:Disconnect(); connect = nil end
            task.wait(1)
            randomRejoin(true)
        else
           if connect then connect:Disconnect(); connect = nil end --cleans up memory
        end
    end
    --connect:Disconnect()
    --https://games.roblox.com/v1/games/79305036070450/servers/Public?sortOrder=Desc&limit=100
end

randomRejoin()
