local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function UI:CreateWindow(title)
    local Window = {
        CurrentTab = nil,
        Visible = true
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
    MainFrame.BackgroundTransparency = 0.4 -- Half-transparent as requested
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
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

    -- Close Button (Cross)
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
        -- Shutdown Logic
        print("[K. Cheat] Shutting down...")
        ScreenGui:Destroy()
        if getgenv().KCheat and getgenv().KCheat.Connections then
            for _, conn in pairs(getgenv().KCheat.Connections) do
                if conn.Disconnect then conn:Disconnect() end
            end
        end
        getgenv().KCheat = nil
    end)

    -- Sidebar / Nav
    local Nav = Instance.new("Frame")
    Nav.Name = "Nav"
    Nav.Parent = MainFrame
    Nav.BackgroundTransparency = 1
    Nav.Position = UDim2.new(0, 15, 0, 50)
    Nav.Size = UDim2.new(0, 120, 1, -65)

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Parent = Nav
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Padding = UDim.new(0, 8)

    -- Container
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 0.8
    Container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Container.Position = UDim2.new(0, 150, 0, 60)
    Container.Size = UDim2.new(1, -165, 1, -75)

    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container

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

    function Window:CreateTab(name)
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = Nav
        TabButton.BackgroundColor3 = Color3.fromRGB(150, 100, 250)
        TabButton.BackgroundTransparency = 0.8
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 13
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "_Page"
        Page.Parent = Container
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 0

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.Padding = UDim.new(0, 10)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 10)
        PagePadding.PaddingRight = UDim.new(0, 10)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Nav:GetChildren()) do if v:IsA("TextButton") then
                TweenService:Create(v, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        if not Window.CurrentTab then
            Window.CurrentTab = Tab
            Page.Visible = true
            TabButton.BackgroundTransparency = 0.2
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(150, 100, 250)
            Button.BackgroundTransparency = 0.7
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.AutoButtonColor = false

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button

            Button.MouseButton1Click:Connect(callback)
        end

        return Tab
    end

    return Window
end

return UI
