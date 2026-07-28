if _G.DeltaHub_Loaded then
    warn("检测到重复脚本，自动清理旧实例...")
    if _G.DeltaHub_Gui then
        pcall(function() _G.DeltaHub_Gui:Destroy() end)
    end
end
_G.DeltaHub_Loaded = truelocal Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local playerGui = game.CoreGui

local CONFIG = {
    WindowSize = Vector2.new(460, 370),
    MiniSize = Vector2.new(170, 44),
    Theme = {
        Sidebar = Color3.fromRGB(45, 45, 55),
        SidebarActive = Color3.fromRGB(70, 70, 85),
        Text = Color3.fromRGB(240, 240, 245),
        TextDim = Color3.fromRGB(160, 160, 175),
        Card = Color3.fromRGB(50, 50, 62)
    },
    Corner = 18
}

local currentBgColor = Color3.fromRGB(30, 30, 38)
local bgTransparency = 0.12
local borderEnabled = true
local hue = 0
local isOpen = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaHub"
screenGui.Parent = playerGui

local function roundify(instance, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or CONFIG.Corner)
    c.Parent = instance
    return c
end

local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(CONFIG.MiniSize.X, CONFIG.MiniSize.Y)
window.Position = UDim2.new(0.5, -85, 0.7, 0)
window.AnchorPoint = Vector2.new(0, 0)
window.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
window.BackgroundTransparency = bgTransparency
window.BorderSizePixel = 0
window.Parent = screenGui
roundify(window)

local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 2.5
borderStroke.Transparency = 0.15
borderStroke.Enabled = true
borderStroke.Parent = window

local miniDrag = Instance.new("Frame")
miniDrag.Size = UDim2.new(1, 0, 1, 0)
miniDrag.BackgroundTransparency = 1
miniDrag.Parent = window

local miniText = Instance.new("TextLabel")
miniText.Size = UDim2.new(1, -50, 1, 0)
miniText.Position = UDim2.new(0, 20, 0, 0)
miniText.Text = "Delta Hub"
miniText.TextColor3 = Color3.fromRGB(240, 240, 245)
miniText.TextSize = 16
miniText.TextXAlignment = Enum.TextXAlignment.Center
miniText.BackgroundTransparency = 1
miniText.Font = Enum.Font.GothamBold
miniText.Parent = window

local miniExpandBtn = Instance.new("TextButton")
miniExpandBtn.Size = UDim2.new(0, 30, 0, 30)
miniExpandBtn.Position = UDim2.new(1, -35, 0, 7)
miniExpandBtn.Text = "+"
miniExpandBtn.TextColor3 = CONFIG.Theme.TextDim
miniExpandBtn.TextSize = 20
miniExpandBtn.BackgroundTransparency = 1
miniExpandBtn.Font = Enum.Font.Gotham
miniExpandBtn.Parent = window

local menuContainer = Instance.new("Frame")
menuContainer.Size = UDim2.fromOffset(CONFIG.WindowSize.X, CONFIG.WindowSize.Y)
menuContainer.Position = UDim2.new(0, 0, 0, 0)
menuContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
menuContainer.BackgroundTransparency = bgTransparency
menuContainer.BorderSizePixel = 0
menuContainer.Parent = window
menuContainer.Visible = false
roundify(menuContainer)

local borderStroke2 = Instance.new("UIStroke")
borderStroke2.Thickness = 2.5
borderStroke2.Transparency = 0.15
borderStroke2.Enabled = true
borderStroke2.Parent = menuContainer

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
topbar.BackgroundTransparency = bgTransparency
topbar.BorderSizePixel = 0
topbar.Parent = menuContainer

local topDrag = Instance.new("Frame")
topDrag.Size = UDim2.new(0.7, 0, 1, 0)
topDrag.Position = UDim2.new(0.15, 0, 0, 0)
topDrag.BackgroundTransparency = 1
topDrag.Parent = topbar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.6, 0, 1, 0)
titleText.Position = UDim2.new(0.05, 0, 0, 0)
titleText.Text = "Delta Hub"
titleText.TextColor3 = CONFIG.Theme.Text
titleText.TextSize = 17
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.Parent = topbar

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -70, 0, 5)
miniBtn.Text = "−"
miniBtn.TextColor3 = CONFIG.Theme.TextDim
miniBtn.TextSize = 20
miniBtn.BackgroundTransparency = 1
miniBtn.Font = Enum.Font.Gotham
miniBtn.Parent = topbar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 5)
closeBtn.Text = "✕"
closeBtn.TextColor3 = CONFIG.Theme.TextDim
closeBtn.TextSize = 18
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.Gotham
closeBtn.Parent = topbar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

