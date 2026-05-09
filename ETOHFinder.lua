-- ETOH Checkpoint Finder v3
-- Watches for spawn changes and ALL remotes

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 6,
        })
    end)
end

notify("ETOH Finder v3", "Walk into a checkpoint now!")
print("=== ETOH Finder v3 - Walk into a checkpoint ===")

-- Filter out noisy remotes we don't care about
local IGNORE = {
    "DamageEvent", "PlayerList", "SendLikelySpeakingUsers",
    "qNieoqCL", "qA4+Ooh", "Network"
}

local function shouldIgnore(name)
    for _, v in ipairs(IGNORE) do
        if name:find(v) then return true end
    end
    return false
end

-- Watch ALL remotes but filter noise
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        local name = tostring(self:GetFullName())
        if not shouldIgnore(name) then
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                argStr = argStr.." | arg"..i..": "..tostring(v)
            end
            print("[REMOTE] "..name..argStr)
            notify("🔥 Remote!", self.Name.."\n"..argStr)
        end
    end
    return old(self, ...)
end)
setreadonly(mt, true)

-- Watch for spawn point changing (means checkpoint was hit)
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local lastSpawn = LocalPlayer.RespawnLocation

RunService = game:GetService("RunService")
RunService.Heartbeat:Connect(function()
    local newSpawn = LocalPlayer.RespawnLocation
    if newSpawn ~= lastSpawn then
        lastSpawn = newSpawn
        local name = newSpawn and newSpawn.Name or "nil"
        print("[SPAWN CHANGED] New spawn: "..name)
        notify("✅ Checkpoint!", "Spawn changed to: "..name)
    end
end)

-- Watch for any value changes in character that might indicate checkpoint
if char then
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
            v.Changed:Connect(function(val)
                local name = v.Name:lower()
                if name:find("stage") or name:find("check") or name:find("level")
                or name:find("point") or name:find("cp") then
                    print("[VALUE CHANGED] "..v:GetFullName().." = "..tostring(val))
                    notify("📊 Value!", v.Name.." = "..tostring(val))
                end
            end)
        end
    end
end

-- Also watch player values
for _, v in pairs(LocalPlayer:GetDescendants()) do
    if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("StringValue") then
        v.Changed:Connect(function(val)
            local name = v.Name:lower()
            if name:find("stage") or name:find("check") or name:find("level")
            or name:find("point") or name:find("cp") or name:find("floor") then
                print("[PLAYER VALUE] "..v:GetFullName().." = "..tostring(val))
                notify("📊 Player Value!", v.Name.." = "..tostring(val))
            end
        end)
    end
end

print("=== Ready! Walk into a checkpoint ===")
