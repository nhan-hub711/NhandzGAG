-- [[ NHAN HUB | GAG SPECIAL V7 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GROW A GARDEN",
   LoadingTitle = "Đang tìm vườn của ông Nhân...",
   LoadingSubtitle = "by Nhan",
   ConfigurationSaving = { Enabled = false }
})

local CONFIG = getgenv().NHAN_HUB or {
    AUTO_FARM = true,
    AUTO_BUY_SEED = true,
    BUY_SEED_SHOP = {"Carrot"},
    PLANT_SEED = {"Carrot"}
}

local Tab1 = Window:CreateTab("Main Farm", 4483362458)

Tab1:CreateToggle({
   Name = "Auto Farm (Thu hoạch/Bán)",
   CurrentValue = CONFIG.AUTO_FARM,
   Callback = function(Value) CONFIG.AUTO_FARM = Value end,
})

Tab1:CreateToggle({
   Name = "Auto Buy & Plant",
   CurrentValue = CONFIG.AUTO_BUY_SEED,
   Callback = function(Value) CONFIG.AUTO_BUY_SEED = Value end,
})

-- [LOGIC ĐẶC BIỆT CHO GAG]
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

local function GetMyGarden()
    for _, g in pairs(workspace.Gardens:GetChildren()) do
        if g:FindFirstChild("Owner") and g.Owner.Value == Player.Name then
            return g
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(1) do
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if myGarden then
                    -- Bay tới vườn (Cái này quan trọng nè, phải ở gần mới farm được)
                    local root = Player.Character.HumanoidRootPart
                    if (root.Position - myGarden.CentralPlot.Position).Magnitude > 20 then
                        root.CFrame = myGarden.CentralPlot.CFrame + Vector3.new(0, 3, 0)
                    end

                    -- 1. Thu hoạch & Bán
                    Remotes.HarvestAll:FireServer()
                    task.wait(0.2)
                    Remotes.SellAllCrops:FireServer()

                    if CONFIG.AUTO_BUY_SEED then
                        -- 2. Trồng cây
                        for _, plot in pairs(myGarden.Plots:GetChildren()) do
                            if not plot:FindFirstChild("Plant") then
                                local seed = CONFIG.PLANT_SEED[1] or "Carrot"
                                -- Lệnh GAG chuẩn: Cần tên Plot, tên hạt, và Vị trí trung tâm
                                Remotes.PlantSeed:FireServer(plot.Name, seed, myGarden.CentralPlot.Position)
                                task.wait(0.1) -- Delay nhẹ để không bị văng
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "NHAN HUB", Content = "Đã bật chế độ tự bay tới vườn!", Duration = 5})
