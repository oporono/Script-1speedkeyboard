-- 1 Speed Keyboard для Delta Executor
-- Бро, жми на кнопки и лети!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Создаём GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Кнопка Speed 1
local speed1Btn = Instance.new("TextButton")
speed1Btn.Size = UDim2.new(0, 80, 0, 40)
speed1Btn.Position = UDim2.new(0, 10, 0, 100)
speed1Btn.Text = "Speed 1"
speed1Btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speed1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
speed1Btn.Parent = screenGui

speed1Btn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 16 -- Стандарт
end)

-- Кнопка Speed 50
local speed2Btn = Instance.new("TextButton")
speed2Btn.Size = UDim2.new(0, 80, 0, 40)
speed2Btn.Position = UDim2.new(0, 10, 0, 150)
speed2Btn.Text = "Speed 50"
speed2Btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
speed2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
speed2Btn.Parent = screenGui

speed2Btn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 50 -- Быстро
end)

-- Кнопка Speed 100
local speed3Btn = Instance.new("TextButton")
speed3Btn.Size = UDim2.new(0, 80, 0, 40)
speed3Btn.Position = UDim2.new(0, 10, 0, 200)
speed3Btn.Text = "Speed 100"
speed3Btn.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
speed3Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
speed3Btn.Parent = screenGui

speed3Btn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 100 -- Очень быстро
end)

-- Кнопка Speed 500 (УЛЬТРА)
local speed4Btn = Instance.new("TextButton")
speed4Btn.Size = UDim2.new(0, 80, 0, 40)
speed4Btn.Position = UDim2.new(0, 10, 0, 250)
speed4Btn.Text = "Speed 500"
speed4Btn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
speed4Btn.TextColor3 = Color3.fromRGB(0, 0, 0)
speed4Btn.Parent = screenGui

speed4Btn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 500 -- Улёт
end)

-- Кнопка Сброс
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 80, 0, 40)
resetBtn.Position = UDim2.new(0, 10, 0, 300)
resetBtn.Text = "Сброс"
resetBtn.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Parent = screenGui

resetBtn.MouseButton1Click:Connect(function()
    humanoid.WalkSpeed = 16
end)

print("Скрипт 1 Speed Keyboard загружен! Бро, лети!")
