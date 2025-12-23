--=====================================================
-- 馃幆 YOOKIIY V8 - EVAS脙O EXTREMA
-- 鉁� God Mode/NoClip Evasivos + Anti-Detec莽茫o Aprimorado
--=====================================================

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local PhysicsService = game:GetService("PhysicsService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURA脟脙O GLOBAL
--==================================================
local Config = {
    Jump = 50,
    Speed = 16,
    FlySpeed = 60,
    ESP = false,
    Hitbox = false,
    Fly = false,
    Invis = false,
    NoClip = false,
    GodMode = false,
}

-- Tabela para armazenar conex玫es de eventos
local Connections = {}

--==================================================
-- GUI VISUAL (Customizada: 524x524, Preto)
--==================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YookiiyGUI"
ScreenGui.ResetOnSpawn = false

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = playerGui
end

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 524, 0, 524) -- Tamanho customizado (524x524)
MainFrame.Position = UDim2.new(0.5, -262, 0.5, -262)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(100, 100, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "馃幆 Yookiiy V8"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Bot玫es de Controle (Minimizar e Destruir)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 70, 1, 0)
ControlsFrame.Position = UDim2.new(1, -70, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "鉃�"
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
MinimizeButton.Parent = ControlsFrame

local DestroyButton = Instance.new("TextButton")
DestroyButton.Name = "Destroy"
DestroyButton.Size = UDim2.new(0, 30, 1, 0)
DestroyButton.Position = UDim2.new(0, 35, 0, 0)
DestroyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
DestroyButton.BorderSizePixel = 0
DestroyButton.Text = "鉂�"
DestroyButton.Font = Enum.Font.GothamBold
DestroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DestroyButton.TextSize = 14
DestroyButton.Parent = ControlsFrame

-- ScrollFrame para conte煤do
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ScrollFrame"
ScrollFrame.Size = UDim2.new(1, -20, 1, -60)
ScrollFrame.Position = UDim2.new(0, 10, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
ScrollFrame.Parent = MainFrame

-- Layout para organizar os itens
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 10)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Parent = ScrollFrame

--==================================================
-- FUN脟脮ES DE CONTROLE (Mantidas)
--==================================================

-- Fun莽茫o para criar Sliders (Mantida)
local function CreateSlider(name, text, min, max, defaultValue, valueKey)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, -20, 0, 55)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = ScrollFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. defaultValue
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, 0, 0, 8)
    SliderBack.Position = UDim2.new(0, 0, 0, 30)
    SliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = SliderFrame
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1, 0)
    SliderCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 15)
    SliderButton.Position = UDim2.new(0, 0, 0, -7.5)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBack
    
    local dragging = false
    
    local function updateValue(value)
        Config[valueKey] = value
        Label.Text = text .. ": " .. value
        SliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
        
        if Config[valueKey .. "Update"] then
            Config[valueKey .. "Update"](value)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    Connections["SliderInputEnded" .. valueKey] = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Connections["SliderRenderStepped" .. valueKey] = RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UIS:GetMouseLocation().X
            local sliderPos = SliderBack.AbsolutePosition.X
            local sliderSize = SliderBack.AbsoluteSize.X
            local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local actualValue = math.floor(min + (max - min) * value)
            
            updateValue(actualValue)
        end
    end)
    
    return SliderFrame
end

-- Fun莽茫o para criar Toggles (Mantida)
local function CreateToggle(name, text, defaultValue, valueKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, -20, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = ScrollFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 25)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(30, 30, 30)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleFrame
    
    local function refresh()
        local isEnabled = Config[valueKey]
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(30, 30, 30)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config[valueKey] = not Config[valueKey]
        refresh()
        
        if Config[valueKey .. "Toggle"] then
            Config[valueKey .. "Toggle"](Config[valueKey])
        end
    end)
    
    return ToggleFrame
end

-- Adicionar Sliders
CreateSlider("JumpSlider", "Super Pulo", 50, 200, Config.Jump, "Jump")
CreateSlider("SpeedSlider", "Super Velocidade", 16, 300, Config.Speed, "Speed")

