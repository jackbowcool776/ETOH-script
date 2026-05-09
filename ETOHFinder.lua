-- ETOH Checkpoint Finder v4
-- Logs EVERYTHING - no filters
-- Walk into a checkpoint and paste ALL output

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 5,
        })
    end)
end

notify("ETOH Finder v4", "Walk into a checkpoint — logging everything!")
print("=== ETOH Finder v4 ===")

-- Log ALL remotes with no filtering at all
local logged = {}
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        local key = tostring(self) .. method
        if not logged[key] then
            logged[key] = true
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                argStr = argStr.." arg"..i.."="..tostring(v)
            end
            print("[ALL REMOTES] "..self.Name.." |"..argStr)
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Watch ALL value changes on player
for _, v in pairs(LocalPlayer:GetDescendants()) do
    if v:IsA("ValueBase") then
        v.Changed:Connect(function(val)
            print("[PLAYER VALUE] "..v.Name.." = "..tostring(val))
            notify("Value!", v.Name.." = "..tostring(val))
        end)
    end
end

-- Watch for new values being added to player
LocalPlayer.DescendantAdded:Connect(function(v)
    if v:IsA("ValueBase") then
        print("[NEW VALUE] "..v.Name.." = "..tostring(v.Value))
        notify("New Value!", v.Name.." = "..tostring(v.Value))
        v.Changed:Connect(function(val)
            print("[VALUE CHANGED] "..v.Name.." = "..tostring(val))
            notify("Changed!", v.Name.." = "..tostring(val))
        end)
    end
end)

-- Watch spawn location
local lastSpawn = tostring(LocalPlayer.RespawnLocation)
RunService.Heartbeat:Connect(function()
    local newSpawn = tostring(LocalPlayer.RespawnLocation)
    if newSpawn ~= lastSpawn then
        lastSpawn = newSpawn
        print("[SPAWN CHANGED] "..newSpawn)
        notify("Spawn!", newSpawn)
    end
end)

-- Watch character values
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
for _, v in pairs(char:GetDescendants()) do
    if v:IsA("ValueBase") then
        v.Changed:Connect(function(val)
            print("[CHAR VALUE] "..v.Name.." = "..tostring(val))
        end)
    end
end

print("=== Walk into a checkpoint NOW and paste everything! ===")
notify("Ready!", "Walk into a checkpoint now!")
