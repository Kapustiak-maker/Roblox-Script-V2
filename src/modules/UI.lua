local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function UI:CreateWindow(title)
    local Window = {
        CurrentModule = nil,
        Visible = true,
        Modules = {}
    }

    -- Root GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KCheat_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
    MainFrame.BackgroundTransparency = 0.4
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.ClipsDescendants = false

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(150, 100, 250)
    MainStroke.Thickness = 2
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 45)

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "Title"
    HeaderTitle.Parent = Header
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Position = UDim2.new(0, 20, 0, 0)
    HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.Text = title or "K. CHEAT"
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderTitle.TextSize = 18
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 24
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if getgenv().KCheat and getgenv().KCheat.Connections then
            for _, conn in pairs(getgenv().KCheat.Connections) do
                if conn.Disconnect then conn:Disconnect() end
            end
        end
        getgenv().KCheat = nil
    end)

    -- Left Pane (Functions)
    local LeftPane = Instance.new("ScrollingFrame")
    LeftPane.Name = "LeftPane"
    LeftPane.Parent = MainFrame
    LeftPane.BackgroundTransparency = 0.95
    LeftPane.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LeftPane.BorderSizePixel = 0
    LeftPane.Position = UDim2.new(0, 15, 0, 50)
    LeftPane.Size = UDim2.new(0, 180, 1, -65)
    LeftPane.ScrollBarThickness = 2
    LeftPane.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 250)
    LeftPane.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftPane.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.Parent = LeftPane
    LeftLayout.Padding = UDim.new(0, 5)

    local LeftPadding = Instance.new("UIPadding")
    LeftPadding.Parent = LeftPane
    LeftPadding.PaddingTop = UDim.new(0, 5)
    LeftPadding.PaddingLeft = UDim.new(0, 5)
    LeftPadding.PaddingRight = UDim.new(0, 5)

    -- Right Pane (Settings)
    local RightPane = Instance.new("ScrollingFrame")
    RightPane.Name = "RightPane"
    RightPane.Parent = MainFrame
    RightPane.BackgroundTransparency = 0.9
    RightPane.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    RightPane.BorderSizePixel = 0
    RightPane.Position = UDim2.new(0, 210, 0, 50)
    RightPane.Size = UDim2.new(1, -225, 1, -65)
    RightPane.ScrollBarThickness = 2
    RightPane.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 250)
    RightPane.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightPane.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local RightCorner = Instance.new("UICorner")
    RightCorner.CornerRadius = UDim.new(0, 10)
    RightCorner.Parent = RightPane

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.Parent = RightPane
    RightLayout.Padding = UDim.new(0, 8)

    local RightPadding = Instance.new("UIPadding")
    RightPadding.Parent = RightPane
    RightPadding.PaddingTop = UDim.new(0, 10)
    RightPadding.PaddingLeft = UDim.new(0, 10)
    RightPadding.PaddingRight = UDim.new(0, 10)

    -- Dragging
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    function Window:Toggle()
        Window.Visible = not Window.Visible
        MainFrame.Visible = Window.Visible
    end

    function Window:CreateModule(name, callback)
        local Module = {
            State = false,
            Container = Instance.new("Frame")
        }
        
        -- Settings container for this module
        Module.Container.Name = name .. "_Settings"
        Module.Container.Parent = RightPane
        Module.Container.BackgroundTransparency = 1
        Module.Container.Size = UDim2.new(1, 0, 0, 0)
        Module.Container.AutomaticSize = Enum.AutomaticSize.Y
        Module.Container.Visible = false
        
        local ContainerLayout = Instance.new("UIListLayout")
        ContainerLayout.Parent = Module.Container
        ContainerLayout.Padding = UDim.new(0, 8)

        local ModBtn = Instance.new("TextButton")
        ModBtn.Name = name .. "_Btn"
        ModBtn.Parent = LeftPane
        ModBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        ModBtn.Size = UDim2.new(1, 0, 0, 40)
        ModBtn.Font = Enum.Font.GothamSemibold
        ModBtn.Text = name
        ModBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        ModBtn.TextSize = 13
        ModBtn.AutoButtonColor = false

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = ModBtn

        local function updateAppearance()
            if Module.State then
                TweenService:Create(ModBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 100, 250), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            else
                TweenService:Create(ModBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 30, 60), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
        end

        local function showSettings()
            for _, v in pairs(RightPane:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            Module.Container.Visible = true
            Window.CurrentModule = Module
        end

        ModBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Module.State = not Module.State
                updateAppearance()
                callback(Module.State)
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                showSettings()
            end
        end)

        -- Components nested in settings
        function Module:CreateToggle(text, default, toggleCallback)
            local Toggled = default or false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = Module.Container
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 25, 50)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false
            
            local TCorner = Instance.new("UICorner")
            TCorner.CornerRadius = UDim.new(0, 6)
            TCorner.Parent = ToggleFrame
            
            local TText = Instance.new("TextLabel")
            TText.Parent = ToggleFrame
            TText.BackgroundTransparency = 1
            TText.Position = UDim2.new(0, 10, 0, 0)
            TText.Size = UDim2.new(1, -40, 1, 0)
            TText.Font = Enum.Font.GothamSemibold
            TText.Text = text
            TText.TextColor3 = Color3.fromRGB(220, 220, 220)
            TText.TextXAlignment = Enum.TextXAlignment.Left
            
            local Box = Instance.new("Frame")
            Box.Parent = ToggleFrame
            Box.BackgroundColor3 = Toggled and Color3.fromRGB(150, 100, 250) or Color3.fromRGB(60, 50, 80)
            Box.Position = UDim2.new(1, -30, 0.5, -9)
            Box.Size = UDim2.new(0, 18, 0, 18)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(150, 100, 250) or Color3.fromRGB(60, 50, 80)}):Play()
                toggleCallback(Toggled)
            end)
        end

        function Module:CreateButton(text, btnCallback)
            local Button = Instance.new("TextButton")
            Button.Parent = Module.Container
            Button.BackgroundColor3 = Color3.fromRGB(35, 30, 60)
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(240, 240, 240)
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(btnCallback)
        end

        -- Auto-select first module settings
        if #LeftPane:GetChildren() <= 3 then -- Taking into account layout and pads
            task.defer(showSettings)
        end

        return Module
    end

    return Window
end

return UI
