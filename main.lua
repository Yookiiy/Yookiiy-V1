-- =======================
-- GUI MOBILE - Yookiiy V1
-- =======================
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "YookiiyGUI"
gui.ResetOnSpawn = false

local Values = player.PlayerGui:WaitForChild("CheatValues")

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.35, 0.45)
main.Position = UDim2.fromScale(0.05, 0.15)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Name = "Main"

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "Yookiiy V1"
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Left
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

local by = Instance.new("TextLabel", main)
by.Size = UDim2.new(1,-40,0,30)
by.Position = UDim2.new(0,0,0,0)
by.BackgroundTransparency = 1
by.Text = "By Github"
by.TextColor3 = Color3.new(1,1,1)
by.TextXAlignment = Right
by.Font = Enum.Font.SourceSans
by.TextSize = 14

-- CLOSE (X)
local close = Instance.new("TextButton", main)
close.Size = UDim2.fromOffset(25,25)
close.Position = UDim2.new(1,-28,0,3)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(170,0,0)
close.TextColor3 = Color3.new(1,1,1)

-- MINIMIZE
local min = Instance.new("TextButton", main)
min.Size = UDim2.fromOffset(25,25)
min.Position = UDim2.new(1,-58,0,3)
min.Text = "-"
min.BackgroundColor3 = Color3.fromRGB(40,40,40)
min.TextColor3 = Color3.new(1,1,1)

-- CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,0,0,35)
container.Size = UDim2.new(1,0,1,-35)
container.BackgroundTransparency = 1

-- UI LIST
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,8)

-- =======================
-- HELPERS
-- =======================
local function toggle(text, value)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(1,-10,0,35)
    b.Text = text.." : OFF"
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.TextColor3 = Color3.new(1,1,1)

    b.MouseButton1Click:Connect(function()
        value.Value = not value.Value
        b.Text = text.." : "..(value.Value and "ON" or "OFF")
    end)

    value.Changed:Connect(function(v)
        b.Text = text.." : "..(v and "ON" or "OFF")
    end)
end

local function slider(text, min, max, value)
    local f = Instance.new("Frame", container)
    f.Size = UDim2.new(1,-10,0,45)
    f.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,0,20)
    lbl.Text = text..": "..value.Value
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Left

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1,0,0,15)
    bar.Position = UDim2.new(0,0,0,25)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    fill.Size = UDim2.new((value.Value-min)/(max-min),0,1,0)

    local dragging = false

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    bar.InputEnded:Connect(function()
        dragging = false
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if dragging then
            local x = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
            local val = math.floor(min + (max-min)*x)
            value.Value = val
            fill.Size = UDim2.new(x,0,1,0)
            lbl.Text = text..": "..val
        end
    end)
end

-- =======================
-- ELEMENTS
-- =======================
slider("Speed",16,200, Values.Speed)
slider("Jump",50,200, Values.Jump)

toggle("ESP", Values.ESP)
toggle("Hitbox", Values.Hitbox)
toggle("Invis", Values.Invis)

-- Fly speed input
local flyBox = Instance.new("TextBox", container)
flyBox.Size = UDim2.new(1,-10,0,35)
flyBox.PlaceholderText = "Fly Speed (max 500)"
flyBox.Text = ""
flyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
flyBox.TextColor3 = Color3.new(1,1,1)

flyBox.FocusLost:Connect(function()
    local v = tonumber(flyBox.Text)
    if v then
        Values.FlySpeed.Value = math.clamp(v,1,500)
    end
end)

-- =======================
-- MINIMIZE / CLOSE
-- =======================
local minimized = false

min.MouseButton1Click:Connect(function()
    minimized = not minimized
    container.Visible = not minimized
    min.Text = minimized and "+" or "-"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
    if player.PlayerGui:FindFirstChild("CheatValues") then
        player.PlayerGui.CheatValues:Destroy()
    end
end)
