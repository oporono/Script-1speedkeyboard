local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChild("Humanoid")
end

local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local flying = false
local noclip = false
local infJump = false
local autoStep = false
local frozen = false
local stepDelay = 0.05

local function setNoclip(state)
    noclip = state
    local c = getChar()
    if c then
        for _, part in pairs(c:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

local function toggleFly(state)
    flying = state
    if flying then
        local root = getRoot()
        if not root then return end
        local bg = Instance.new("BodyGyro", root)
        bg.P = 9e4
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        local bv = Instance.new("BodyVelocity", root)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            while flying and root and root.Parent do
                local cam = workspace.CurrentCamera
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
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    end
end

local function toggleFreeze(state)
    frozen = state
    local root = getRoot()
    if root then
        if frozen then
            local bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.new(0,0,0)
            spawn(function()
                while frozen and root and root.Parent and bv do
                    bv.Velocity = Vector3.new(0,0,0)
                    task.wait()
                end
                if bv then bv:Destroy() end
            end)
        else
            for _, v in pairs(root:GetChildren()) do
                if v:IsA("BodyVelocity") then v:Destroy() end
            end
        end
    end
end

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- =======================================================
--  ГЛАВНОЕ МЕНЮ
-- =======================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 780, 0, 530)
mainFrame.Position = UDim2.new(0.5, -390, 0.5, -265)
mainFrame.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Шапка
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 55)
topBar.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(0, 120, 1, 0)
logo.Position = UDim2.new(0, 15, 0, 0)
logo.Text = "FLONSY HUB"
logo.TextColor3 = Color3.fromRGB(255, 68, 68)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 20
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.BackgroundTransparency = 1
logo.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0.5, -20)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(102, 102, 119)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 18
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Сайдбар
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 60, 1, -55)
sidebar.Position = UDim2.new(0, 0, 0, 55)
sidebar.BackgroundColor3 = Color3.fromRGB(21, 21, 27)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local currentPage = "Main"
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -60, 1, -55)
contentFrame.Position = UDim2.new(0, 60, 0, 55)
contentFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 23)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local function createSidebarButton(name, icon, yPos, pageName)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 55)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.Text = ""
    btn.BackgroundTransparency = 1
    btn.Parent = sidebar
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = icon .. "\n" .. name
    lbl.TextColor3 = Color3.fromRGB(85, 85, 102)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.BackgroundTransparency = 1
    lbl.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, child in pairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundTransparency = 1
                for _, c in pairs(child:GetChildren()) do
                    if c:IsA("TextLabel") then
                        c.TextColor3 = Color3.fromRGB(85, 85, 102)
                    end
                end
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(31, 31, 40)
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentPage = pageName
        updatePage()
    end)
    return btn
end

local btnMain = createSidebarButton("Main", "🏠", 0, "Main")
local btnAuto = createSidebarButton("Auto", "🤖", 55, "Automatically")
local btnShop = createSidebarButton("Shop", "🛒", 110, "Shop")
local btnMisc = createSidebarButton("Misc", "⚙️", 165, "Misc")

btnMain.BackgroundColor3 = Color3.fromRGB(31, 31, 40)
for _, c in pairs(btnMain:GetChildren()) do if c:IsA("TextLabel") then c.TextColor3 = Color3.fromRGB(255, 255, 255) end end

-- =======================================================
--  УТИЛИТЫ UI
-- =======================================================
local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
end

local function createRow(parent, yPos, text, icon, defaultState, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 28)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Text = icon .. " " .. text
    label.TextColor3 = Color3.fromRGB(208, 208, 216)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = row
    
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -32, 0.5, -8)
    switch.BackgroundColor3 = defaultState and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(51, 51, 62)
    switch.BorderSizePixel = 0
    switch.Parent = row
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = defaultState and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    
    local state = defaultState
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        state = not state
        switch.BackgroundColor3 = state and Color3.fromRGB(255, 68, 68) or Color3.fromRGB(51, 51, 62)
        knob.Position = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        if callback then callback(state) end
    end)
    return row
end

