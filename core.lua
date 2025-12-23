-- CORE SCRIPT (jump, speed, fly, esp, hitbox, invis)

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- VALUES folder already exists from GUI
local Values = player:WaitForChild("PlayerGui"):WaitForChild("CheatValues")

local JumpValue = Values:WaitForChild("Jump")
local SpeedValue = Values:WaitForChild("Speed")
local FlySpeedValue = Values:WaitForChild("FlySpeed")
local ESPValue = Values:WaitForChild("ESP")
local HitboxValue = Values:WaitForChild("Hitbox")
local FlyValue = Values:WaitForChild("Fly")
local InvisValue = Values:WaitForChild("Invis")

-- (CORE SCRIPT CODE YOU SENT EARLIER GOES HERE)
-- paste the entire corrected script body here
-- this includes jump logic, speed logic, fly logic, esp logic,
-- hitbox logic, invis logic, and respawn safe handling
