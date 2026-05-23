-- Coordinate Teleporter
-- Shows your position in real time, copy coords, teleport anywhere

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui       = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local function notify(t, m)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title=t, Text=m, Duration=3})
    end)
end

local C = {
    bg     = Color3.fromRGB(14, 14, 22),
    panel  = Color3.fromRGB(20, 20, 32),
    row    = Color3.fromRGB(26, 26, 40),
    input  = Color3.fromRGB(18, 18, 28),
    accent = Color3.fromRGB(100, 220, 255),
    red    = Color3.fromRGB(200, 45, 45),
    green  = Color3.fromRGB(40, 160, 80),
    text   = Color3.fromRGB(220, 220, 230),
    sub    = Color3.fromRGB(100, 100, 130),
    blue   = Color3.fromRGB(40, 100, 200),
    yellow = Color3.fromRGB(255, 200, 60),
}

-- =====================
-- GUI
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "CoordTeleporter"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.DisplayOrder = 50
pcall(function() gui.Parent = game:GetService("CoreGui") end)

local Win = Instance.new("Frame")
Win.Size = UDim2.new(0, 280, 0, 340)
Win.Position = UDim2.new(1, -300, 0.5, -170)
Win.BackgroundColor3 = C.bg
Win.BorderSizePixel = 0
Win.Active = true
Win.ZIndex = 10
Win.Parent = gui
Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 12)
local winS = Instance.new("UIStroke")
winS.Color = C.accent winS.Thickness = 1.5 winS.Parent = Win

-- Title bar
local TBar = Instance.new("Frame")
TBar.Size = UDim2.new(1,0,0,36)
TBar.BackgroundColor3 = C.panel
TBar.BorderSizePixel = 0 TBar.ZIndex = 11 TBar.Parent = Win
Instance.new("UICorner", TBar).CornerRadius = UDim.new(0, 12)
local TFix = Instance.new("Frame")
TFix.Size = UDim2.new(1,0,0.5,0) TFix.Position = UDim2.new(0,0,0.5,0)
TFix.BackgroundColor3 = C.panel TFix.BorderSizePixel = 0 TFix.ZIndex = 11 TFix.Parent = TBar

local TTitle = Instance.new("TextLabel")
TTitle.Size = UDim2.new(1,-50,1,0) TTitle.Position = UDim2.new(0,12,0,0)
TTitle.BackgroundTransparency = 1 TTitle.TextColor3 = C.accent
TTitle.Font = Enum.Font.GothamBlack TTitle.TextSize = 13
TTitle.TextXAlignment = Enum.TextXAlignment.Left
TTitle.Text = "📍 Coordinate Teleporter" TTitle.ZIndex = 12 TTitle.Parent = TBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,26,0,26) CloseBtn.Position = UDim2.new(1,-30,0.5,-13)
CloseBtn.BackgroundColor3 = C.red CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBlack CloseBtn.TextSize = 11 CloseBtn.Text = "X"
CloseBtn.BorderSizePixel = 0 CloseBtn.ZIndex = 13 CloseBtn.Parent = TBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() Win.Visible = false end)

-- Drag
local drag, ds, fs = false, nil, nil
TBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true ds = i.Position fs = Win.Position
    end
end)
TBar.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        Win.Position = UDim2.new(fs.X.Scale, fs.X.Offset+d.X, fs.Y.Scale, fs.Y.Offset+d.Y)
    end
end)

-- Scroll content
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,0,1,-36)
Scroll.Position = UDim2.new(0,0,0,36)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = C.accent
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ZIndex = 11 Scroll.Parent = Win
local SLayout = Instance.new("UIListLayout")
SLayout.Padding = UDim.new(0,6) SLayout.Parent = Scroll
local SPad = Instance.new("UIPadding")
SPad.PaddingTop = UDim.new(0,10)
SPad.PaddingLeft = UDim.new(0,10)
SPad.PaddingRight = UDim.new(0,10)
SPad.PaddingBottom = UDim.new(0,10)
SPad.Parent = Scroll

local function sectionLbl(text)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,0,0,14)
    l.BackgroundTransparency = 1 l.TextColor3 = C.sub
    l.Font = Enum.Font.GothamBold l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = "── "..text:upper().." ──"
    l.ZIndex = 12 l.Parent = Scroll
    return l
end

local function makeCard(h)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h)
    f.BackgroundColor3 = C.panel
    f.BorderSizePixel = 0 f.ZIndex = 12 f.Parent = Scroll
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,8)
    return f
end

local function makeBtn(text, color, fn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,30)
    b.BackgroundColor3 = color or C.blue
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold b.TextSize = 12
    b.Text = text b.BorderSizePixel = 0 b.ZIndex = 12 b.Parent = Scroll
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,7)
    if fn then b.MouseButton1Click:Connect(fn) end
    return b