-- Adicionar Toggles
CreateToggle("FlyToggle", "Voo (Fly)", Config.Fly, "Fly")
CreateSlider("FlySpeedSlider", "Velocidade de Voo", 20, 200, Config.FlySpeed, "FlySpeed")
CreateToggle("NoClipToggle", "NoClip", Config.NoClip, "NoClip")
CreateToggle("GodModeToggle", "God Mode (Invencibilidade)", Config.GodMode, "GodMode")
CreateToggle("ESPToggle", "ESP (Highlight)", Config.ESP, "ESP")
CreateToggle("HitboxToggle", "Hitbox Grande (5x)", Config.Hitbox, "Hitbox")
CreateToggle("InvisToggle", "Invisibilidade", Config.Invis, "Invis")

-- Ajustar CanvasSize
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)

-- L贸gica de Minimizar (Mantida)
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 524, 0, 40), "Out", "Quad", 0.2, true)
        MinimizeButton.Text = "鉃�"
    else
        MainFrame:TweenSize(UDim2.new(0, 524, 0, 524), "Out", "Quad", 0.2, true)
        MinimizeButton.Text = "鉃�"
    end
end)

-- L贸gica de Destruir (Mantida)
local function Cleanup()
    if Config.FlyToggle then Config.FlyToggle(false) end
    if Config.HitboxToggle then Config.HitboxToggle(false) end
    if Config.InvisToggle then Config.InvisToggle(false) end
    if Config.ESPToggle then Config.ESPToggle(false) end
    if Config.NoClipToggle then Config.NoClipToggle(false) end
    if Config.GodModeToggle then Config.GodModeToggle(false) end
    
    ScreenGui:Destroy()
    
    for _, conn in pairs(Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    
    Config = nil
    player = nil
end

DestroyButton.MouseButton1Click:Connect(Cleanup)

--==================================================
-- JUMP, SPEED (Otimizados)
--==================================================
local canJump = true
local function handleJump()
    if Config.Fly then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not root or hum.FloorMaterial == Enum.Material.Air then return end
    if Config.Jump <= 50 or not canJump then return end

    canJump = false
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(0, math.huge, 0)
    bv.Velocity = Vector3.new(0, Config.Jump, 0)
    bv.Parent = root
    
    task.delay(0.15, function() bv:Destroy() end)
    
    local conn
    conn = hum:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
        if hum.FloorMaterial ~= Enum.Material.Air then
            canJump = true
            conn:Disconnect()
        end
    end)
end
Connections.JumpRequest = UIS.JumpRequest:Connect(handleJump)
Config.JumpUpdate = function(value) end

local speedBV
local function updateSpeed(value)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hum then return end
    
    if value > 16 and not Config.Fly then
        hum.WalkSpeed = value
        
        if speedBV then speedBV:Destroy() speedBV = nil end
        if Connections.SpeedHeartbeat then Connections.SpeedHeartbeat:Disconnect() Connections.SpeedHeartbeat = nil end
    else
        hum.WalkSpeed = 16
        
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if not speedBV then
            speedBV = Instance.new("BodyVelocity")
            speedBV.MaxForce = Vector3.new(math.huge, 0, math.huge)
            speedBV.Parent = root
        end
        
        if not Connections.SpeedHeartbeat then
            Connections.SpeedHeartbeat = RunService.Heartbeat:Connect(function()
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    local velocity = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * value
                    speedBV.Velocity = velocity
                else
                    speedBV.Velocity = Vector3.zero
                end
            end)
        end
    end
end
Config.SpeedUpdate = function(value)
    updateSpeed(value)
end

--==================================================
-- FLY (Mantido: V7 Corrigido)
--==================================================
local flyActive = false
local flySpeed = 0

