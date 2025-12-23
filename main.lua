-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- =======================
-- VALUES (GUI)
-- =======================
local Values = Instance.new("Folder", player)
Values.Name = "CheatValues"

local JumpValue = Instance.new("NumberValue", Values)
JumpValue.Name = "Jump"
JumpValue.Value = 50

local SpeedValue = Instance.new("NumberValue", Values)
SpeedValue.Name = "Speed"
SpeedValue.Value = 16

local FlySpeedValue = Instance.new("NumberValue", Values)
FlySpeedValue.Name = "FlySpeed"
FlySpeedValue.Value = 60

local ESPValue = Instance.new("BoolValue", Values)
ESPValue.Name = "ESP"
ESPValue.Value = false

local HitboxValue = Instance.new("BoolValue", Values)
HitboxValue.Name = "Hitbox"
HitboxValue.Value = false

local FlyValue = Instance.new("BoolValue", Values)
FlyValue.Name = "Fly"
FlyValue.Value = false

local InvisValue = Instance.new("BoolValue", Values)
InvisValue.Name = "Invis"
InvisValue.Value = false

-- =======================
-- JUMP
-- =======================
local canJump = true

UIS.JumpRequest:Connect(function()
    if FlyValue.Value then return end

    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if hum.FloorMaterial == Enum.Material.Air then return end
    if JumpValue.Value <= 50 or not canJump then return end

    canJump = false

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0,1e9,0)
    bv.Velocity = Vector3.new(0, JumpValue.Value, 0)
    bv.Parent = hrp

    task.delay(0.15, function()
        if bv then bv:Destroy() end
    end)

    hum:GetPropertyChangedSignal("FloorMaterial"):Once(function()
        canJump = true
    end)
end)

-- =======================
-- SPEED
-- =======================
local speedBV, speedConn

local function startSpeed()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    if speedBV then speedBV:Destroy() end
    if speedConn then speedConn:Disconnect() end

    speedBV = Instance.new("BodyVelocity")
    speedBV.MaxForce = Vector3.new(1e9,0,1e9)
    speedBV.Parent = hrp

    speedConn = RunService.Heartbeat:Connect(function()
        if FlyValue.Value or SpeedValue.Value <= 16 then
            speedBV.Velocity = Vector3.zero
            return
        end

        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            speedBV.Velocity = Vector3.new(dir.X,0,dir.Z).Unit * SpeedValue.Value
        else
            speedBV.Velocity = Vector3.zero
        end
    end)
end

-- =======================
-- FLY
-- =======================
local flying = false
local flyBV, flyBG

local function startFly()
    if flying then return end
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e9,1e9,1e9)
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e9,1e9,1e9)
    flyBG.P = 1e5
    flyBG.Parent = hrp

    flying = true
end

local function stopFly()
    flying = false
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end

    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if hum then hum.PlatformStand = false end
end

FlyValue.Changed:Connect(function(v)
    if v then startFly() else stopFly() end
end)

RunService.RenderStepped:Connect(function()
    if not flying or not flyBV or not flyBG then return end

    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end

    local dir = hum.MoveDirection
    local camCF = camera.CFrame

    if dir.Magnitude > 0 then
        flyBV.Velocity = camCF:VectorToWorldSpace(dir) * FlySpeedValue.Value
    else
        flyBV.Velocity = Vector3.zero
    end

    flyBG.CFrame = CFrame.new(flyBG.Parent.Position, flyBG.Parent.Position + camCF.LookVector)
end)

-- =======================
-- ESP
-- =======================
local ESPs = {}

local function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            if ESPValue.Value then
                if not ESPs[plr] then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = Color3.fromRGB(255,0,0)
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Adornee = plr.Character
                    hl.Parent = plr.Character
                    ESPs[plr] = hl
                end
            else
                if ESPs[plr] then ESPs[plr]:Destroy() ESPs[plr] = nil end
            end
        end
    end
end

ESPValue.Changed:Connect(updateESP)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.2)
        updateESP()
        if HitboxValue.Value then applyHitbox(p) end
    end)
end)

-- =======================
-- HITBOX
-- =======================
local hitboxSize = Vector3.new(10,10,10)
local hitboxes = {}

function applyHitbox(plr)
    if plr == player or not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if not hitboxes[plr] then
        hitboxes[plr] = hrp.Size
    end

    hrp.Size = hitboxSize
    hrp.Transparency = 1
    hrp.CanCollide = false
end

function removeHitbox(plr)
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hitboxes[plr] then
        hrp.Size = hitboxes[plr]
    end
    hitboxes[plr] = nil
end

HitboxValue.Changed:Connect(function(v)
    for _,plr in ipairs(Players:GetPlayers()) do
        if v then applyHitbox(plr) else removeHitbox(plr) end
    end
end)

-- =======================
-- INVISIBILIDADE (GUI)
-- =======================
local invisSaved = {}

local function setInvisible(state)
    local char = player.Character
    if not char then return end

    for _,obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            if state then
                if not invisSaved[obj] then
                    invisSaved[obj] = {
                        Transparency = obj.Transparency,
                        CanCollide = obj.CanCollide,
                        Size = obj.Size,
                        LocalTransparencyModifier = obj.LocalTransparencyModifier
                    }
                end
                obj.Transparency = 1
                obj.LocalTransparencyModifier = 1
                obj.CanCollide = false
                if obj.Name == "HumanoidRootPart" then
                    obj.Size = Vector3.new(0.1,0.1,0.1)
                end
            else
                local old = invisSaved[obj]
                if old then
                    obj.Transparency = old.Transparency
                    obj.LocalTransparencyModifier = old.LocalTransparencyModifier
                    obj.CanCollide = old.CanCollide
                    obj.Size = old.Size
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = state and 1 or 0
        end
    end
end

InvisValue.Changed:Connect(function(v)
    setInvisible(v)
    if not v then table.clear(invisSaved) end
end)

-- =======================
-- RESPAWN SAFE
-- =======================
player.CharacterAdded:Connect(function()
    task.wait(0.2)
    canJump = true
    startSpeed()
    stopFly()
    if InvisValue.Value then setInvisible(true) end
    updateESP()
end)

startSpeed()