local function createDropdown(parent, yPos, label, items, defaultText, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 36)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200, 1, 0)
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(208, 208, 216)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = row
    
    local dropBtn = Instance.new("TextButton")
    dropBtn.Size = UDim2.new(0, 110, 0, 26)
    dropBtn.Position = UDim2.new(1, -110, 0.5, -13)
    dropBtn.Text = defaultText .. "  ▼"
    dropBtn.TextColor3 = Color3.fromRGB(221, 221, 221)
    dropBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    dropBtn.Font = Enum.Font.Gotham
    dropBtn.TextSize = 12
    dropBtn.BorderSizePixel = 0
    dropBtn.Parent = row
    
    local menu = Instance.new("Frame")
    menu.Size = UDim2.new(0, 110, 0, #items * 26)
    menu.Position = UDim2.new(1, -110, 0, 26)
    menu.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.Parent = row
    
    for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 26)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*26)
        opt.Text = item
        opt.TextColor3 = Color3.fromRGB(204, 204, 204)
        opt.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 12
        opt.BorderSizePixel = 0
        opt.Parent = menu
        opt.MouseButton1Click:Connect(function()
            dropBtn.Text = item .. "  ▼"
            menu.Visible = false
            if callback then callback(item) end
        end)
    end
    
    dropBtn.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    return row
end

local function createSlider(parent, yPos, label, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 40)
    row.Position = UDim2.new(0, 10, 0, yPos)
    row.BackgroundTransparency = 1
    row.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.Text = label .. "   " .. tostring(defaultVal) .. "/" .. tostring(maxVal)
    lbl.TextColor3 = Color3.fromRGB(187, 187, 187)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = row
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0, 22)
    bar.BackgroundColor3 = Color3.fromRGB(42, 42, 53)
    bar.BorderSizePixel = 0
    bar.Parent = row
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(defaultVal/maxVal, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 68, 68)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    
    local dragging = false
    local function updateVal(val)
        val = math.clamp(math.floor(val), 0, maxVal)
        fill.Size = UDim2.new(val/maxVal, 0, 1, 0)
        lbl.Text = label .. "   " .. tostring(val) .. "/" .. tostring(maxVal)
        if callback then callback(val) end
    end
    
    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(1, 0, 1, 0)
    dragBtn.BackgroundTransparency = 1
    dragBtn.Parent = bar
    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    dragBtn.MouseButton1Up:Connect(function()
        dragging = false
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X
            local relative = pos - bar.AbsolutePosition.X
            local percent = math.clamp(relative / bar.AbsoluteSize.X, 0, 1)
            updateVal(percent * maxVal)
        end
    end)
    return row
end

local function createBlockButton(parent, yPos, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(221, 221, 221)
    btn.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createHeader(parent, text, icon)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, -20, 0, 30)
    h.Position = UDim2.new(0, 10, 0, 8)
    h.BackgroundTransparency = 1
    h.Parent = parent
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = icon .. "  " .. text
    lbl.TextColor3 = Color3.fromRGB(238, 238, 238)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    lbl.Parent = h
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 1, 0)
    line.BackgroundColor3 = Color3.fromRGB(37, 37, 48)
    line.BorderSizePixel = 0
    line.Parent = h
    return h
end

local function createColumn(parent, xPos)
    local col = Instance.new("Frame")
    col.Size = UDim2.new(0, 330, 1, -30)
    col.Position = UDim2.new(0, xPos, 0, 15)
    col.BackgroundColor3 = Color3.fromRGB(24, 24, 31)
    col.BorderSizePixel = 0
    col.Parent = parent
    return col
end