miniExpandBtn.MouseButton1Click:Connect(function()
    if not isOpen then
        local tween = TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(CONFIG.WindowSize.X, CONFIG.WindowSize.Y)
        })
        tween:Play()
        menuContainer.Visible = true
        miniText.Visible = false
        miniExpandBtn.Visible = false
        isOpen = true
    end
end)

miniBtn.MouseButton1Click:Connect(function()
    if isOpen then
        local tween = TweenService:Create(window, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(CONFIG.MiniSize.X, CONFIG.MiniSize.Y)
        })
        tween:Play()
        menuContainer.Visible = false
        miniText.Visible = true
        miniExpandBtn.Visible = true
        isOpen = false
    end
end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = CONFIG.Theme.Sidebar
sidebar.BackgroundTransparency = 0.4
sidebar.BorderSizePixel = 0
sidebar.Parent = menuContainer

local sidebarCategories = {
    {name = "脚本1"},
    {name = "脚本2"},
    {name = "脚本3"},
    {name = "脚本4"},
    {name = "脚本5"},
    {name = "脚本6"},
    {name = "页脚本"},
    {name = "背景"},
    {name = "边框"}
}

local sidebarBtns = {}
local currentCategory = "脚本1"

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -120, 1, -40)
contentArea.Position = UDim2.new(0, 120, 0, 40)
contentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
contentArea.BackgroundTransparency = bgTransparency
contentArea.BorderSizePixel = 0
contentArea.Parent = menuContainer

local ESP = {
    enabled = false,
    box = false,
    line = false
}

local espData = {}

local function getColor(plr)
    if plr.Team and plr.Team ~= player.Team then
        return Color3.fromRGB(255, 50, 50)
    elseif plr == player then
        return Color3.fromRGB(0, 255, 100)
    else
        return Color3.fromRGB(255, 255, 100)
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        espData[plr] = {
            box = Drawing.new("Square"),
            line = Drawing.new("Line")
        }
        espData[plr].box.Thickness = 1.5
        espData[plr].box.Filled = false
        espData[plr].box.Visible = false
        espData[plr].line.Thickness = 1.5
        espData[plr].line.Visible = false
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= player then
        espData[plr] = {
            box = Drawing.new("Square"),
            line = Drawing.new("Line")
        }
        espData[plr].box.Thickness = 1.5
        espData[plr].box.Filled = false
        espData[plr].box.Visible = false
        espData[plr].line.Thickness = 1.5
        espData[plr].line.Visible = false
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espData[plr] then
        espData[plr].box:Remove()
        espData[plr].line:Remove()
        espData[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if borderEnabled then
        hue = (hue + 0.005) % 1
        local col = Color3.fromHSV(hue, 1, 1)
        borderStroke.Color = col
        borderStroke2.Color = col
        borderStroke.Enabled = true
        borderStroke2.Enabled = true
    else
        borderStroke.Enabled = false
        borderStroke2.Enabled = false
    end
    
    if not ESP.enabled then
        for _, data in pairs(espData) do
            data.box.Visible = false
            data.line.Visible = false
        end
        return
    end
    for plr, data in pairs(espData) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local color = getColor(plr)
                local size = plr.Character.Humanoid:GetRenderBounds()
                local height = size.Y * 2.5
                local width = size.X * 2
                local screenPos = Vector2.new(pos.X, pos.Y)
                if ESP.box then
                    data.box.Visible = true
                    data.box.Color = color
                    data.box.Size = Vector2.new(width * 2, height * 2)
                    data.box.Position = Vector2.new(screenPos.X - width, screenPos.Y - height)
                    data.box.Transparency = 0.8
                else
                    data.box.Visible = false
                end
                if ESP.line then
                    data.line.Visible = true
                    data.line.Color = color
                    data.line.From = Vector2.new(screenPos.X, screenPos.Y)
                    data.line.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.line.Transparency = 0.7
                else
                    data.line.Visible = false
                end
            else
                data.box.Visible = false
                data.line.Visible = false
            end
        else
            data.box.Visible = false
            data.line.Visible = false
        end
    end
end)local function getFunctions(category)
    local funcs = {
        ["脚本1"] = {"夜脚本", "ROB V2", "Emote脚本"},
        ["脚本2"] = {"脚本E", "脚本F", "脚本G"},
        ["脚本3"] = {"脚本H", "脚本I", "脚本J"},
        ["脚本4"] = {"脚本K", "脚本L", "脚本M"},
        ["脚本5"] = {"脚本N", "脚本O", "脚本P"},
        ["脚本6"] = {"脚本Q", "脚本R", "脚本S"},
        ["页脚本"] = {"脚本T", "脚本U", "脚本V"},
        ["背景"] = {"⬜白色", "⬛黑色", "🟪紫色", "🟦深蓝", "🟩墨绿", "🟥酒红", "🌙浅黑"},
        ["边框"] = {"💫彩色边框"}
    }
    return funcs[category] or {}