local function updateFly(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not root then return end
    
    flyActive = v
    flySpeed = Config.FlySpeed
    
    if v then
        hum.PlatformStand = true
        
        if speedBV then speedBV:Destroy() speedBV = nil end
        if Connections.SpeedHeartbeat then Connections.SpeedHeartbeat:Disconnect() Connections.SpeedHeartbeat = nil end
        
        local torso = hum.RigType == Enum.HumanoidRigType.R6 and char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not torso then return end
        
        local bg = Instance.new("BodyGyro", torso)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.cframe = torso.CFrame
        
        local bv = Instance.new("BodyVelocity", torso)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        Connections.FlyRenderStepped = RunService.RenderStepped:Connect(function()
            if not flyActive or not char or hum.Health <= 0 then
                flyActive = false
                Connections.FlyRenderStepped:Disconnect()
                return
            end
            
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            local moveVector = Vector3.new(0, 0, 0)
            local currentFlySpeed = Config.FlySpeed
            
            -- Movimento Horizontal (W/S/A/D)
            local moveDir = hum.MoveDirection
            local cameraCF = camera.CFrame
            
            if moveDir.Magnitude > 0 then
                -- Calcula a dire莽茫o de movimento relativa 脿 c芒mera
                local relativeVector = cameraCF:VectorToObjectSpace(moveDir)
                
                -- Movimento para frente/tr谩s (Z) - Corrigido na V7.1
                moveVector = moveVector - cameraCF.LookVector * relativeVector.Z * currentFlySpeed
                
                -- Movimento para os lados (X)
                moveVector = moveVector + cameraCF.RightVector * relativeVector.X * currentFlySpeed
            end
            
            -- Movimento Vertical (E/Q ou Espa莽o/Shift)
            if UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0, currentFlySpeed, 0)
            elseif UIS:IsKeyDown(Enum.KeyCode.Q) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveVector = moveVector - Vector3.new(0, currentFlySpeed, 0)
            end
            
            bv.velocity = moveVector
            
            -- Manter a rota莽茫o do personagem alinhada com a c芒mera
            bg.cframe = CFrame.new(bg.Parent.Position, bg.Parent.Position + camera.CFrame.LookVector)
        end)
        
        pcall(function()
            char.Animate.Disabled = true
            for i,v in next, hum:GetPlayingAnimationTracks() do
                v:AdjustSpeed(0)
            end
        end)
        
    else
        if Connections.FlyRenderStepped then Connections.FlyRenderStepped:Disconnect() Connections.FlyRenderStepped = nil end
        
        pcall(function()
            if char.Animate then char.Animate.Disabled = false end
            if torso and torso:FindFirstChildOfClass("BodyGyro") then torso:FindFirstChildOfClass("BodyGyro"):Destroy() end
            if torso and torso:FindFirstChildOfClass("BodyVelocity") then torso:FindFirstChildOfClass("BodyVelocity"):Destroy() end
        end)
        
        hum.PlatformStand = false
        updateSpeed(Config.Speed)
    end
end

Config.FlyToggle = function(v)
    updateFly(v)
end
Config.FlySpeedUpdate = function(value)
    flySpeed = value
end

--==================================================
-- NOCLIP (Evasivo: CFrame + PlatformStand Tempor谩rio)
--==================================================
local noClipActive = false
local function updateNoClip(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not root then return end
    
    noClipActive = v
    
    if v then
        -- T茅cnica de NoClip mais evasiva: CFrame + PlatformStand
        hum.PlatformStand = true
        root.CanCollide = false
        
        Connections.NoClipRenderStepped = RunService.RenderStepped:Connect(function()
            if not noClipActive or not char or hum.Health <= 0 then
                noClipActive = false
                Connections.NoClipRenderStepped:Disconnect()
                return
            end
            
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                -- Move o personagem usando CFrame para atravessar paredes
                root.CFrame = root.CFrame + moveDir * (hum.WalkSpeed / 60)
            end
        end)
    else
        if Connections.NoClipRenderStepped then Connections.NoClipRenderStepped:Disconnect() Connections.NoClipRenderStepped = nil end
        root.CanCollide = true
        hum.PlatformStand = false
    end
    
    -- Garante que o movimento n茫o seja interrompido
    hum.PlatformStand = false
end

Config.NoClipToggle = function(v)
    updateNoClip(v)
end

--==================================================
-- GOD MODE (Evasivo: Anula莽茫o de Dano + DisableHealthBar)
--==================================================
local originalMaxHealth = 100
local function updateGodMode(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hum then return end
    
    if v then
        -- Tenta desativar a barra de vida (evas茫o visual)
        pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)
        
        originalMaxHealth = hum.MaxHealth
        
        -- Anula莽茫o de dano no lado do cliente (o mais evasivo)
        Connections.TakeDamage = hum.TakeDamage:Connect(function(damage)
            return 0
        end)
        
        -- Loop para manter a vida cheia (fallback)
        Connections.GodModeLoop = RunService.Heartbeat:Connect(function()
            if hum and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    else
        pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true) end)
        
        if Connections.TakeDamage then Connections.TakeDamage:Disconnect() Connections.TakeDamage = nil end
        if Connections.GodModeLoop then Connections.GodModeLoop:Disconnect() Connections.GodModeLoop = nil end
        
        hum.MaxHealth = originalMaxHealth
        hum.Health = originalMaxHealth
    end
    
    hum.PlatformStand = false
