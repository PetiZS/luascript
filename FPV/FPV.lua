local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local drone = nil
local cameraOffset = Vector3.new(0, 0, 0)
local isActive = false
local leftStickPosition = Vector2.new(0, 0)
local rightStickPosition = Vector2.new(0, 0)
local constantVelocityY = 0

local DroneSound1 = nil

local fpv = getgenv().Active
local Sensibility = getgenv().Sensibility
local DEADZONE = getgenv().Deadzone
local acceleration = getgenv().Acceleration 
local deceleration = getgenv().Deceleration
local collisiond = getgenv().Collision

local function createDrone()
	local dronePart = Instance.new("Part")
	dronePart.Shape = Enum.PartType.Ball
	dronePart.Size = Vector3.new(0.5, 0.5, 0.5)
	dronePart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(5, 0, 5)
	dronePart.Anchored = false
	dronePart.CanCollide = collisiond
	dronePart.Parent = workspace

	return dronePart
end

local function attachCameraToDrone()
	if drone then
		workspace.CurrentCamera.CameraSubject = drone
		workspace.CurrentCamera.CFrame = drone.CFrame * CFrame.new(cameraOffset)
	end
end

local function detachCamera()
	workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.ButtonB and fpv then
			if not drone then
				drone = createDrone()
				
				DroneSound1 = Instance.new("Sound",drone)
				DroneSound1.SoundId = "rbxassetid://97311204743943"
				DroneSound1.Looped = true
				DroneSound1.Volume = 0.5
				DroneSound1:Play()
				
				isActive = true
				RunService.RenderStepped:Connect(function()
					if isActive and drone then
						attachCameraToDrone()
					end
				end)
			else
				drone:Destroy()
				drone = nil
				detachCamera()
				isActive = false
				if DroneSound1 ~= nil then DroneSound1:Destroy() end
				DroneSound1 = nil
				player.Character.Humanoid.WalkSpeed = 16
			end
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Gamepad1 then
		if input.KeyCode == Enum.KeyCode.Thumbstick1 then
			if input.Position.Magnitude > DEADZONE then
				leftStickPosition = input.Position
			else
				leftStickPosition = Vector2.new(0, 0)
			end
		elseif input.KeyCode == Enum.KeyCode.Thumbstick2 then
			if input.Position.Magnitude > DEADZONE then
				rightStickPosition = input.Position
			else
				rightStickPosition = Vector2.new(0, 0)
			end
		end
	end
end)

local gravityForce

RunService.RenderStepped:Connect(function()
	if drone and isActive then
		player.Character.Humanoid.WalkSpeed = 0

		if leftStickPosition then
			local rotationSpeed = Sensibility
			drone.CFrame = drone.CFrame * CFrame.Angles(0, 0, -leftStickPosition.X * rotationSpeed * math.pi / 180)
			drone.CFrame = drone.CFrame * CFrame.Angles(-leftStickPosition.Y * rotationSpeed * math.pi / 180, 0, 0)
		end

		if rightStickPosition then
			local rotationSpeed = Sensibility
			drone.CFrame = drone.CFrame * CFrame.Angles(0, -rightStickPosition.X * rotationSpeed * math.pi / 180, 0)
		end

		if rightStickPosition then
			local verticalInput = rightStickPosition.Y

			if verticalInput > 0.5 then
				constantVelocityY = math.clamp(constantVelocityY + acceleration, 0, Maxspeed)
			elseif verticalInput < -0.5 then
				constantVelocityY = math.clamp(constantVelocityY - acceleration, -30, 0)
			else
				if constantVelocityY > 0 then
					constantVelocityY = math.max(constantVelocityY - deceleration, 0)
				elseif constantVelocityY < 0 then
					constantVelocityY = math.min(constantVelocityY + deceleration, 0)
				end
			end
		end

		-- I don't know why it doesn't work
		local rayOrigin = drone.Position
		local rayDirection = Vector3.new(0, -1, 0) * 0.6
		local raycastResult = workspace:Raycast(rayOrigin, rayDirection)

		if raycastResult then
			local distanceToGround = (drone.Position.Y - raycastResult.Position.Y)

			if distanceToGround <= 0.5 then
				gravityForce = Vector3.new(0, math.clamp(-25 * (0.5 - distanceToGround) / 0.5, -25, 0), 0)
				constantVelocityY = math.max(constantVelocityY, 0)
			else
				gravityForce = Vector3.new(0, -25, 0)
			end
		else
			gravityForce = Vector3.new(0, -25, 0)
		end

		local cameraUpVector = (workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(45), 0, 0)).LookVector
		drone.AssemblyLinearVelocity = (cameraUpVector * constantVelocityY) + gravityForce
	end
end)