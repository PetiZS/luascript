local ColorCorrection = Instance.new("ColorCorrectionEffect",game.Lighting)

local RunService = game["Run Service"].RenderStepped:Connect(function()
	ColorCorrection.Contrast = math.random(-100/10,100/10)
	ColorCorrection.Saturation = math.random(-100/10,100/10)
	ColorCorrection.TintColor = Color3.new(math.random(),math.random(),math.random())
end)

task.wait(30)

RunService:Disconnect()

ColorCorrection:Destroy()