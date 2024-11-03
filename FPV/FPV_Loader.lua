--Configuration
getgenv().Active = true
getgenv().Deadzone = 0.1
getgenv().Acceleration = 2
getgenv().Deceleration = 1
getgenv().Sensibility = 2.1
getgenv().Maxspeed = 150
getgenv().Collision = true --drone collision

loadstring(game:HttpGet("https://raw.githubusercontent.com/PetiZS/luascript/refs/heads/main/FPV/FPV.lua"))()
--[[
 Info:
 
 - it works well but I need to make it more stable
 - need xbox controller, don't know if other controllers work
 - does not work with keyboard
 - Press B on the controller to activate drone

note:

- It takes practice to fly a fpv drone
- take-off is difficult at first
- you mustn't let it touch the ground
]]  