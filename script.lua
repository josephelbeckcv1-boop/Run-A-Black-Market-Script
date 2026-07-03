-- LocalScript in a ScreenGui
-- Full script with faster tweens (0.12s per dealer, 0.2s return)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Remotes
local sellRemote = ReplicatedStorage:FindFirstChild("Framework")
    and ReplicatedStorage.Framework:FindFirstChild("Library")
    and ReplicatedStorage.Framework.Library:FindFirstChild("Network")
    and ReplicatedStorage.Framework.Library.Network:FindFirstChild("F:SellStash")

if not sellRemote then
    warn("[Sell UI] Remote 'F:SellStash' not found.")
    return
end

local buyRemote = ReplicatedStorage:FindFirstChild("Framework")
    and ReplicatedStorage.Framework:FindFirstChild("Library")
    and ReplicatedStorage.Framework.Library:FindFirstChild("Network")
    and ReplicatedStorage.Framework.Library.Network:FindFirstChild("F:BuyDealer")

if not buyRemote then
    warn("[Sell UI] Remote 'F:BuyDealer' not found.")
    return
end

local categories = {
    "Relics",
    "Gadgets",
    "Potions",
    "Weapons",
    "Artifacts",
    "Contraband"
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SellUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -34, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Sell / Collect / Auto Buy | End to close"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -28, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 4)

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = contentFrame

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 8)
padding.Parent = contentFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = contentFrame
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

local sellBtn = Instance.new("TextButton")
sellBtn.Size = UDim2.new(1, -20, 0, 34)
sellBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
sellBtn.Text = "SELL ALL"
sellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sellBtn.TextSize = 12
sellBtn.Font = Enum.Font.GothamBold
sellBtn.BorderSizePixel = 0
sellBtn.Parent = contentFrame
Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 6)

local collectBtn = Instance.new("TextButton")
collectBtn.Size = UDim2.new(1, -20, 0, 34)
collectBtn.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
collectBtn.Text = "COLLECT ALL"
collectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
collectBtn.TextSize = 12
collectBtn.Font = Enum.Font.GothamBold
collectBtn.BorderSizePixel = 0
collectBtn.Parent = contentFrame
Instance.new("UICorner", collectBtn).CornerRadius = UDim.new(0, 6)

local autoBuyBtn = Instance.new("TextButton")
autoBuyBtn.Size = UDim2.new(1, -20, 0, 34)
autoBuyBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
autoBuyBtn.Text = "AUTO BUY"
autoBuyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
autoBuyBtn.TextSize = 12
autoBuyBtn.Font = Enum.Font.GothamBold
autoBuyBtn.BorderSizePixel = 0
autoBuyBtn.Parent = contentFrame
Instance.new("UICorner", autoBuyBtn).CornerRadius = UDim.new(0, 6)

local endBtn = Instance.new("TextButton")
endBtn.Size = UDim2.new(1, -20, 0, 34)
endBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
endBtn.Text = "END"
endBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
endBtn.TextSize = 12
endBtn.Font = Enum.Font.GothamBold
endBtn.BorderSizePixel = 0
endBtn.Parent = contentFrame
Instance.new("UICorner", endBtn).CornerRadius = UDim.new(0, 6)

local isRunning = false
local stopRequested = false
local isMinimized = false
local savedSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        savedSize = mainFrame.Size
        mainFrame.Size = UDim2.new(savedSize.X.Scale, savedSize.X.Offset, 0, 30)
        contentFrame.Visible = false
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = savedSize
        contentFrame.Visible = true
        minimizeBtn.Text = "−"
    end
end)

-- Parse price strings
local function parsePrice(str)
    if not str or str == "" then return 0 end
    local clean = str:gsub("[%s,%$%€%£]", "")
    clean = clean:lower()
    local multiplier = 1
    if clean:sub(-1) == "k" then
        multiplier = 1000
        clean = clean:sub(1, -2)
    elseif clean:sub(-1) == "m" then
        multiplier = 1000000
        clean = clean:sub(1, -2)
    elseif clean:sub(-1) == "b" then
        multiplier = 1000000000
        clean = clean:sub(1, -2)
    end
    local num = tonumber(clean)
    return (num or 0) * multiplier
end

local function sellCategory(category)
    local success, result = pcall(function()
        return sellRemote:InvokeServer(category)
    end)
    if not success then
        warn("[Sell UI] Failed on " .. category .. ": " .. tostring(result))
    end
    return success, result
end