end

local function updateBgColor(color)
    currentBgColor = color
    window.BackgroundColor3 = color
    menuContainer.BackgroundColor3 = color
    topbar.BackgroundColor3 = color
    contentArea.BackgroundColor3 = color
end

local function rebuildContent(category)
    for _, child in pairs(contentArea:GetChildren()) do
        child:Destroy()
    end
    local funcs = getFunctions(category)
    local count = 0
    for _, funcName in ipairs(funcs) do
        count = count + 1
        local y = 8 + (count - 1) * 42
        local card = Instance.new("TextButton")
        card.Size = UDim2.new(0.9, 0, 0, 32)
        card.Position = UDim2.new(0.05, 0, 0, y)
        card.Text = "  " .. funcName
        card.TextColor3 = CONFIG.Theme.Text
        card.TextSize = 14
        card.TextXAlignment = Enum.TextXAlignment.Left
        card.BackgroundColor3 = CONFIG.Theme.Card
        card.BackgroundTransparency = 0.3
        card.BorderSizePixel = 0
        card.Parent = contentArea
        roundify(card, 12)
        local enabled = false
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(1, -18, 0.5, -3)
        dot.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
        dot.BorderSizePixel = 0
        dot.Parent = card
        roundify(dot, 3)
        
        if category == "ESP透视" then
            if funcName == "☐透视总开关" then
                card.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    ESP.enabled = enabled
                    dot.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                    print("透视" .. (enabled and "开" or "关"))
                end)
            elseif funcName == "☐方框" then
                card.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    ESP.box = enabled
                    dot.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                    print("方框" .. (enabled and "开" or "关"))
                end)
            elseif funcName == "☐射线" then
                card.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    ESP.line = enabled
                    dot.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                    print("射线" .. (enabled and "开" or "关"))
                end)
            end
        elseif category == "脚本1" or category == "脚本2" or category == "脚本3" or category == "脚本4" or category == "脚本5" or category == "脚本6" or category == "页脚本" then
            card.MouseButton1Click:Connect(function()
                enabled = not enabled
                dot.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                if enabled then
                    print(funcName .. " 已开启")
                    if funcName == "夜脚本" then
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben"))()
                    elseif funcName == "ROB V2" then
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zyb150933/ROB/refs/heads/main/ROB.V2"))()
                    elseif funcName == "Emote脚本" then
                        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-7yd7-I-Emote-Script-48024"))()
                    elseif funcName == "脚本E" then
                        -- 放脚本E代码
                    elseif funcName == "脚本F" then
                        -- 放脚本F代码
                    elseif funcName == "脚本G" then
                        -- 放脚本G代码
                    elseif funcName == "脚本H" then
                        -- 放脚本H代码
                    elseif funcName == "脚本I" then
                        -- 放脚本I代码
                    elseif funcName == "脚本J" then
                        -- 放脚本J代码
                    elseif funcName == "脚本K" then
                        -- 放脚本K代码
                    elseif funcName == "脚本L" then
                        -- 放脚本L代码
                    elseif funcName == "脚本M" then
                        -- 放脚本M代码
                    elseif funcName == "脚本N" then
                        -- 放脚本N代码
                    elseif funcName == "脚本O" then
                        -- 放脚本O代码
                    elseif funcName == "脚本P" then
                        -- 放脚本P代码
                    elseif funcName == "脚本Q" then
                        -- 放脚本Q代码
                    elseif funcName == "脚本R" then
                        -- 放脚本R代码
                    elseif funcName == "脚本S" then
                        -- 放脚本S代码
                    elseif funcName == "脚本T" then
                        -- 放脚本T代码
                    elseif funcName == "脚本U" then
                        -- 放脚本U代码
                    elseif funcName == "脚本V" then
                        -- 放脚本V代码
                    end
                else
                    print(funcName .. " 已关闭")
                end
            end)
        elseif category == "背景" then
            card.MouseButton1Click:Connect(function()
                local colors = {
                    ["⬜白色"] = Color3.fromRGB(255, 255, 255),
                    ["⬛黑色"] = Color3.fromRGB(10, 10, 15),
                    ["🟪紫色"] = Color3.fromRGB(80, 40, 160),
                    ["🟦深蓝"] = Color3.fromRGB(20, 40, 120),
                    ["🟩墨绿"] = Color3.fromRGB(20, 80, 40),
                    ["🟥酒红"] = Color3.fromRGB(120, 20, 30),
                    ["🌙浅黑"] = Color3.fromRGB(30, 30, 38)
                }
                updateBgColor(colors[funcName] or Color3.fromRGB(30, 30, 38))
                dot.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
                task.wait(0.1)
                dot.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
                print("背景已切换")
            end)
        elseif category == "边框" then
            card.MouseButton1Click:Connect(function()
                borderEnabled = not borderEnabled
                dot.BackgroundColor3 = borderEnabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                print("彩色边框" .. (borderEnabled and "开" or "关"))
            end)
        else
            card.MouseButton1Click:Connect(function()
                enabled = not enabled
                dot.BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 50) or Color3.fromRGB(180, 180, 190)
                print(funcName .. (enabled and "开" or "关"))
            end)
        end
        card.MouseEnter:Connect(function()
            card.BackgroundTransparency = 0.1
        end)
        card.MouseLeave:Connect(function()
            card.BackgroundTransparency = 0.3
        end)
    end
