local plr = game.Players.LocalPlayer
local screengui = Instance.new("ScreenGui",plr.PlayerGui)
screengui.Name = "Positioner"

local frame = Instance.new("Frame",screengui)
frame.Size = UDim2.fromScale(0.2,0.2)

local uiaspectratioconstrait = Instance.new("UIAspectRatioConstraint",frame)
uiaspectratioconstrait.AspectRatio = 3.8

local uilistlayout = Instance.new("UIListLayout",frame)
uilistlayout.FillDirection = Enum.FillDirection.Horizontal

local X = Instance.new("TextLabel",frame)
local Y = Instance.new("TextLabel",frame)
local Z = Instance.new("TextLabel",frame)

X.Size = UDim2.fromScale(0.333,1)
Y.Size = UDim2.fromScale(0.333,1)
Z.Size = UDim2.fromScale(0.333,1)

X.TextScaled = true
Y.TextScaled = true
Z.TextScaled = true

X.Text = "0"
Y.Text = "0"
Z.Text = "0"

X.Interactable = false
Y.Interactable = false
Z.Interactable = false

local dragdetector = Instance.new("UIDragDetector",frame)

dragdetector.ActivatedCursorIcon = "rbxassetid://0"
dragdetector.CursorIcon = "rbxassetid://0"

local delta = {}

local logsMaxDelta = 10

if logsMaxDelta > 100 then
    logsMaxDelta = 100
elseif logsMaxDelta < 5 then
    logsMaxDelta = 5
end

local RenderStepped = game["Run Service"].RenderStepped:Connect(function(deltaTime)
    table.insert(delta,"|"..deltaTime.."| ")
    if delta[math.round(logsMaxDelta)+1] ~= nil then
        table.remove(delta,1)
    end
    X.Text = (math.round(plr.Character.PrimaryPart.CFrame.Position.X))
    Y.Text = (math.round(plr.Character.PrimaryPart.CFrame.Position.Y))
    Z.Text = (math.round(plr.Character.PrimaryPart.CFrame.Position.Z))
end)

local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

char.Humanoid.Died:Once(function()
    local deltaStuff = delta
    delta = ""
    for i, v in ipairs(deltaStuff) do
        delta = delta..v
    end
    
    RenderStepped:Disconnect()
    RenderStepped = nil
    dragdetector = nil
    plr = nil
    screengui = nil
    frame = nil
    uiaspectratioconstrait = nil
    uilistlayout = nil
    X = nil
    Y = nil
    Z = nil
    print("logs:")
    print("AvarageDeltaTime: ")
    print(delta)
    print()
    print('Memory leaks(every being "nil" means perfect):')
    delta = nil
    deltaStuff = nil
    print(plr,
        screengui,
        frame,
        uiaspectratioconstrait,
        uilistlayout,
        X,
        Y,
        Z,
        delta,
        deltaStuff,
        dragdetector
    )
    for i = 1, 5 do
        print()
    end
    print("-- Log end --")
    
end)