local player = game.Players.LocalPlayer
local noclip = false

local function setNoclip(state)
    noclip = state
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 150, 0, 40)
btn.Position = UDim2.new(0.5, -75, 0.5, -20)
btn.Text = "NoClip: OFF"
btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 14
btn.Parent = screenGui

btn.MouseButton1Click:Connect(function()
    noclip = not noclip
    setNoclip(noclip)
    if noclip then
        btn.Text = "NoClip: ON"
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        btn.Text = "NoClip: OFF"
        btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

player.CharacterAdded:Connect(function(char)
    if noclip then
        task.wait(0.5)
        setNoclip(true)
    end
end)