end

Config.GodModeToggle = function(v)
    updateGodMode(v)
end

--==================================================
-- ANTI-DETEC脟脙O (Aprimorado)
--==================================================
pcall(function()
    -- Tenta desativar logs de erro (se o executor permitir)
    local oldPrint = print
    _G.print = function(...) end
    
    -- Tenta desativar notifica莽玫es e mensagens do sistema
    StarterGui:SetCore("SendNotification", function() return end)
    StarterGui:SetCore("ChatMakeSystemMessage", function() return end)
    
    -- Tenta bloquear o console (se o executor permitir)
    local console = game:GetService("ConsoleService")
    if console then
        console.Enabled = false
    end
end)

--==================================================
-- ESP, HITBOX, INVIS (Mantidos)
--==================================================
local ESPs = {}
local function updateESP(v)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = ESPs[p]
            
            if v then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Adornee = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = workspace
                    ESPs[p] = highlight
                end
            else
                if highlight then highlight:Destroy() ESPs[p] = nil end
            end
        end
    end
end
Config.ESPToggle = updateESP
Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p)
    if ESPs[p] then ESPs[p]:Destroy() ESPs[p] = nil end
end)

local hitboxes = {}
local function updateHitbox(v)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if v then
                    hitboxes[p] = {Size = root.Size, Transparency = root.Transparency, CanCollide = root.CanCollide}
                    root.Size = root.Size * 5
                    root.Transparency = 1
                    root.CanCollide = false
                else
                    if hitboxes[p] then 
                        root.Size = hitboxes[p].Size
                        root.Transparency = hitboxes[p].Transparency
                        root.CanCollide = hitboxes[p].CanCollide
                        hitboxes[p] = nil
                    end
                end
            end
        end
    end
end
Config.HitboxToggle = updateHitbox

local invisSaved = {}
local function updateInvis(v)
    local char = player.Character
    if not char then return end
    
    for _, o in ipairs(char:GetDescendants()) do
        if o:IsA("BasePart") then
            if v then
                invisSaved[o] = {T = o.Transparency, C = o.CanCollide, M = o.Material}
                o.Transparency = 1
                o.CanCollide = false
                o.Material = Enum.Material.ForceField
            else
                local d = invisSaved[o]
                if d then 
                    o.Transparency = d.T 
                    o.CanCollide = d.C 
                    o.Material = d.M
                end
            end
        end
    end
    
    if not v then table.clear(invisSaved) end
end
Config.InvisToggle = updateInvis

--==================================================
-- RESPAWN SAFE (Mantido)
--==================================================
Connections.CharacterAdded = player.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    
    canJump = true
    
    Config.ESPToggle(Config.ESP)
    Config.InvisToggle(Config.Invis)
    Config.NoClipToggle(Config.NoClip)
    Config.GodModeToggle(Config.GodMode)
    
    if Config.Fly then Config.FlyToggle(true) end
    
    updateSpeed(Config.Speed)
end)

--==================================================
-- NOTIFICA脟脙O
--==================================================
StarterGui:SetCore("SendNotification", {
    Title = "馃幆 Yookiiy V8";
    Text = "Carregado com sucesso!\nEvas茫o Extrema Ativada.";
    Duration = 5;
})