end

for i, cat in ipairs(sidebarCategories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, 5 + (i - 1) * 42)
    btn.Text = cat.name
    btn.TextColor3 = CONFIG.Theme.TextDim
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Parent = sidebar
    roundify(btn, 12)
    sidebarBtns[cat.name] = btn
    btn.MouseButton1Click:Connect(function()
        currentCategory = cat.name
        for _, b in pairs(sidebarBtns) do
            b.BackgroundTransparency = 1
            b.TextColor3 = CONFIG.Theme.TextDim
        end
        btn.BackgroundTransparency = 0.5
        btn.BackgroundColor3 = CONFIG.Theme.SidebarActive
        btn.TextColor3 = CONFIG.Theme.Text
        rebuildContent(cat.name)
    end)
end

sidebarBtns["脚本1"].BackgroundTransparency = 0.5
sidebarBtns["脚本1"].BackgroundColor3 = CONFIG.Theme.SidebarActive
sidebarBtns["脚本1"].TextColor3 = CONFIG.Theme.Text
rebuildContent("脚本1")

do
    local dragStart, startPos, dragging = nil, nil, false
    local dragTarget = nil
    
    local function startDrag(input, target)
        dragging = true
        dragStart = input.Position
        startPos = window.Position
        dragTarget = target
    end
    
    local function endDrag()
        dragging = false
        dragTarget = nil
    end
    
    local function moveDrag(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    miniDrag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input, "mini")
        end
    end)
    miniDrag.InputEnded:Connect(endDrag)
    
    topDrag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input, "top")
        end
    end)
    topDrag.InputEnded:Connect(endDrag)
    
    UserInputService.InputChanged:Connect(moveDrag)
