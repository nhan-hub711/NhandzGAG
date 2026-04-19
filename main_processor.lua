-- [[ NHAN HUB | FIX V4 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG PRO",
   LoadingTitle = "Đang kết nối hệ thống...",
   LoadingSubtitle = "by Nhan",
   ConfigurationSaving = { Enabled = false }
})

local CONFIG = getgenv().NHAN_HUB or {
    AUTO_FARM = true,
    AUTO_BUY_SEED = true,
    BUY_SEED_SHOP = {"Carrot"},
    PLANT_SEED = {"Carrot"}
}

-- Bảng giá
local PriceList = {
    ["Elder Strawberry"] = 70000000, ["Beanstalk"] = 10000000,
    ["Pepper"] = 1000000, ["Grape"] = 850000, ["Mango"] = 100000,
    ["Dragon Fruit"] = 50000, ["Cactus"] = 15000, ["Coconut"] = 6000,
    ["Bamboo"] = 4000, ["Apple"] = 3250, ["Pumpkin"] = 3000,
    ["Watermelon"] = 2500, ["Tomato"] = 800, ["Daffodil"] = 1000,
    ["Orange Tulip"] = 450, ["Carrot"] = 10
}

-- [TẠO TAB] - Phải tạo Tab trước rồi mới thêm Toggle
local Tab1 = Window:CreateTab("Main Farm", 4483362458)

Tab1:CreateToggle({
   Name = "Auto Farm (Thu hoạch/Bán)",
   CurrentValue = CONFIG.AUTO_FARM,
   Callback = function(Value) CONFIG.AUTO_FARM = Value end,
})

Tab1:CreateToggle({
   Name = "Auto Buy & Plant (Theo List)",
   CurrentValue = CONFIG.AUTO_BUY_SEED,
   Callback = function(Value) CONFIG.AUTO_BUY_SEED = Value end,
})

-- [LOGIC XỬ LÝ]
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
_G.CanBuyNow = false

local function GetMyGarden()
    for _, garden in pairs(workspace.Gardens:GetChildren()) do
        if garden:FindFirstChild("Owner") and garden.Owner.Value == Player.Name then return garden end
    end
    return nil
end

-- Bắt tin nhắn Restock
Player.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TextLabel") and string.find(descendant.Text:lower(), "restocked") then
        _G.CanBuyNow = true 
    end
end)

task.spawn(function()
    while task.wait(1.5) do
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if not myGarden then return end
                
                -- Luôn thu hoạch và bán
                Remotes.HarvestAll:FireServer()
                Remotes.SellAllCrops:FireServer()

                if CONFIG.AUTO_BUY_SEED then
                    -- Mua hạt khi có restock
                    if _G.CanBuyNow then
                        local myCash = Player.Data.Beli.Value
                        for _, seed in pairs(CONFIG.BUY_SEED_SHOP) do
                            local price = PriceList[seed] or 99999999
                            if myCash >= price then
                                Remotes.BuySeed:FireServer(seed, 10)
                                break
                            end
                        end
                        _G.CanBuyNow = false
                    end

                    -- Trồng hạt
                    local targetPos = myGarden.CentralPlot.Position
                    for _, plot in pairs(myGarden.Plots:GetChildren()) do
                        if not plot:FindFirstChild("Plant") then
                            for _, seed in pairs(CONFIG.PLANT_SEED) do
                                Remotes.PlantSeed:FireServer(plot.Name, seed, targetPos)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "NHAN HUB", Content = "Đã sửa lỗi hiển thị!", Duration = 3})