end

local function makeInput(placeholder, default)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,28)
    f.BackgroundColor3 = C.input
    f.BorderSizePixel = 0 f.ZIndex = 12 f.Parent = Scroll
    Instance.new("UICorner",f).CornerRadius = UDim.new(0,7)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1,-10,1,0) box.Position = UDim2.new(0,5,0,0)
    box.BackgroundTransparency = 1
    box.TextColor3 = C.text box.Font = Enum.Font.GothamBold box.TextSize = 12
    box.PlaceholderText = placeholder box.Text = default or ""
    box.ClearTextOnFocus = false box.BorderSizePixel = 0 box.ZIndex = 13
    box.Parent = f
    return box
end

-- =====================
-- CURRENT POSITION DISPLAY
-- =====================
sectionLbl("Current Position")

local posCard = makeCard(84)

local function makePosRow(label, color, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,20,0,22) lbl.Position = UDim2.new(0,10,0,y)
    lbl.BackgroundTransparency = 1 lbl.TextColor3 = color
    lbl.Font = Enum.Font.GothamBlack lbl.TextSize = 12
    lbl.Text = label lbl.ZIndex = 13 lbl.Parent = posCard

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1,-36,0,22) val.Position = UDim2.new(0,28,0,y)
    val.BackgroundTransparency = 1 val.TextColor3 = C.text
    val.Font = Enum.Font.GothamBold val.TextSize = 12
    val.TextXAlignment = Enum.TextXAlignment.Left
    val.Text = "0.000" val.ZIndex = 13 val.Parent = posCard
    return val
end

local xLbl = makePosRow("X", Color3.fromRGB(255,80,80),   8)
local yLbl = makePosRow("Y", Color3.fromRGB(80,200,80),  30)
local zLbl = makePosRow("Z", Color3.fromRGB(80,120,255), 52)

-- Copy current position button
makeBtn("📋 Copy Current Position", C.blue, function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then notify("Coords","No character found!") return end
    local p = root.Position
    local str = math.floor(p.X*100)/100 ..", ".. math.floor(p.Y*100)/100 ..", ".. math.floor(p.Z*100)/100
    pcall(function() setclipboard(str) end)
    notify("Coords", "Copied: "..str)
end)

-- =====================
-- SAVED POSITIONS
-- =====================
sectionLbl("Saved Positions")

local savedPositions = {}
local savedListFrame = Instance.new("Frame")
savedListFrame.Size = UDim2.new(1,0,0,0)
savedListFrame.AutomaticSize = Enum.AutomaticSize.Y
savedListFrame.BackgroundTransparency = 1
savedListFrame.ZIndex = 12 savedListFrame.Parent = Scroll
local savedLayout = Instance.new("UIListLayout")
savedLayout.Padding = UDim.new(0,4)
savedLayout.Parent = savedListFrame

local function refreshSaved()
    for _, c in pairs(savedListFrame:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    for i, saved in ipairs(savedPositions) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1,0,0,30)
        row.BackgroundColor3 = C.row
        row.BorderSizePixel = 0 row.ZIndex = 13 row.Parent = savedListFrame
        Instance.new("UICorner",row).CornerRadius = UDim.new(0,6)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1,-90,1,0) nameLbl.Position = UDim2.new(0,8,0,0)
        nameLbl.BackgroundTransparency = 1 nameLbl.TextColor3 = C.text
        nameLbl.Font = Enum.Font.GothamBold nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Text = saved.name.." ("..math.floor(saved.pos.X)..", "..math.floor(saved.pos.Y)..", "..math.floor(saved.pos.Z)..")"
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 14 nameLbl.Parent = row

        -- Teleport to saved
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0,40,0,22) tpBtn.Position = UDim2.new(1,-84,0.5,-11)
        tpBtn.BackgroundColor3 = C.green tpBtn.TextColor3 = Color3.new(1,1,1)
        tpBtn.Font = Enum.Font.GothamBold tpBtn.TextSize = 10
        tpBtn.Text = "TP" tpBtn.BorderSizePixel = 0 tpBtn.ZIndex = 14 tpBtn.Parent = row
        Instance.new("UICorner",tpBtn).CornerRadius = UDim.new(0,5)

        local savedPos = saved.pos
        tpBtn.MouseButton1Click:Connect(function()
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not root then notify("Coords","No character!") return end
            root.CFrame = CFrame.new(savedPos)
            notify("Coords", "Teleported to "..saved.name)
        end)

        -- Delete saved
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0,36,0,22) delBtn.Position = UDim2.new(1,-40,0.5,-11)
        delBtn.BackgroundColor3 = C.red delBtn.TextColor3 = Color3.new(1,1,1)
        delBtn.Font = Enum.Font.GothamBold delBtn.TextSize = 10
        delBtn.Text = "Del" delBtn.BorderSizePixel = 0 delBtn.ZIndex = 14 delBtn.Parent = row
        Instance.new("UICorner",delBtn).CornerRadius = UDim.new(0,5)

        local idx = i
        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedPositions, idx)
            refreshSaved()
        end)
    end
