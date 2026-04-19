-- [[ NHAN HUB | MAIN PROCESSOR PRO ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local CONFIG = getgenv().NHAN_HUB

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG PRO SYSTEM",
   LoadingTitle = "Initializing Processor...",
   LoadingSubtitle = "by Nhan",
   ConfigurationSaving = { Enabled = true, FolderName = "NhanHub_GAG", FileName = "MainConfig" }
})

-- [VARIABLES]
local Player = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
_G.CanBuyNow = false

local SeedPrices = {
    {name = "Carrot", price = 10}, {name = "Orange Tulip", price = 450},
    {name = "Tomato", price = 800}, {name = "Daffodil", price = 1000},
    {name = "Watermelon", price = 2500}, {name = "Pumpkin", price = 3000},
    {name = "Apple", price = 3250}, {name = "Bamboo", price = 4000},
    {name = "Coconut", price = 6000}, {name = "Cactus", price = 15000},
    {name = "Dragon Fruit", price = 50000}, {name = "Mango", price = 100000},
    {name = "Grape", price = 850000}, {name = "Pepper", price = 1000000},
    {name = "Beanstalk", price = 10000000}, {name = "Elder Strawberry", price = 70000000}
}

-- [TABS]
local MainTab = Window:CreateTab("Main Farm", 4483362458)
local MiscTab = Window:CreateTab("Settings", 4483362458)

-- [MAIN FARM TAB]
MainTab:CreateToggle({
   Name = "Master Auto Kaitun",
   CurrentValue = CONFIG.AUTO_FARM,
   Callback = function(Value) CONFIG.AUTO_FARM = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Buy Seed (Restock)",
   CurrentValue = CONFIG.AUTO_BUY_SEED,
   Callback = function(Value) CONFIG.AUTO_BUY_SEED = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Buy Gear",
   CurrentValue = CONFIG.AUTO_BUY_GEAR,
   Callback = function(Value) CONFIG.AUTO_BUY_GEAR = Value end,
})

-- [SETTINGS TAB]
MiscTab:CreateToggle({
   Name = "FPS Boost (Black Screen)",
   CurrentValue = CONFIG.FPS_BOOST,
   Callback = function(Value) 
      CONFIG.FPS_BOOST = Value 
      game:GetService("RunService"):Set3dRenderingEnabled(not Value)
   end,
})

-- Kích hoạt FPS Boost ngay khi load nếu config là true
if CONFIG.FPS_BOOST then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end

-- [LOGIC]
local function GetMyGarden()
    for _, garden in pairs(workspace.Gardens:GetChildren()) do
        if garden:FindFirstChild("Owner") and garden.Owner.Value == Player.Name then return garden end
    end
    return nil
end

-- Bắt tin nhắn Restock
Player.PlayerGui.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("TextLabel") or descendant:IsA("TextBox") then
        task.wait(0.1)
        local msg = descendant.Text:lower()
        if string.find(msg, "seed shop") and string.find(msg, "restocked") then
            _G.CanBuyNow = true 
        end
    end
end)

-- Vòng lặp chính
task.spawn(function()
    while task.wait(1.5) do
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if not myGarden then return end
                local myCash = Player.Data.Beli.Value

                -- Thu hoạch & Bán
                Remotes.HarvestAll:FireServer()
                Remotes.SellAllCrops:FireServer()
                Remotes.SellAllPets:FireServer("Common")
                Remotes.SellAllPets:FireServer("Uncommon")

                -- Shopping khi có Restock
                if _G.CanBuyNow then
                    if CONFIG.AUTO_BUY_SEED then
                        for i = #SeedPrices, 1, -1 do
                            if myCash >= SeedPrices[i].price then
                                Remotes.BuySeed:FireServer(SeedPrices[i].name, 10)
                                break
                            end
                        end
                    end
                    
                    if CONFIG.AUTO_BUY_GEAR and myCash >= 50000 then
                        Remotes.BuyGear:FireServer("Watering Car")
                        Remotes.ActivateWateringCar:FireServer(true)
                    end
                    _G.CanBuyNow = false
                end

                -- Auto Trồng cây tụm lại một chỗ
                local targetPos = myGarden.CentralPlot.Position
                for _, plot in pairs(myGarden.Plots:GetChildren()) do
                    if not plot:FindFirstChild("Plant") then
                        for i = #SeedPrices, 1, -1 do
                            Remotes.PlantSeed:FireServer(plot.Name, SeedPrices[i].name, targetPos)
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({
   Title = "NHAN HUB READY",
   Content = "Chúc ông Nhân cày tiền vui vẻ!",
   Duration = 5,
})
