-- ETOH Checkpoint Finder
-- Run this in Escape the Obby Hell
-- Walk into a checkpoint to detect it

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

-- Only notify for parts with these specific names
local CHECKPOINT_KEYWORDS = {
    "check", "checkpoint", "stage", "cp", "point",
    "finish", "end", "goal", "complete", "win",
    "spawn", "respawn", "zone",
}

local function isCheckpointName(name)
    name = name:lower()
    for _, kw in ipairs(CHECKPOINT_KEYWORDS) do
        if name == kw or name:find("^"..kw) or name:find(kw.."$") then
            return true
        end
    end
    return false
end

local notifiedParts = {} -- avoid spamming same part

local char = LocalPlayer.Character
    or LocalPlayer.CharacterAdded:Wait()

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and isCheckpointName(obj.Name) then
        obj.Touched:Connect(function(hit)
            if hit:IsDescendantOf(char) and not notifiedParts[obj] then
                notifiedParts[obj] = true
                print("[CHECKPOINT TOUCHED] " .. obj:GetFullName())
                notify("✅ Checkpoint!", obj.Name .. "\n" .. obj:GetFullName())
                task.delay(3, function() notifiedParts[obj] = nil end)
            end
        end)
    end
end

-- Hook remotes — only notify when a remote fires while touching something
local ok = pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                argStr = argStr .. " | arg"..i..": "..tostring(v)
            end
            print("[REMOTE] " .. self:GetFullName() .. argStr)
            notify("🔥 Remote: " .. self.Name, self:GetFullName().."\n"..argStr)
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

if not ok then
    notify("ETOH Finder", "Metatable hook failed — touch detection only!")
end

print("=== Ready! Walk into a checkpoint ===")