local function collectAll()
    local character = player.Character
    if not character or not character:IsDescendantOf(workspace) then
        statusLabel.Text = "No character"
        return
    end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        statusLabel.Text = "No root part"
        return
    end

    local dealersFolder = workspace:FindFirstChild("Plots")
        and workspace.Plots:FindFirstChild("Plot3")
        and workspace.Plots.Plot3:FindFirstChild("Dealers")
    if not dealersFolder then
        statusLabel.Text = "Dealers folder not found"
        return
    end

    local dealers = dealersFolder:GetChildren()
    if #dealers == 0 then
        statusLabel.Text = "No dealers found"
        return
    end

    local startCFrame = rootPart.CFrame
    sellBtn.Visible = false
    collectBtn.Visible = false
    autoBuyBtn.Visible = false
    endBtn.Visible = false

    -- Faster tweens: 0.12s per dealer, 0.2s return
    for _, dealer in ipairs(dealers) do
        if stopRequested then break end
        local targetPos = nil
        if dealer:IsA("BasePart") then
            targetPos = dealer.Position
        elseif dealer:IsA("Model") then
            targetPos = dealer.PrimaryPart and dealer.PrimaryPart.Position or dealer:GetPivot().Position
        else
            local function findPart(inst)
                for _, child in ipairs(inst:GetChildren()) do
                    if child:IsA("BasePart") then return child end
                    if child:IsA("Model") then
                        local found = findPart(child)
                        if found then return found end
                    end
                end
                return nil
            end
            local part = findPart(dealer)
            if part then targetPos = part.Position end
        end
        if not targetPos then
            warn("[Collect] No position for", dealer.Name)
            continue
        end
        statusLabel.Text = "Moving to " .. dealer.Name
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.12, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
    end

    if not stopRequested then
        statusLabel.Text = "Returning..."
        local tween = TweenService:Create(rootPart, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = startCFrame})
        tween:Play()
        tween.Completed:Wait()
        statusLabel.Text = "Collected all"
    else
        statusLabel.Text = "Collect stopped"
    end

    sellBtn.Visible = true
    collectBtn.Visible = true
    autoBuyBtn.Visible = true
    endBtn.Visible = true
    isRunning = false
    stopRequested = false
end

local function autoBuy()
    local money = player:FindFirstChild("Currency") and player.Currency:FindFirstChild("Money")
    if not money then
        statusLabel.Text = "Money not found"
        return
    end
    local balance = money.Value
    if type(balance) ~= "number" then
        balance = tonumber(balance) or 0
    end

    local menu = player:FindFirstChild("PlayerGui")
        and player.PlayerGui:FindFirstChild("MenuLayer")
        and player.PlayerGui.MenuLayer:FindFirstChild("DealerShop")
        and player.PlayerGui.MenuLayer.DealerShop:FindFirstChild("List")
    if not menu then
        statusLabel.Text = "Dealer list not loaded"
        return
    end

    local bestDealer = nil
    local bestPrice = -1

    for _, child in ipairs(menu:GetChildren()) do
        local buyBtn = child:FindFirstChild("BuyBtn")
        if buyBtn and buyBtn:IsA("TextButton") then
            local price = parsePrice(buyBtn.Text)
            if price <= balance and price > bestPrice then
                bestPrice = price
                bestDealer = child.Name
            end
        end
    end

    if bestDealer then
        statusLabel.Text = "Buying " .. bestDealer .. " ($" .. tostring(bestPrice) .. ")"
        local success, result = pcall(function()
            buyRemote:InvokeServer(bestDealer)
        end)
        if success then
            statusLabel.Text = "Bought " .. bestDealer
        else
            statusLabel.Text = "Buy failed: " .. tostring(result)
        end
    else
        statusLabel.Text = "No affordable dealer"
    end
end

local function startSelling()
    if isRunning then return end
    isRunning = true
    stopRequested = false
    statusLabel.Text = "Selling..."
    sellBtn.Visible = false
    collectBtn.Visible = false
    autoBuyBtn.Visible = false

    for _, category in ipairs(categories) do
        if stopRequested then
            statusLabel.Text = "Stopped"
            break
        end
        statusLabel.Text = "Selling " .. category .. "..."
        sellCategory(category)
        task.wait(0.1)
    end

    if not stopRequested then
        statusLabel.Text = "Complete"
    end
    isRunning = false
    sellBtn.Visible = true
    collectBtn.Visible = true
    autoBuyBtn.Visible = true
end

sellBtn.MouseButton1Click:Connect(startSelling)

collectBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    stopRequested = false
    collectAll()
    isRunning = false
end)

autoBuyBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    autoBuy()
end)

endBtn.MouseButton1Click:Connect(function()
    if isRunning then
        stopRequested = true
        statusLabel.Text = "Stopping..."
    else
        screenGui:Destroy()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.End then
        screenGui:Destroy()
    end
end)

player.CharacterAdded:Connect(function()
    screenGui:Destroy()
end)
