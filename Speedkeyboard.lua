-- Flonsy Hub v4 | 1 Speed Keyboard Edition
-- Только нужные функции!

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- Состояния
local flying = false
local noclip = false
local infJump = false
local autoStep = false
local stepDelay = 0.05

-- NoClip
local function setNoclip(state)
    noclip = state
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 380)
frame.Position = UDim2.new(0, 10, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "Flonsy Hub | 1 Speed"
title.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = frame

local function createButton(text, y, color, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 11
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- WalkSpeed
createButton("Speed 16", 30, Color3.fromRGB(50, 50, 50), function() humanoid.WalkSpeed = 16 end)
createButton("Speed 50", 62, Color3.fromRGB(0, 150, 0), function() humanoid.WalkSpeed = 50 end)
createButton("Speed 100", 94, Color3.fromRGB(0, 100, 200), function() humanoid.WalkSpeed = 100 end)
createButton("Speed 200", 126, Color3.fromRGB(200, 200, 0), function() humanoid.WalkSpeed = 200 end)
createButton("Speed 500", 158, Color3.fromRGB(200, 0, 0), function() humanoid.WalkSpeed = 500 end)
createButton("Reset Speed", 190, Color3.fromRGB(100, 100, 100), function() humanoid.WalkSpeed = 16 end)

-- Разделитель
local d1 = Instance.new("Frame")
d1.Size = UDim2.new(1, -10, 0, 1)
d1.Position = UDim2.new(0, 5, 0, 222)
d1.BackgroundColor3 = Color3.fromRGB(255, 80, 0)
d1.Parent = frame

-- Auto Step
local autoBtn = createButton("Auto Step: OFF", 228, Color3.fromRGB(100, 100, 100), function()
    autoStep = not autoStep
    if autoStep then
        autoBtn.Text = "Auto Step: ON"
        autoBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        spawn(function()
            while autoStep and character do
                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.02)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
                task.wait(stepDelay)
            end
        end)
    else
        autoBtn.Text = "Auto Step: OFF"
        autoBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Fly
local flyBtn = createButton("Fly: OFF", 260, Color3.fromRGB(100, 100, 100), function()
    flying = not flying
    if flying then
        flyBtn.Text = "Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            while flying and root do
                bg.CFrame = cam.CFrame
                local dir = Vector3.new()
                local UIS = game:GetService("UserInputService")
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                bv.Velocity = dir * 100
                task.wait()
            end
            bg:Destroy()
            bv:Destroy()
        end)
    else
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- NoClip
local noclipBtn = createButton("NoClip: OFF", 292, Color3.fromRGB(100, 100, 100), function()
    noclip = not noclip
    setNoclip(noclip)
    if noclip then
        noclipBtn.Text = "NoClip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        noclipBtn.Text = "NoClip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Inf Jump
local jumpBtn = createButton("Inf Jump: OFF", 324, Color3.fromRGB(100, 100, 100), function()
    infJump = not infJump
    if infJump then
        jumpBtn.Text = "Inf Jump: ON"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        jumpBtn.Text = "Inf Jump: OFF"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and character then
        character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Teleport
local teleBtn = createButton("Teleport (Click)", 356, Color3.fromRGB(150, 0, 200), function()
    local mouse = player:GetMouse()
    mouse.Button1Down:Connect(function()
        if root then
            root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
        end
    end)
end)

-- Респавн
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    root = newChar:WaitForChild("HumanoidRootPart")
    if noclip then
        task.wait(0.5)
        setNoclip(true)
    end
end)

print("Flonsy Hub | 1 Speed Edition загружен! Погнали, бро!")
