local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({Name = "NHAN HUB | GAG TEST", LoadingTitle = "Testing...", LoadingSubtitle = "by Nhan"})

local Tab = Window:CreateTab("Main", 4483362458)
_G.Auto = true

Tab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = true,
   Callback = function(v) _G.Auto = v end
})

local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

task.spawn(function()
    while task.wait(0.5) do
        if _G.Auto then
            pcall(function()
                -- Lệnh thu hoạch và bán cơ bản nhất
                Remotes.HarvestAll:FireServer()
                Remotes.SellAllCrops:FireServer()
                
                -- Tìm vườn và trồng Carrot đại vào 1 ô để test
                for _, g in pairs(workspace.Gardens:GetChildren()) do
                    if g.Owner.Value == Player.Name then
                        for _, p in pairs(g.Plots:GetChildren()) do
                            if not p:FindFirstChild("Plant") then
                                Remotes.PlantSeed:FireServer(p.Name, "Carrot", g.CentralPlot.Position)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
