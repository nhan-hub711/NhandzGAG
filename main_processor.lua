-- [[ NHAN HUB | MAIN PROCESSOR ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local CONFIG = getgenv().NHAN_HUB

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG PRO",
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

-- FPS BOOST (Nếu bật trong config)
if CONFIG.FPS_BOOST then
    game:GetService("RunService"):Set3dRenderingEnabled(false)
end

-- [TABS & TOGGLES]
local MainTab = Window:CreateTab("Main Farm", 4483362458)
MainTab:CreateToggle({
   Name = "Master Auto Kaitun",
   CurrentValue = CONFIG.AUTO_FARM,
   Callback = function(Value) CONFIG.AUTO_FARM = Value end,
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
    while task.wait(1.5) do
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if not myGarden then return end
                local myCash = Player.Data.Beli.Value

                Remotes.HarvestAll:FireServer()
                Remotes.SellAllCrops:FireServer()

                if _G.CanBuyNow then
                    -- Auto Buy Seed
                    if CONFIG.AUTO_BUY_SEED then
                        for i = #SeedPrices, 1, -1 do
                            if myCash >= SeedPrices[i].price then
                                Remotes.BuySeed:FireServer(SeedPrices[i].name, 10)
                                break
                            end
                        end
                    end
                    -- Auto Buy Gear
                    if CONFIG.AUTO_BUY_GEAR and myCash >= 50000 then
                        Remotes.BuyGear:FireServer("Watering Car")
                        Remotes.ActivateWateringCar:FireServer(true)
                    end
                    _G.CanBuyNow = false
                end

                -- Auto Planting
                for _, plot in pairs(myGarden.Plots:GetChildren()) do
                    if not plot:FindFirstChild("Plant") then
                        for i = #SeedPrices, 1, -1 do
                            Remotes.PlantSeed:FireServer(plot.Name, SeedPrices[i].name, myGarden.CentralPlot.Position)
                        end
                    end
                end
            end)
        end
    end
end)
