-- [[ NHAN HUB | V24 BLACK HOLE FARMING ]]
-- GOM TẤT CẢ CÂY TRỒNG VÀO 1 TOẠ ĐỘ TÂM VƯỜN

repeat task.wait() until game:IsLoaded()

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

local Pos = {
    Garden = CFrame.new(-208.99, 3.11, 68.47), -- Tọa độ tâm vườn của ông
    Sell = CFrame.new(36.58, 2.99, 0.38),
    Seeds = CFrame.new(36.57, 2.99, 0.38),
    Gear = CFrame.new(-238.04, 2.99, 0.38)
}

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Events = {}

for _, v in pairs(RS:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        local n = v.Name:lower()
        if n:find("harvest") then Events.Harvest = v end
        if n:find("sell") then Events.Sell = v end
        if n:find("plant") then Events.Plant = v end
        if n:find("buy") then Events.Buy = v end
        if n:find("water") then Events.Water = v end
    end
end

local function GetMoney()
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local m = stats:FindFirstChild("Money") or stats:FindFirstChild("Coins")
        if m then return m.Value end
    end
    return 0
end

task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            local root = Player.Character.HumanoidRootPart
            local myMoney = GetMoney()
            
            -- 1. BÁN ĐỒ
            root.CFrame = Pos.Sell
            task.wait(0.5)
            if Events.Sell then Events.Sell:FireServer() end
            
            -- 2. MUA HẠT (CHỌN HẠT XỊN NHẤT)
            root.CFrame = Pos.Seeds
            task.wait(0.5)
            local bestSeed = "Carrot"
            for i = #SeedList, 1, -1 do
                if myMoney >= (SeedList[i].price * 10) then
                    if Events.Buy then 
                        Events.Buy:FireServer(SeedList[i].name, 10)
                        bestSeed = SeedList[i].name
                        break 
                    end
                end
            end

            -- 3. VỀ VƯỜN (TRỒNG TỤM LẠI MỘT CHỖ)
            root.CFrame = Pos.Garden
            task.wait(0.7)
            
            -- Thu hoạch hết tại chỗ
            if Events.Harvest then Events.Harvest:FireServer() end
            task.wait(0.3)
            
            -- TRỒNG TẤT CẢ VÀO ĐÚNG 1 TOẠ ĐỘ TÂM VƯỜN
            for i = 1, 20 do
                if Events.Plant then
                    -- Ép game nhận lệnh trồng mọi Plot tại tọa độ Garden của ông
                    Events.Plant:FireServer("Plot"..i, bestSeed, Pos.Garden.Position)
                    Events.Plant:FireServer(tostring(i), bestSeed, Pos.Garden.Position)
                end
                
                -- Tưới nước luôn tại điểm đó
                if Events.Water then
                    Events.Water:FireServer("Plot"..i)
                    Events.Water:FireServer(tostring(i))
                end
                -- Không cần wait lâu vì trồng cùng 1 chỗ không bị kẹt
            end
        end)
    end
end)

print("NHAN HUB V24: CHẾ ĐỘ TRỒNG TỤM 1 ĐIỂM ĐÃ BẬT!")