-- =======================================================
--  ОТРИСОВКА СТРАНИЦ
-- =======================================================
local function updatePage()
    clearContent()
    
    if currentPage == "Main" then
        local leftCol = createColumn(contentFrame, 15)
        local rightCol = createColumn(contentFrame, 370)
        
        createHeader(leftCol, "Farming Station", "🏃")
        createHeader(rightCol, "Treadmill Settings", "🕒")
        
        createRow(leftCol, 45, "Auto Run (Step Farm)", "▶️", false, function(state)
            autoStep = state
            if autoStep then
                spawn(function()
                    while autoStep do
                        local c = getChar()
                        if not c then break end
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
                        task.wait(0.02)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
                        task.wait(stepDelay)
                    end
                end)
            end
        end)
        
        local teleportLocations = {
            ["Spawn Point"] = workspace.SpawnLocation and workspace.SpawnLocation.Position or Vector3.new(0, 5, 0),
            ["Center"] = Vector3.new(0, 10, 0),
            ["Top of Map"] = Vector3.new(0, 250, 0),
            ["Shop"] = workspace:FindFirstChild("Shop") and workspace.Shop.Position or Vector3.new(20, 5, 20)
        }
        
        local currentTpTarget = "Spawn Point"
        createDropdown(leftCol, 80, "Select Win Target World 1", {"Spawn Point", "Center", "Top of Map", "Shop"}, "Spawn Point", function(val)
            currentTpTarget = val
        end)
        
        createBlockButton(leftCol, 120, "Teleport To Target", function()
            local root = getRoot()
            if root and teleportLocations[currentTpTarget] then
                root.CFrame = CFrame.new(teleportLocations[currentTpTarget])
            end
        end)
        
        createDropdown(leftCol, 160, "Select Win Target World 2", {"Win 250k", "Win 500k", "Win 1M"}, "Win 250k", function(val) end)
        createRow(leftCol, 195, "Auto Farm Wins", "🏆", false, function(state) end)
        
        createSlider(leftCol, 230, "Tween Speed (Walk)", 500, 16, function(val)
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = val end
        end)
        
        createRow(leftCol, 280, "Auto Rebirth", "🔄", false, function(state)
            if state then
                if game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") then
                    game:GetService("ReplicatedStorage").Rebirth:FireServer()
                end
            end
        end)
        createRow(leftCol, 315, "Freeze Position", "❄️", false, function(state) toggleFreeze(state) end)
        
        createDropdown(rightCol, 45, "Select Treadmill Type", {"Diamond", "Gold", "Silver", "Bronze"}, "Diamond", function(val) end)
        createBlockButton(rightCol, 90, "Bypass Treadmill Access (Unlock)", function() print("Bypassed!") end)
        createBlockButton(rightCol, 125, "Unlock Infinity Trail", function()
            if game:GetService("ReplicatedStorage"):FindFirstChild("InfinityTrail") then
                game:GetService("ReplicatedStorage").InfinityTrail:FireServer()
            end
        end)
        
    elseif currentPage == "Automatically" then
        local col = createColumn(contentFrame, 15)
        createHeader(col, "Auto Settings", "⚡")
        createRow(col, 45, "Auto Rebirth", "🔄", false, function(state) end)
        createRow(col, 80, "Auto Farm", "💎", false, function(state) end)
        createRow(col, 115, "Auto Collect", "📦", false, function(state) end)
        createRow(col, 150, "Auto Sell", "💰", false, function(state) end)
        
    elseif currentPage == "Shop" then
        local col = createColumn(contentFrame, 15)
        createHeader(col, "Shop Items", "🛍️")
        createBlockButton(col, 45, "Buy Speed Boost", function() end)
        createBlockButton(col, 80, "Buy Infinity Trail", function() end)
        createBlockButton(col, 115, "Buy Auto Rebirth", function() end)
        
    elseif currentPage == "Misc" then
        local col = createColumn(contentFrame, 15)
        createHeader(col, "Movement & Utility", "⚙️")
        
        createRow(col, 45, "Fly Mode", "✈️", false, function(state) toggleFly(state) end)
        createRow(col, 80, "NoClip", "🚪", false, function(state) setNoclip(state) end)
        createRow(col, 115, "Inf Jump", "⬆️", false, function(state) infJump = state end)
        createRow(col, 150, "Reset Speed (16)", "⏮️", false, function(state) 
            if state then 
                local hum = getHumanoid()
                if hum then hum.WalkSpeed = 16 end
            end 
        end)
    end
end

-- =======================================================
--  ФУТЕР
-- =======================================================
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
footer.BorderSizePixel = 0
footer.Parent = mainFrame

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, 0, 1, 0)
footerText.Text = "Flonsy · Speed Keyboard Escape  BETA VERSION"
footerText.Te
