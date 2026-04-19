-- [[ NHAN HUB | PRO PROCESSOR SYSTEM V3 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local CONFIG = getgenv().NHAN_HUB

-- Bảng giá để Script biết đường tính toán tiền bạc
local PriceList = {
    ["Elder Strawberry"] = 70000000, ["Beanstalk"] = 10000000,
    ["Pepper"] = 1000000, ["Grape"] = 850000, ["Mango"] = 100000,
    ["Dragon Fruit"] = 50000, ["Cactus"] = 15000, ["Coconut"] = 6000,
    ["Bamboo"] = 4000, ["Apple"] = 3250, ["Pumpkin"] = 3000,
    ["Watermelon"] = 2500, ["Tomato"] = 800, ["Daffodil"] = 1000,
    ["Orange Tulip"] = 450, ["Carrot"] = 10
}

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG PRO",
   LoadingTitle = "System Loading...",
   LoadingSubtitle = "by Nhan",
   ConfigurationSaving = { Enabled = true, FolderName = "NhanHub_GAG", FileName = "MainConfig" }
})

-- [VARIABLES]
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
_G.CanBuyNow = false

-- [TABS]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

MainTab:CreateToggle({
   Name = "Master Auto Farm",
   CurrentValue = CONFIG.AUTO_FARM,
   Callback = function(Value) CONFIG.AUTO_FARM = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Buy Seed (Smart)",
   CurrentValue = CONFIG.AUTO_BUY_SEED,
   Callback = function(Value) CONFIG.AUTO_BUY_SEED = Value end,
})

SettingsTab:CreateToggle({
   Name = "FPS Boost",
   CurrentValue = CONFIG.FPS_BOOST,
   Callback = function(Value) 
      CONFIG.FPS_BOOST = Value 
      game:GetService("RunService"):Set3dRenderingEnabled(not Value)
   end,
})

-- [LOGIC]
local function GetMyGarden()
    for _, garden in pairs(workspace.Gardens:GetChildren()) do
        if garden:FindFirstChild("Owner") and garden.Owner.Value == Player.Name then return garden end
    end
    return nil
end

Player.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
        task.wait(0.1)
        if string.find(descendant.Text:lower(), "seed shop") and string.find(descendant.Text:lower(), "restocked") then
            _G.CanBuyNow = true 
        end
    end
end)

task.spawn(function()
    while task.wait(1.2) do
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if not myGarden then return end
                local myCash = Player.Data.Beli.Value

                Remotes.HarvestAll:FireServer()
                Remotes.SellAllCrops:FireServer()

                -- Mua hạt thông minh: Duyệt danh sách từ text.txt và check giá
                if _G.CanBuyNow and CONFIG.AUTO_BUY_SEED then
                    for _, seedName in pairs(CONFIG.BUY_SEED_SHOP) do
                        local price = PriceList[seedName] or 999999999
                        if myCash >= price then
                            Remotes.BuySeed:FireServer(seedName, 10)
                            break -- Mua xong loại xịn nhất là nghỉ, chờ đợt sau
                        end
                    end
                    _G.CanBuyNow = false
                end

                -- Trồng cây tụm lại một chỗ cho nhanh
                local targetPos = myGarden.CentralPlot.Position
                for _, plot in pairs(myGarden.Plots:GetChildren()) do
                    if not plot:FindFirstChild("Plant") then
                        for _, seedName in pairs(CONFIG.PLANT_SEED) do
                            Remotes.PlantSeed:FireServer(plot.Name, seedName, targetPos)
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
   Title = "NHAN HUB READY",
   Content = "Hệ thống check giá thông minh đã sẵn sàng!",
   Duration = 5,
})
