-- ETOH Checkpoint Finder
-- Run this in Escape the Obby Hell
-- Then click a checkpoint and paste the output

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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
        end
    end
end

print("=== TOUCHING DETECTOR ===")
-- Hook touched events to find which part registers checkpoints
local char = LocalPlayer.Character
if char then
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        print("Watching touch events - walk into a checkpoint now!")
        workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") then
                obj.Touched:Connect(function(hit)
                    if hit:IsDescendantOf(char) then
                        print("[TOUCHED] " .. obj:GetFullName())
                    end
                end)
            end
        end)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Touched:Connect(function(hit)
                    if hit:IsDescendantOf(char) then
                        local name = obj.Name:lower()
                        if name:find("check") or name:find("stage") 
                        or name:find("cp") or name:find("point") then
                            print("[CHECKPOINT TOUCHED] " .. obj:GetFullName())
                        end
                    end
                end)
            end
        end
    end
end

-- Also hook remotes like Sol's RNG
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
    end
    return old(self, ...)
end)
setreadonly(mt, true)

print("=== NOW TOUCH A CHECKPOINT AND PASTE OUTPUT ===")
