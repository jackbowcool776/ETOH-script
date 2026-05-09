-- ETOH Checkpoint Finder
-- Run this in Escape the Obby Hell
-- Then click a checkpoint and paste the output

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5,
        })
    end)
end

notify("ETOH Finder", "Running! Walk into a checkpoint to detect it!")

print("=== REMOTE EVENTS ===")
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print(obj.ClassName .. ": " .. obj:GetFullName())
    end
end

print("=== CHECKPOINTS IN WORKSPACE ===")
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") or obj:IsA("Model") then
        local name = obj.Name:lower()
        if name:find("check") or name:find("stage") or name:find("spawn")
        or name:find("point") or name:find("start") or name:find("finish")
        or name:find("end") or name:find("goal") or name:find("cp") then
            print(obj.ClassName .. ": " .. obj:GetFullName())
            notify("Checkpoint Found!", obj.Name .. " at " .. obj:GetFullName())
        end
    end
end

print("=== TOUCHING DETECTOR ===")
local char = LocalPlayer.Character
if char then
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        print("Watching touch events - walk into a checkpoint now!")

        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Touched:Connect(function(hit)
                    if hit:IsDescendantOf(char) then
                        local name = obj.Name:lower()
                        if name:find("check") or name:find("stage")
                        or name:find("cp") or name:find("point")
                        or name:find("spawn") or name:find("finish")
                        or name:find("end") or name:find("goal") then
                            print("[CHECKPOINT TOUCHED] " .. obj:GetFullName())
                            notify("✅ Checkpoint Touched!", obj.Name .. "\n" .. obj:GetFullName())
                        end
                    end
                end)
            end
        end

        -- Also watch for ANY touch so we catch checkpoints with unusual names
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local hasTouchInterest = obj:FindFirstChildOfClass("TouchTransmitter")
                if hasTouchInterest then
                    obj.Touched:Connect(function(hit)
                        if hit:IsDescendantOf(char) then
                            print("[TOUCH INTEREST] " .. obj:GetFullName())
                            notify("👆 Touch Detected!", obj.Name .. "\n" .. obj:GetFullName())
                        end
                    end)
                end
            end
        end
    end
end

-- Hook remotes
local ok = pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            local args = {...}
            print("[REMOTE] " .. tostring(self:GetFullName()) .. " | " .. method)
            for i, v in ipairs(args) do
                print("   arg"..i..": "..tostring(v))
            end
            notify("🔥 Remote Fired!", self.Name .. " | " .. method)
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
    print("Metatable hook active!")
end)

if not ok then
    print("Metatable hook failed - using touch detection only")
    notify("ETOH Finder", "Using touch detection — walk into checkpoints!")
end

print("=== READY — walk into a checkpoint! ===")
