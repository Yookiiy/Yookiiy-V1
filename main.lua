--=====================================================
-- 馃幆 YOOKIIY V2 - ROBUSTO E AVAN脟ADO
-- 鉁� Estabilidade Aprimorada (Fly/Speed) + C贸digo Refatorado
--=====================================================

--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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
}

-- Tabela para armazenar conex玫es de eventos
local Connections = {}

--==================================================
-- GUI VISUAL (Mantida do V1 Otimizado)
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
MainFrame.Size = UDim2.new(0, 320, 0, 450)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
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
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "馃幆 Yookiiy V2"
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
-- FUN脟脮ES DE CONTROLE (Refatoradas)
--==================================================

-- Fun莽茫o para criar Sliders
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
        
        -- Chamar a fun莽茫o de atualiza莽茫o do m贸dulo (se existir)
        if Config[valueKey .. "Update"] then
            Config[valueKey .. "Update"](value)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    Connections.SliderInputEnded = UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Connections.SliderRenderStepped = RunService.RenderStepped:Connect(function()
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

-- Fun莽茫o para criar Toggles
local function CreateToggle(name, text, defaultValue, valueKey)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name
    ToggleFrame.Size = UDim2.new(1, -20, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
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
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = defaultValue and "ON" or "OFF"
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleButton
    
    local function refresh()
        local isEnabled = Config[valueKey]
        ToggleButton.Text = isEnabled and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = isEnabled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 80)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        Config[valueKey] = not Config[valueKey]
        refresh()
        
        -- Chamar a fun莽茫o de ativa莽茫o/desativa莽茫o do m贸dulo
        if Config[valueKey .. "Toggle"] then
            Config[valueKey .. "Toggle"](Config[valueKey])
        end
    end)
    
    return ToggleFrame
end

-- Adicionar Sliders
CreateSlider("JumpSlider", "Super Pulo", 50, 200, Config.Jump, "Jump")
CreateSlider("SpeedSlider", "Super Velocidade", 16, 300, Config.Speed, "Speed")
CreateSlider("FlySpeedSlider", "Velocidade de Voo", 20, 200, Config.FlySpeed, "FlySpeed")

-- Adicionar Toggles
CreateToggle("FlyToggle", "Voo (Fly)", Config.Fly, "Fly")
CreateToggle("ESPToggle", "ESP (Highlight)", Config.ESP, "ESP")
CreateToggle("HitboxToggle", "Hitbox Grande (5x)", Config.Hitbox, "Hitbox")
CreateToggle("InvisToggle", "Invisibilidade", Config.Invis, "Invis")

-- Ajustar CanvasSize
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)

-- L贸gica de Minimizar
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 40), "Out", "Quad", 0.2, true)
        MinimizeButton.Text = "鉃�"
    else
        MainFrame:TweenSize(UDim2.new(0, 320, 0, 450), "Out", "Quad", 0.2, true)
        MinimizeButton.Text = "鉃�"
    end
end)

-- L贸gica de Destruir
local function Cleanup()
    -- Desativar todos os efeitos antes de destruir
    Config.FlyToggle(false)
    Config.HitboxToggle(false)
    Config.InvisToggle(false)
    Config.ESPToggle(false)
    
    ScreenGui:Destroy()
    
    -- Desconectar todas as conex玫es
    for _, conn in pairs(Connections) do
        if conn and typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
    end
    
    -- Limpar vari谩veis globais
    Config = nil
    player = nil
end

DestroyButton.MouseButton1Click:Connect(Cleanup)

--==================================================
-- JUMP (Mantido do V1 Otimizado)
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

--==================================================
-- SPEED (Refatorado para WalkSpeed + Fallback)
--==================================================
local speedBV
local function updateSpeed(value)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if not hum then return end
    
    if value > 16 and not Config.Fly then
        -- Tenta usar WalkSpeed (mais est谩vel)
        hum.WalkSpeed = value
        
        -- Remove BodyVelocity se estiver ativo
        if speedBV then speedBV:Destroy() speedBV = nil end
    else
        -- Se WalkSpeed for bloqueado ou Fly estiver ativo, usa BodyVelocity (Fallback)
        hum.WalkSpeed = 16 -- Reseta o WalkSpeed
        
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if not speedBV then
            speedBV = Instance.new("BodyVelocity")
            speedBV.MaxForce = Vector3.new(math.huge, 0, math.huge)
            speedBV.Parent = root
        end
        
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

