-- ============================================
-- Delta Hub 启动器 v1.0
-- 包含：防连点 + 加载提示 + 计时器 + 欢迎仪式
-- ============================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- ===== 状态管理 =====
local isLoading = false
local startTime = nil

-- ===== 创建加载提示 =====
local function showLoading()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LoadingScreen"
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, 0, 0.6, 0)
    loadingText.Position = UDim2.new(0, 0, 0.1, 0)
    loadingText.Text = "🔄 加载中..."
    loadingText.TextColor3 = Color3.fromRGB(240, 240, 245)
    loadingText.TextSize = 18
    loadingText.TextXAlignment = Enum.TextXAlignment.Center
    loadingText.BackgroundTransparency = 1
    loadingText.Font = Enum.Font.GothamBold
    loadingText.Parent = frame

    local timerText = Instance.new("TextLabel")
    timerText.Size = UDim2.new(1, 0, 0.3, 0)
    timerText.Position = UDim2.new(0, 0, 0.6, 0)
    timerText.Text = "⏱ 0.0 秒"
    timerText.TextColor3 = Color3.fromRGB(160, 160, 175)
    timerText.TextSize = 14
    timerText.TextXAlignment = Enum.TextXAlignment.Center
    timerText.BackgroundTransparency = 1
    timerText.Font = Enum.Font.Gotham
    timerText.Parent = frame

    return gui, timerText
end

-- ===== 欢迎仪式 =====
local function showWelcome(elapsed)
    local gui = Instance.new("ScreenGui")
    gui.Name = "WelcomeScreen"
    gui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.35, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Transparency = 0.2
    stroke.Color = Color3.fromRGB(100, 200, 255)
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0.1, 0)
    title.Text = "🎮 Delta Hub"
    title.TextColor3 = Color3.fromRGB(240, 240, 245)
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, 0, 0, 40)
    msg.Position = UDim2.new(0, 0, 0.38, 0)
    msg.Text = "欢迎使用本脚本"
    msg.TextColor3 = Color3.fromRGB(200, 200, 210)
    msg.TextSize = 18
    msg.TextXAlignment = Enum.TextXAlignment.Center
    msg.BackgroundTransparency = 1
    msg.Font = Enum.Font.Gotham
    msg.Parent = frame

    local timer = Instance.new("TextLabel")
    timer.Size = UDim2.new(1, 0, 0, 30)
    timer.Position = UDim2.new(0, 0, 0.6, 0)
    timer.Text = "⏱ 加载耗时: " .. string.format("%.2f", elapsed) .. " 秒"
    timer.TextColor3 = Color3.fromRGB(150, 150, 165)
    timer.TextSize = 14
    timer.TextXAlignment = Enum.TextXAlignment.Center
    timer.BackgroundTransparency = 1
    timer.Font = Enum.Font.Gotham
    timer.Parent = frame

    local notice = Instance.new("TextLabel")
    notice.Size = UDim2.new(1, 0, 0, 25)
    notice.Position = UDim2.new(0, 0, 0.8, 0)
    notice.Text = "⚠️ 脚本仅供技术讨论使用"
    notice.TextColor3 = Color3.fromRGB(120, 120, 135)
    notice.TextSize = 12
    notice.TextXAlignment = Enum.TextXAlignment.Center
    notice.BackgroundTransparency = 1
    notice.Font = Enum.Font.Gotham
    notice.Parent = frame

    -- 自动关闭
    task.wait(3)
    gui:Destroy()
end

-- ===== 加载主脚本 =====
local function loadMainScript()
    if isLoading then
        print("⏳ 脚本加载中，请勿重复点击")
        return
    end

    isLoading = true
    startTime = tick()

    -- 显示加载界面
    local loadingGui, timerText = showLoading()

    -- 启动计时器更新
    local timerConn
    timerConn = RunService.Heartbeat:Connect(function()
        if timerText and timerText.Parent then
            local elapsed = tick() - startTime
            timerText.Text = "⏱ " .. string.format("%.1f", elapsed) .. " 秒"
        else
            timerConn:Disconnect()
        end
    end)

    -- 执行主脚本
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ewiojh/Delta-hub-v1.1/main/hub.lua"))()
    end)

    -- 清理加载界面
    timerConn:Disconnect()
    if loadingGui then
        loadingGui:Destroy()
    end

    isLoading = false

    if success then
        local elapsed = tick() - startTime
        print("✅ 加载成功！耗时: " .. string.format("%.2f", elapsed) .. " 秒")
        showWelcome(elapsed)
    else
        warn("❌ 加载失败: " .. tostring(err))
        print("⚠️ 请检查网络或脚本链接是否正确")
    end
end

-- ===== 执行加载 =====
loadMainScript()