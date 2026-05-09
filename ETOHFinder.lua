-- ETOH File Explorer
-- Searches game files for checkpoint related scripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text, Duration = 5,
        })
    end)
end

notify("ETOH Explorer", "Searching game files...")
print("=== ETOH File Explorer ===")

-- Search all scripts for checkpoint related code
local KEYWORDS = {
    "checkpoint", "stage", "checkpt", "cp",
    "complete", "finish", "tower", "floor",
}

print("=== SCRIPTS CONTAINING CHECKPOINT KEYWORDS ===")
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("LocalScript") or obj:IsA("Script") or obj:IsA("ModuleScript") then
        local src = ""
        pcall(function() src = obj.Source:lower() end)
        if src ~= "" then
            for _, kw in ipairs(KEYWORDS) do
                if src:find(kw) then
                    print("[SCRIPT] "..obj:GetFullName().." contains: "..kw)
                    break
                end
            end
        end
    end
end

-- Print ALL remotes in the game
print("=== ALL REMOTES ===")
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") then
        print(obj.ClassName..": "..obj:GetFullName())
    end
end

-- Look for checkpoint parts in workspace
print("=== ALL PARTS IN WORKSPACE (first 100) ===")
local count = 0
for _, obj in pairs(workspace:GetDescendants()) do
    if count >= 100 then break end
    if obj:IsA("BasePart") then
        print(obj.Name.." | "..obj:GetFullName())
        count = count + 1
    end
end

notify("Done!", "Check console output!")
print("=== Done! Paste all output ===")
