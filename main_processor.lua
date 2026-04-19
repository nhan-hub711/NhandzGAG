-- [[ NHAN HUB | V26 RADAR FIX ]]
-- TỰ ĐỘNG DÒ LỆNH TRÊN TOÀN HỆ THỐNG - BỎ QUA EASTER

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
    Garden = CFrame.new(-208.99, 3.11, 68.47),
    Sell = CFrame.new(36.58, 2.99, 0.38),
    Seeds = CFrame.new(36.57, 2.99, 0.38)
}

local Player = game.Players.LocalPlayer
local Events = {}

-- [[ CON RADAR TỰ DÒ LỆNH ]]
local function ScanEvents()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            -- Bỏ qua mấy cái lệnh liên quan tới Easter/Event cho đỡ lag
            if not n:find("easter") and not n:find("event") then
                if n:find("harvest") then Events.Harvest = v end
                if n:find("sell") then Events.Sell = v end
                if n:find("plant") then Events.Plant = v end
                if n:find("buy") then Events.Buy = v end
                if n:find("water") then Events.Water = v end
            end
        end
    end
end

ScanEvents()

local function GetMoney()
    local stats = Player:FindFirstChild("leaderstats")
    if stats then
        local m = stats:FindFirstChild("Money") or stats:FindFirstChild("Coins")
        if m then return m.Value end
    end
    return 0
end

task.spawn(function()
    while task.wait(2.5) do -- Tăng thời gian chờ tí cho máy Nhân load kịp
        pcall(function()
            local root = Player.Character.HumanoidRootPart
            local myMoney = GetMoney()
            
            -- 1. ĐI BÁN (STEVEN)
            root.CFrame = Pos.Sell
            task.wait(1) -- Chờ đứng im hẳn mới bấm bán
            if Events.Sell then Events.Sell:FireServer() end
            
            -- 2. ĐI MUA (SAM)
            root.CFrame = Pos.Seeds
            task.wait(1)
            local toBuy = "Carrot"
            for i = #SeedList, 1, -1 do
                if myMoney >= (SeedList[i].price * 10) then
                    toBuy = SeedList[i].name
                    if Events.Buy then Events.Buy:FireServer(toBuy, 10) end
                    break
                end
            end

            -- 3. VỀ VƯỜN TRỒNG TỤM
            root.CFrame = Pos.Garden
            task.wait(1.2)
            if Events.Harvest then Events.Harvest:FireServer() end
            
            for i = 1, 20 do
                if Events.Plant then
                    -- Trồng tụm vào 1 điểm tọa độ Garden
                    Events.Plant:FireServer("Plot"..i, toBuy, Pos.Garden.Position)
                    Events.Plant:FireServer(tostring(i), toBuy, Pos.Garden.Position)
                end
                if Events.Water then 
                    Events.Water:FireServer("Plot"..i)
                    Events.Water:FireServer(tostring(i))
                end
            end
        end)
    end
end)

print("NHAN HUB V26: RADAR ĐÃ QUÉT XONG, ĐANG CHẠY...")
