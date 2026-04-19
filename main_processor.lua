-- [[ NHAN HUB | V27 SEQUENCE FIX ]]
-- ÉP ĐI THEO THỨ TỰ: BÁN -> MUA -> VỀ VƯỜN

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
local RS = game:GetService("ReplicatedStorage")
local Events = {}

-- Tìm Remotes (Lệnh game)
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") then
        local n = v.Name:lower()
        if n:find("harvest") then Events.Harvest