end-- ===== 欢迎飘字 =====
local function showWelcome()
    -- 创建临时GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "WelcomeNotify"
    gui.Parent = game.CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 0, 0, 0)
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Text = "🎉 欢迎使用 Delta Hub"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 28
    label.TextStrokeTransparency = 0.3
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Parent = gui

    -- 弹入动画
    label.Size = UDim2.new(0, 0, 0, 0)
    local TweenService = game:GetService("TweenService")
    local sizeTween = TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 50)
    })
    sizeTween:Play()

    -- 停留1.5秒后淡出消失
    task.wait(1.5)
    local fadeTween = TweenService:Create(label, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    })
    fadeTween:Play()
    task.wait(0.6)
    gui:Destroy()
end

-- 延迟0.5秒执行，确保菜单先加载完
task.wait(0.5)
showWelcome()-- ============================================
-- 本地通知系统 v1.0
-- 只有本地玩家可见，不触发服务器事件
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- ===== 创建通知容器 =====
local notificationGui = Instance.new("ScreenGui")
notificationGui.Name = "LocalNotifications"
notificationGui.Parent = CoreGui

-- ===== 1. 屏幕飘字（本地提示） =====
local function showFloatingText(text, color, duration)
    color = color or Color3.fromRGB(255, 255, 255)
    duration = duration or 1.5

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 0, 0, 0)
    label.Position = UDim2.new(0.5, 0, 0.5, 0)
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Text = text
    label.TextColor3 = color
    label.TextSize = 24
    label.TextScaled = false
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Parent = notificationGui

    -- 尺寸动画（从小到大）
    label.Size = UDim2.new(0, 0, 0, 0)
    local sizeTween = TweenService:Create(label, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 40)
    })
    sizeTween:Play()

    -- 上浮 + 淡出
    task.wait(0.5)
    local posTween = TweenService:Create(label, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.35, 0),
        TextTransparency = 1
    })
    posTween:Play()
    task.wait(duration)
    label:Destroy()
end

-- ===== 2. 成就弹窗（罗布勒斯原生风格，圆角+图片） =====
local function showAchievement(title, description, imageId, callback)
    -- 创建弹窗
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 120)
    frame.Position = UDim2.new(0.5, -170, 0.15, -120)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = notificationGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    -- 边框光效
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Color = Color3.fromRGB(255, 200, 50)
    stroke.Parent = frame

    -- 图标（圆形图片）
    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 64, 0, 64)
    iconContainer.Position = UDim2.new(0.05, 0, 0.5, -32)
    iconContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    iconContainer.BackgroundTransparency = 0.5
    iconContainer.BorderSizePixel = 0
    iconContainer.Parent = frame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconContainer

    -- 图片（如果提供了imageId）
    if imageId then
        local image = Instance.new("ImageLabel")
        image.Size = UDim2.new(0.8, 0, 0.8, 0)
        image.Position = UDim2.new(0.1, 0, 0.1, 0)
        image.Image = "rbxassetid://" .. tostring(imageId)
        image.BackgroundTransparency = 1
        image.Parent = iconContainer
    end

    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 0.3, 0)
    titleLabel.Position = UDim2.new(0.3, 0, 0.15, 0)
    titleLabel.Text = title or "成就解锁"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame

    -- 描述
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.6, 0, 0.3, 0)
    descLabel.Position = UDim2.new(0.3, 0, 0.5, 0)
    descLabel.Text = description or ""
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
    descLabel.TextSize = 14
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.Parent = frame

    -- 滑动进入动画
    frame.Position = UDim2.new(0.5, -170, 0.15, -120)
    local enterTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -170, 0.15, 0)
    })
    enterTween:Play()

    -- 自动消失
    task.wait(3.5)
    local exitTween = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -170, 0.15, -120),
        BackgroundTransparency = 1
    })
    exitTween:Play()
    task.wait(0.5)
    frame:Destroy()

    if callback then callback() end
end

-- ===== 导出函数 =====
_G.LocalNotification = {
    float = showFloatingText,
    achievement = showAchievement
}

-- ===== 示例：加载完成后显示成就 =====
task.wait(0.5)
_G.LocalNotification.float("🎉 欢迎回来！", Color3.fromRGB(100, 255, 150))
task.wait(1)

_G.LocalNotification.achievement(
    "🏆 脚本加载成功",
    "Delta Hub 已就绪",
    1883282684  -- 示例图标ID，换成你自己的
)task.wait(1)
showLeftNotification("🎮 Delta Hub", "脚本已加载，欢迎使用！", 5)