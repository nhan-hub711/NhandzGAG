-- [[ NHAN HUB | V25 CLEAN & FAST ]]
-- CHỈ TẬP TRUNG: BÁN -> MUA -> TRỒNG TẠI TÂM

repeat task.wait() until game:IsLoaded()

-- DANH SÁCH HẠT GIỐNG CHUẨN CỦA NHÂN
local SeedList = {
    {name = "Carrot", price = 10},
    {name = "Orange Tulip", price = 450},
    {name = "Tomato", price = 800},
    {name = "Daffodil", price = 1000},
    {name = "Watermelon", price = 2500},
    {name = "Pumpkin", price = 3000},
    {name = "Apple", price = 3250},
    {name = "Bamboo", price = 4000},
    {name = "Coconut", price = 6000},
    {name = "Cactus", price = 15000},
    {name = "Dragon Fruit", price = 50000},
    {name = "Mango", price = 100000},
    {name = "Grape", price = 850000},
    {name = "Pepper", price = 1000000},
    {name = "Beanstalk", price = 10000000},
    {name = "Elder Strawberry", price = 70000000}
}

-- TOẠ ĐỘ VÀNG (ĐÃ FIX THEO ẢNH)
local Pos = {
    Garden = CFrame.new(-208.99, 3.11, 68.47), --
    Sell = CFrame.new(36.58, 2.99, 0.38),      --
    Seeds = CFrame.new(36.57, 2.99, 0.38)     --
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Events = {
    Harvest = RS:WaitForChild("Remotes"):WaitForChild("HarvestEvent"), -- Ví dụ tên chuẩn
    Sell = RS:WaitForChild("Remotes"):WaitForChild("SellEvent"),
    Plant = RS:WaitForChild("Remotes"):WaitForChild("PlantEvent"),
    Buy = RS:WaitForChild("Remotes"):WaitForChild("BuyEvent")
}

local function GetMoney()
    return Player.leaderstats.Money.Value
end

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local root = Player.Character.HumanoidRootPart
            local money = GetMoney()
            
            -- BƯỚC 1: BAY ĐI BÁN (STEVEN)
            root.CFrame = Pos.Sell
            task.wait(0.7)
            Events.Sell:FireServer()
            
            -- BƯỚC 2: BAY ĐI MUA HẠT (SAM)
            root.CFrame = Pos.Seeds
            task.wait(0.7)
            local toBuy = "Carrot"
            for i = #SeedList, 1, -1 do
                if money >= (SeedList[i].price * 10) then
                    toBuy = SeedList[i].name
                    Events.Buy:FireServer(toBuy, 10)
                    break
                end
            end
            
            -- BƯỚC 3: VỀ TÂM VƯỜN TRỒNG TỤM
            root.CFrame = Pos.Garden
            task.wait(1)
            Events.Harvest:FireServer() -- Thu hoạch tại chỗ
            
            for i = 1, 20 do
                Events.Plant:FireServer("Plot"..i, toBuy, Pos.Garden.Position)
                -- Lệnh tưới nước nếu ông có bình xịt
                if RS.Remotes:FindFirstChild("WaterEvent") then
                    RS.Remotes.WaterEvent:FireServer("Plot"..i)
                end
            end
        end)
    end
end)
