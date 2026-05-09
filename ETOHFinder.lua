-- ETOH Floor Position Finder
-- Gets the position of every floor in the current tower

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

print("=== ETOH Floor Finder ===")

-- Find which tower the player is currently in
local towers = workspace:FindFirstChild("Towers")
if not towers then
    print("No Towers folder found!")
    notify("Error", "No Towers folder found!")
    return
end

for _, tower in pairs(towers:GetChildren()) do
    local frame = tower:FindFirstChild("Frame")
    if frame then
        print("=== TOWER: "..tower.Name.." ===")
        -- Get all floors sorted by number
        local floors = {}
        for _, floor in pairs(frame:GetChildren()) do
            local num = tonumber(floor.Name:match("%d+"))
            if num then
                table.insert(floors, {name = floor.Name, num = num, obj = floor})
            end
        end
        table.sort(floors, function(a,b) return a.num < b.num end)

        for _, f in ipairs(floors) do
            -- Get position of first BasePart in floor
            local part = f.obj:IsA("BasePart") and f.obj
                or f.obj:FindFirstChildOfClass("BasePart")
            if part then
                local p = part.Position
                print(f.name.." | Pos: "..math.floor(p.X)..","..math.floor(p.Y)..","..math.floor(p.Z))
            end
        end

        -- Also print teleporter position
        local tp = tower:FindFirstChild("Teleporter", true)
        if tp then
            local tpPart = tp:IsA("BasePart") and tp or tp:FindFirstChildOfClass("BasePart")
            if tpPart then
                local p = tpPart.Position
                print("Teleporter | Pos: "..math.floor(p.X)..","..math.floor(p.Y)..","..math.floor(p.Z))
            end
        end
    end
end

-- Also print ALL remotes one more time cleanly
print("=== ALL REMOTES ===")
for _, obj in pairs(game:GetDescendants()) do
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        print(obj.ClassName..": "..obj.Name.." | "..obj:GetFullName())
    end
end

notify("Done!", "Check console!")
print("=== Done! ===")
