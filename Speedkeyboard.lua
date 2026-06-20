--[[
    Speed Hub | AutoStep + Speed Control
    by OrvaEvncp (Inspired)
    Объединённый функционал для Роблокс
]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Параметры автошага
local autoStepEnabled = false
local stepDelay = 0.05
local VIM = game:GetService("VirtualInputManager")

-- Создаём GUI (похоже на Orva + LuxyHub)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Основная рамка (тёмная, как у Orva)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 140, 0, 260)
frame.Position = UDim2.new(0, 10, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Заголовок (оранжевый, как у Orva)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "Speed Hub v2"
title.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = frame

-- Функция для создания кнопок
local function createButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 
createButton("Speed 16", 30, Color3.fromRGB(50, 50, 50), function()
    humanoid.WalkSpeed = 16
    autoStepEnabled = false
end)

createButton("Speed 50", 60, Color3.fromRGB(0, 150, 0), function()
    humanoid.WalkSpeed = 50
    autoStepEnabled = false
end)

createButton("Speed 100", 90, Color3.fromRGB(0, 100, 200), function()
    humanoid.WalkSpeed = 100
    autoStepEnabled = false
end)

createButton("Speed 200", 120, Color3.fromRGB(200, 200, 0), function()
    humanoid.WalkSpeed = 200
    autoStepEnabled = false
end)

createButton("Speed 500", 150, Color3.fromRGB(200, 0, 0), function()
    humanoid.WalkSpeed = 500
    autoStepEnabled = false
end)

createButton("Reset Speed", 180, Color3.fromRGB(100, 100, 100), function()
    humanoid.WalkSpeed = 16
    autoStepEnabled = false
end)

-- Разделитель
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -10, 0, 1)
divider.Position = UDim2.new(0, 5, 0, 215)
divider.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
divider.Parent = frame

-- Кнопка АВТО-ШАГ (фишка LuxyHub)
local autoBtn = createButton("AUTO STEP: OFF", 220, Color3.fromRGB(100, 100, 100), function()
    autoStepEnabled = not autoStepEnabled
    if autoStepEnabled then
        autoBtn.Text = "AUTO STEP: ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        -- Запускаем цикл шагов
        spawn(function()
            while autoStepEnabled and player.Character do
                VIM:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                wait(0.02)
                VIM:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                wait(stepDelay)
            end
        end)
    else
        autoBtn.Text = "AUTO STEP: OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

print("Speed Hub v2 загружен! Orva + LuxyHub стиль.")
