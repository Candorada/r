--this script will automatically prevent the game from registering you from loading, this will serverside prevent boosts from being removed. 
--locally it will count down, but on rejon the UI will correct itself. 
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 79305036070450 then return end
--game:GetService("RunService"):Set3dRenderingEnabled(false)
local REPLICATED_STORAGE = cloneref(game:GetService("ReplicatedStorage"));
local SayMessageRequest = REPLICATED_STORAGE.Events.start_game;
local old_namecall;

old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local self, args = ..., {select(2, ...)};
    local method = string.lower(getnamecallmethod());
    if typeof(self) == "Instance" and self.IsA(self, "RemoteEvent") then
        if method == "fireserver" and self == SayMessageRequest then
            game:GetService("Players").LocalPlayer:SetAttribute("Loaded",true)
            return;
        end
    end
    
    return old_namecall(...);
end))
