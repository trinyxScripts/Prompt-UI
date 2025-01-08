local promptRet = {}

local useStudio
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")
local tweenService = game:GetService("TweenService")

if runService:IsStudio() then
    useStudio = true
end

local debounce = false

local function fadeIn(prompt)
    prompt.Policy.Visible = true
    prompt.Policy.BackgroundTransparency = 1
    prompt.Policy.Title.TextTransparency = 1
    prompt.Policy.Notice.TextTransparency = 1
    prompt.Policy.Actions.Primary.Title.TextTransparency = 1
    prompt.Policy.Actions.Secondary.Title.TextTransparency = 1

    tweenService:Create(prompt.Policy, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    tweenService:Create(prompt.Policy.Title, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    tweenService:Create(prompt.Policy.Notice, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.3}):Play()
    tweenService:Create(prompt.Policy.Actions.Primary.Title, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    tweenService:Create(prompt.Policy.Actions.Secondary.Title, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0.5}):Play()
end

local function fadeOut(prompt, callbackResult)
    debounce = true

    tweenService:Create(prompt.Policy, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    tweenService:Create(prompt.Policy.Title, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    tweenService:Create(prompt.Policy.Notice, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    tweenService:Create(prompt.Policy.Actions.Primary.Title, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    tweenService:Create(prompt.Policy.Actions.Secondary.Title, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {TextTransparency = 1}):Play()

    task.wait(0.5)
    prompt:Destroy()

    if callbackResult ~= nil then
        callbackResult()
    end
end

function promptRet.create(title, description, primary, secondary, callback)
    local prompt = useStudio and script.Parent:FindFirstChild("Prompt") or game:GetObjects("rbxassetid://97206084643256")[1]
    prompt.Enabled = false

    if gethui then
        prompt.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(prompt)
        prompt.Parent = coreGui
    elseif not useStudio and coreGui:FindFirstChild("RobloxGui") then
        prompt.Parent = coreGui:FindFirstChild("RobloxGui")
    elseif not useStudio then
        prompt.Parent = coreGui
    end

    -- Set prompt text
    prompt.Policy.Title.Text = title
    prompt.Policy.Notice.Text = description
    prompt.Policy.Actions.Primary.Title.Text = primary
    prompt.Policy.Actions.Secondary.Title.Text = secondary

    -- Fade in the UI when loaded
    fadeIn(prompt)

    -- Primary button click
    prompt.Policy.Actions.Primary.Interact.MouseButton1Click:Connect(function()
        fadeOut(prompt, function()
            if callback then
                callback(true)
            end
        end)
    end)

    -- Secondary button click
    prompt.Policy.Actions.Secondary.Interact.MouseButton1Click:Connect(function()
        fadeOut(prompt, function()
            if callback then
                callback(false)
            end
        end)
    end)
end

return promptRet