end

-- Save current position
local saveNameBox = makeInput("Label for saved position...", "")
makeBtn("💾 Save Current Position", C.blue, function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then notify("Coords","No character!") return end
    local name = saveNameBox.Text ~= "" and saveNameBox.Text or ("Pos "..#savedPositions+1)
    table.insert(savedPositions, {name=name, pos=root.Position})
    saveNameBox.Text = ""
    refreshSaved()
    notify("Coords", "Saved: "..name)
end)

-- =====================
-- TELEPORT TO COORDS
-- =====================
sectionLbl("Teleport to Coordinates")

local xBox = makeInput("X coordinate", "0")
local yBox = makeInput("Y coordinate", "50")
local zBox = makeInput("Z coordinate", "0")

makeBtn("🌀 Teleport to XYZ", C.green, function()
    local x = tonumber(xBox.Text)
    local y = tonumber(yBox.Text)
    local z = tonumber(zBox.Text)
    if not x or not y or not z then
        notify("Coords", "Enter valid X, Y, Z numbers!")
        return
    end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then notify("Coords","No character found!") return end
    root.CFrame = CFrame.new(x, y, z)
    notify("Coords", "Teleported to ("..x..", "..y..", "..z..")")
end)

-- Paste coords (split by comma)
sectionLbl("Paste Coordinates")
local pasteBox = makeInput("Paste: X, Y, Z", "")
makeBtn("📋 Paste & Teleport", C.yellow, function()
    local text = pasteBox.Text
    local parts = text:split(",")
    if #parts ~= 3 then
        notify("Coords","Format: X, Y, Z (comma separated)")
        return
    end
    local x = tonumber(parts[1])
    local y = tonumber(parts[2])
    local z = tonumber(parts[3])
    if not x or not y or not z then
        notify("Coords","Invalid numbers!")
        return
    end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then notify("Coords","No character!") return end
    root.CFrame = CFrame.new(x, y, z)
    notify("Coords","Teleported to ("..x..", "..y..", "..z..")")
end)

-- =====================
-- PILL TOGGLE
-- =====================
local Pill = Instance.new("Frame")
Pill.Size = UDim2.new(0,160,0,34)
Pill.Position = UDim2.new(1,-180,0,20)
Pill.BackgroundColor3 = C.bg
Pill.BorderSizePixel = 0 Pill.ZIndex = 5 Pill.Parent = gui
Instance.new("UICorner",Pill).CornerRadius = UDim.new(0,10)
local pS = Instance.new("UIStroke") pS.Color=Color3.fromRGB(50,50,70) pS.Parent=Pill

local PillBtn = Instance.new("TextButton")
PillBtn.Size = UDim2.new(1,0,1,0) PillBtn.BackgroundTransparency = 1
PillBtn.TextColor3 = C.sub PillBtn.Font = Enum.Font.GothamBold
PillBtn.TextSize = 12 PillBtn.Text = "📍 Coords: OFF"
PillBtn.ZIndex = 6 PillBtn.Parent = Pill

local pd,pds,pfs=false,nil,nil
Pill.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then pd=true pds=i.Position pfs=Pill.Position end
end)
Pill.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then pd=false end
end)
UserInputService.InputChanged:Connect(function(i)
    if pd and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-pds
        Pill.Position=UDim2.new(pfs.X.Scale,pfs.X.Offset+d.X,pfs.Y.Scale,pfs.Y.Offset+d.Y)
    end
end)

PillBtn.MouseButton1Click:Connect(function()
    Win.Visible = not Win.Visible
    if Win.Visible then
        PillBtn.Text = "📍 Coords: ON"
        PillBtn.TextColor3 = C.accent
        pS.Color = C.accent
    else
        PillBtn.Text = "📍 Coords: OFF"
        PillBtn.TextColor3 = C.sub
        pS.Color = Color3.fromRGB(50,50,70)
    end
end)

-- =====================
-- LIVE UPDATE LOOP
-- =====================
RunService.RenderStepped:Connect(function()
    if not Win.Visible then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then
        xLbl.Text = "N/A" yLbl.Text = "N/A" zLbl.Text = "N/A"
        return
    end
    local p = root.Position
    xLbl.Text = string.format("%.2f", p.X)
    yLbl.Text = string.format("%.2f", p.Y)
    zLbl.Text = string.format("%.2f", p.Z)
end)

notify("Coord Teleporter", "Loaded! Click the pill to open.")
print("[Coord Teleporter] Loaded!")
