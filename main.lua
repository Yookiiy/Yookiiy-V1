--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- GUI ROOT
--==================================================
local gui = Instance.new("ScreenGui")
gui.Name = "YookiiyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

--==================================================
-- VALUES
--==================================================
local Values = Instance.new("Folder")
Values.Name = "CheatValues"
Values.Parent = gui

local function num(name,val)
    local v = Instance.new("NumberValue")
    v.Name = name
    v.Value = val
    v.Parent = Values
    return v
end

local function bool(name,val)
    local v = Instance.new("BoolValue")
    v.Name = name
    v.Value = val
    v.Parent = Values
    return v
end

local JumpValue     = num("Jump",50)
local SpeedValue    = num("Speed",16)
local FlySpeedValue = num("FlySpeed",60)

local ESPValue   = bool("ESP",false)
local HitboxValue= bool("Hitbox",false)
local FlyValue   = bool("Fly",false)
local InvisValue = bool("Invis",false)

--==================================================
-- GUI VISUAL
--==================================================
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,420,0,300)
main.Position = UDim2.new(0.5,-210,0.5,-150)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

local top = Instance.new("Frame",main)
top.Size = UDim2.new(1,0,0,36)
top.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel",top)
title.Text = "Yookiiy V1"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,1,0)

local content = Instance.new("Frame",main)
content.Position = UDim2.new(0,0,0,36)
content.Size = UDim2.new(1,0,1,-36)
content.BackgroundTransparency = 1

--==================================================
-- SLIDER
--==================================================
local function slider(y,text,min,max,value)
    local lbl = Instance.new("TextLabel",content)
    lbl.Position = UDim2.new(0.05,0,y,0)
    lbl.Size = UDim2.new(0.9,0,0,20)
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.BackgroundTransparency = 1

    local bar = Instance.new("Frame",content)
    bar.Position = UDim2.new(0.05,0,y+0.06,0)
    bar.Size = UDim2.new(0.9,0,0,8)
    bar.BackgroundColor3 = Color3.fromRGB(45,45,45)

    local fill = Instance.new("Frame",bar)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

    local function refresh(x)
        local pct = math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
        value.Value = math.floor(min+(max-min)*pct)
        fill.Size = UDim2.new(pct,0,1,0)
        lbl.Text = text..": "..value.Value
    end

    lbl.Text = text..": "..value.Value
    fill.Size = UDim2.new((value.Value-min)/(max-min),0,1,0)

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            refresh(i.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            refresh(i.Position.X)
        end
    end)
end

slider(0.05,"Jump",50,200,JumpValue)
slider(0.25,"Speed",16,300,SpeedValue)
slider(0.45,"Fly Speed",20,200,FlySpeedValue)

--==================================================
-- TOGGLES
--==================================================
local function toggle(y,text,value)
    local b = Instance.new("TextButton",content)
    b.Position = UDim2.new(0.05,0,y,0)
    b.Size = UDim2.new(0.9,0,0,28)
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 13

    local function refresh()
        b.Text = text..": "..(value.Value and "ON" or "OFF")
    end
    refresh()

    b.MouseButton1Click:Connect(function()
        value.Value = not value.Value
        refresh()
    end)
end

toggle(0.65,"Fly",FlyValue)
toggle(0.75,"ESP",ESPValue)
toggle(0.85,"Hitbox",HitboxValue)
toggle(0.95,"Invis",InvisValue)

--==================================================
-- JUMP
--==================================================
local canJump = true
UIS.JumpRequest:Connect(function()
    if FlyValue.Value then return end
    local c = player.Character
    local h = c and c:FindFirstChild("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end
    if h.FloorMaterial == Enum.Material.Air then return end
    if JumpValue.Value <= 50 or not canJump then return end

    canJump = false
    local bv = Instance.new("BodyVelocity",r)
    bv.MaxForce = Vector3.new(0,1e9,0)
    bv.Velocity = Vector3.new(0,JumpValue.Value,0)
    task.delay(0.15,function() bv:Destroy() end)
    h:GetPropertyChangedSignal("FloorMaterial"):Once(function() canJump = true end)
end)

--==================================================
-- SPEED
--==================================================
local speedBV
RunService.Heartbeat:Connect(function()
    local c = player.Character
    local h = c and c:FindFirstChild("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end

    if FlyValue.Value or SpeedValue.Value <= 16 then
        if speedBV then speedBV:Destroy() speedBV=nil end
        return
    end

    if not speedBV then
        speedBV = Instance.new("BodyVelocity",r)
        speedBV.MaxForce = Vector3.new(1e9,0,1e9)
    end

    local d = h.MoveDirection
    speedBV.Velocity = d.Magnitude>0 and Vector3.new(d.X,0,d.Z).Unit*SpeedValue.Value or Vector3.zero
end)

--==================================================
-- FLY
--==================================================
local flying=false
local flyBV,flyBG

FlyValue.Changed:Connect(function(v)
    local c = player.Character
    local h = c and c:FindFirstChild("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if not h or not r then return end

    if v then
        h.PlatformStand=true
        flyBV=Instance.new("BodyVelocity",r)
        flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
        flyBG=Instance.new("BodyGyro",r)
        flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9)
        flyBG.P=1e5
        flying=true
    else
        flying=false
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        h.PlatformStand=false
    end
end)

RunService.RenderStepped:Connect(function()
    if not flying or not flyBV or not flyBG then return end
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if not h then return end
    local d = h.MoveDirection
    flyBV.Velocity = d.Magnitude>0 and camera.CFrame:VectorToWorldSpace(d)*FlySpeedValue.Value or Vector3.zero
    flyBG.CFrame = CFrame.new(flyBG.Parent.Position,flyBG.Parent.Position+camera.CFrame.LookVector)
end)

--==================================================
-- ESP
--==================================================
local ESPs={}
local function updateESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character then
            if ESPValue.Value then
                if not ESPs[p] then
                    local h=Instance.new("Highlight",workspace)
                    h.Adornee=p.Character
                    h.FillColor=Color3.fromRGB(255,0,0)
                    h.OutlineColor=Color3.new(1,1,1)
                    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                    ESPs[p]=h
                end
            else
                if ESPs[p] then ESPs[p]:Destroy() ESPs[p]=nil end
            end
        end
    end
end
ESPValue.Changed:Connect(updateESP)

--==================================================
-- HITBOX (MAX 5x)
--==================================================
local hitboxes={}
HitboxValue.Changed:Connect(function(v)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character then
            local r=p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                if v then
                    hitboxes[p]=r.Size
                    r.Size=r.Size*5
                    r.Transparency=1
                    r.CanCollide=false
                else
                    if hitboxes[p] then r.Size=hitboxes[p] end
                end
            end
        end
    end
end)

--==================================================
-- INVIS
--==================================================
local invisSaved={}
InvisValue.Changed:Connect(function(v)
    local c=player.Character
    if not c then return end
    for _,o in ipairs(c:GetDescendants()) do
        if o:IsA("BasePart") then
            if v then
                invisSaved[o]={T=o.Transparency,C=o.CanCollide,S=o.Size}
                o.Transparency=1 o.CanCollide=false
            else
                local d=invisSaved[o]
                if d then o.Transparency=d.T o.CanCollide=d.C o.Size=d.S end
            end
        end
    end
    if not v then table.clear(invisSaved) end
end)

--==================================================
-- RESPAWN SAFE
--==================================================
player.CharacterAdded:Connect(function()
    task.wait(0.3)
    canJump=true
    updateESP()
    if InvisValue.Value then InvisValue.Value=true end
end)
