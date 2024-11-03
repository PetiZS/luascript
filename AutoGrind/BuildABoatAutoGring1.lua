local plr = game.Players.LocalPlayer

if game.Players.LocalPlayer:FindFirstChild("BuildABoatAutoGrindGui1") ~= nil and game.Players.LocalPlayer:FindFirstChild("BuildABoatAutoGrindGui1"):FindFirstChild("ButtonBackground"):FindFirstChild("AutoGringToggle").BackgroundColor3 == Color3.new(0,0.7,0) then warn("Button Must Be Turned Off!!!") return end

local on = false

if game.Players.LocalPlayer:FindFirstChild("BuildABoatAutoGrindGui1") ~= nil then game.Players.LocalPlayer:FindFirstChild("BuildABoatAutoGrindGui1"):Destroy() end

local screengui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
screengui.Name = "BuildABoatAutoGrindGui1"
screengui.ResetOnSpawn = false

local frame = Instance.new("Frame",screengui)
frame.Size = UDim2.fromScale(0.2,0.2)
frame.AnchorPoint = Vector2.new(1,0)
frame.BackgroundColor3 = Color3.new(0,0,0)
frame.Position = UDim2.fromScale(1,0)
frame.Name = "ButtonBackground"

local uidragdetector = Instance.new("UIDragDetector",frame)

uidragdetector.ActivatedCursorIcon = "rbxassetid://0"
uidragdetector.CursorIcon = "rbxassetid://0"

local uiaspectratioconstraint = Instance.new("UIAspectRatioConstraint",frame)

local button1 = Instance.new("TextButton",frame)
button1.Text = "Toggle Auto Grind"
button1.TextScaled = true
button1.Size = UDim2.fromScale(0.8,0.8)
button1.AnchorPoint = Vector2.new(0.5,0.5)
button1.Position = UDim2.fromScale(0.5,0.5)
button1.BackgroundColor3 = Color3.new(0.7,0,0)
button1.TextColor3 = Color3.new(0,0,0)
button1.Name = "AutoGringToggle"

local ResetOnBodyPartLost
local TheFunction
local bodyposition
local bullpoo
local plrpart
local BodyParts =  {}

button1.MouseButton1Up:Connect(function()
	if on == false then
		on = true 
		button1.BackgroundColor3 = Color3.new(0,0.7,0)

		ResetOnBodyPartLost = task.spawn(function()
			while true do
				for i, v in ipairs(plr.Character:GetChildren()) do
					if v:IsA("BasePart") or v:IsA("MeshPart") then table.insert(BodyParts,v) end
				end
				if 16 > #BodyParts and plr.Character.PrimaryPart ~= nil then
					if bodyposition ~= nil then bodyposition:Destroy() end
					plr.Character.PrimaryPart.CFrame = CFrame.new(0,-450,0)
					plr.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
					if plr.Character:FindFirstChild("Head") ~= nil then plr.Character:FindFirstChild("Head"):Destroy() end
					task.wait(5)
				end
				BodyParts = {}
				task.wait()
			end
		end)

		TheFunction = task.spawn(function()
			while true do
				task.wait(2)
				bullpoo = false
				plrpart = plr.Character.PrimaryPart

				plrpart.CFrame = CFrame.new(-52, 72, 1107)

				bodyposition = Instance.new("BodyVelocity",plrpart)
				bodyposition.MaxForce = Vector3.new(1,1,1) * math.huge
				bodyposition.Velocity = Vector3.new(0,0,250)

				plr.Character.Humanoid.Died:Once(function()
					bullpoo = true
				end)

				while true do
					if bullpoo == true then bullpoo = false break end
					if (Vector3.new(plrpart.Position.X, plrpart.Position.Y, 8708) - plrpart.Position).Magnitude < 50 then
						break
					end

					task.wait()
				end

				bodyposition:Destroy()
				plrpart.AssemblyLinearVelocity = Vector3.new(0,0,0)
				plrpart.CFrame = CFrame.new(-54, -353, 9491)
				task.wait(30)
			end
		end)
	elseif on == true then
		on = false
		print(ResetOnBodyPartLost)
		print(TheFunction)
		button1.BackgroundColor3 = Color3.new(0.7,0,0)
		task.cancel(ResetOnBodyPartLost)
		task.cancel(TheFunction)
		bodyposition:Destroy()
		plr.Character.PrimaryPart.CFrame = CFrame.new(0,-450,0)
		plr.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
	end
end)