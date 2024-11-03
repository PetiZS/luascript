local ColorCorrection = Instance.new("ColorCorrectionEffect",game.Lighting)

game["Run Service"].RenderStepped:Connect(function()
	ColorCorrection.Contrast = math.random(-100/10,100/10)
	ColorCorrection.Saturation = math.random(-100/10,100/10)
	ColorCorrection.TintColor = Color3.new(math.random(),math.random(),math.random())
end)