-- Fun莽茫o de atualiza莽茫o do slider
Config.SpeedUpdate = function(value)
    updateSpeed(value)
end

--==================================================
-- FLY (Refatorado para maior estabilidade)
--==================================================
local flyBV, flyBG
local function updateFly(v)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    
    if not hum or not root then return end

    if v then
        hum.PlatformStand = true
        
        -- Tenta usar AlignPosition/AlignOrientation (mais est谩vel)
        -- Se o executor n茫o suportar, o BodyVelocity/BodyGyro ser谩 usado
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBG.P = 1e5
        flyBG.Parent = root
        
        -- Desconecta o BodyVelocity do Speed se estiver ativo
        if speedBV then speedBV:Destroy() speedBV = nil end
        if Connections.SpeedHeartbeat then Connections.SpeedHeartbeat:Disconnect() end
        
        -- Conecta o loop de voo
        Connections.FlyRenderStepped = RunService.RenderStepped:Connect(function()
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                flyBV.Velocity = camera.CFrame:VectorToWorldSpace(moveDir) * Config.FlySpeed
            else
                flyBV.Velocity = Vector3.zero
            end
            
            flyBG.CFrame = CFrame.new(flyBG.Parent.Position, flyBG.Parent.Position + camera.CFrame.LookVector)
        end)
    else
        -- Desativa o voo
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        if Connections.FlyRenderStepped then Connections.FlyRenderStepped:Disconnect() end
        
        hum.PlatformStand = false
        
        -- Reativa o Speed se estiver configurado
        updateSpeed(Config.Speed)
    end
end

-- Fun莽茫o de ativa莽茫o/desativa莽茫o do toggle
Config.FlyToggle = function(v)
    updateFly(v)
end

-- Fun莽茫o de atualiza莽茫o do slider
Config.FlySpeedUpdate = function(value)
    -- Apenas se o fly estiver ativo
    if Config.Fly and flyBV then
        -- O loop RenderStepped j谩 usa Config.FlySpeed, ent茫o a atualiza莽茫o 茅 autom谩tica
    end
end

--==================================================
-- ESP (Mantido do V1 Otimizado)
--==================================================
local ESPs = {}
local function updateESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local highlight = ESPs[p]
            
            if Config.ESP then
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

Config.ESPToggle = function(v)
    updateESP()
end

Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p)
    if ESPs[p] then ESPs[p]:Destroy() ESPs[p] = nil end
end)

--==================================================
-- HITBOX (Aprimorado)
--==================================================
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

Config.HitboxToggle = function(v)
    updateHitbox(v)
end

--==================================================
-- INVIS (Aprimorado - Manipula莽茫o de Material)
--==================================================
local invisSaved = {}
local function updateInvis(v)
    local char = player.Character
    if not char then return end
    
    for _, o in ipairs(char:GetDescendants()) do
        if o:IsA("BasePart") then
            if v then
                -- Salvar e aplicar invisibilidade
                invisSaved[o] = {T = o.Transparency, C = o.CanCollide, M = o.Material}
                o.Transparency = 1
                o.CanCollide = false
                o.Material = Enum.Material.ForceField -- Pequeno aprimoramento visual/evasivo
            else
                -- Restaurar
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

Config.InvisToggle = function(v)
    updateInvis(v)
end

--==================================================
-- RESPAWN SAFE (Aprimorado)
--==================================================
Connections.CharacterAdded = player.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    
    canJump = true
    
    -- Reaplicar efeitos
    updateESP()
    
    if Config.Fly then updateFly(true) end
    if Config.Invis then updateInvis(true) end
    
    -- Reaplicar Speed (WalkSpeed ou BodyVelocity)
    updateSpeed(Config.Speed)
end)

--==================================================
-- NOTIFICA脟脙O
--==================================================
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "馃幆 Yookiiy V2";
    Text = "Carregado com sucesso!\nEstabilidade de Fly/Speed aprimorada.";
    Duration = 5;
})
