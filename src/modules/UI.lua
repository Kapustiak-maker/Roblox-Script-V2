local UI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function UI:CreateWindow(title)
    local Window = {
        CurrentTab = nil
    }

    -- Root GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedDragon_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(220, 20, 20)
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainFrame
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)

    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Name = "Title"
    HeaderTitle.Parent = Header
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Position = UDim2.new(0, 15, 0, 0)
    HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.Text = title or "RED DRAGON"
    HeaderTitle.TextColor3 = Color3.fromRGB(220, 20, 20)
    HeaderTitle.TextSize = 16
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 140, 1, -40)

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = Sidebar
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)

    -- Container for pages
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = MainFrame
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 140, 0, 40)
    Container.Size = UDim2.new(1, -140, 1, -40)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    function Window:CreateTab(name)
        local Tab = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "_Tab"
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 32)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 13
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "_Page"
        Page.Parent = Container
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(220, 20, 20)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150), BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(220, 20, 20), BackgroundColor3 = Color3.fromRGB(40, 20, 20)}):Play()
        end)

        -- Default selection
        if not Window.CurrentTab then
            Window.CurrentTab = Tab
            Page.Visible = true
            TabButton.TextColor3 = Color3.fromRGB(220, 20, 20)
            TabButton.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
        end

        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text .. "_Button"
            Button.Parent = Page
            Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Button.BorderSizePixel = 0
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.TextSize = 14
            Button.AutoButtonColor = false

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Button

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Color3.fromRGB(220, 20, 20)
            BtnStroke.Thickness = 1
            BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            BtnStroke.Transparency = 0.8
            BtnStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 25, 25)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                local circle = Instance.new("ImageLabel")
                circle.Name = "Circle"
                circle.Parent = Button
                circle.BackgroundTransparency = 1
                circle.Image = "rbxassetid://266543268"
                circle.ImageColor3 = Color3.fromRGB(220, 20, 20)
                circle.ImageTransparency = 0.5
                circle.Size = UDim2.new(0, 0, 0, 0)
                circle.ZIndex = 10
                
                local mousePos = UserInputService:GetMouseLocation() - Button.AbsolutePosition
                circle.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
                
                circle:TweenSizeAndPosition(UDim2.new(0, 200, 0, 200), UDim2.new(0, mousePos.X - 100, 0, mousePos.Y - 100), "Out", "Quad", 0.3, true)
                TweenService:Create(circle, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
                
                task.delay(0.3, function() circle:Destroy() end)
                callback()
            end)
        end

        function Tab:CreateToggle(text, default, callback)
            local Toggled = default or false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = text .. "_Toggle"
            ToggleFrame.Parent = Page
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("Frame")
            Box.Name = "Box"
            Box.Parent = ToggleFrame
            Box.BackgroundColor3 = Toggled and Color3.fromRGB(220, 20, 20) or Color3.fromRGB(40, 40, 40)
            Box.Position = UDim2.new(1, -35, 0.5, -9)
            Box.Size = UDim2.new(0, 18, 0, 18)

            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = Box

            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and Color3.fromRGB(220, 20, 20) or Color3.fromRGB(40, 40, 40)}):Play()
                callback(Toggled)
            end)
        end

        return Tab
    end

    return Window
end

return UI
