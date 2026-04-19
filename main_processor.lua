-- [[ NHAN HUB | FINAL REPAIR V5 ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG PRO",
   LoadingTitle = "Đang khởi động máy farm...",
   LoadingSubtitle = "by Nhan",
   ConfigurationSaving = { Enabled = false }
})

local CONFIG = getgenv().NHAN_HUB or {
    AUTO_FARM = true,
    AUTO_BUY_SEED = true,
    BUY_SEED_SHOP = {"Carrot"},
    PLANT_SEED = {"Carrot"}
}

-- [TẠO TAB]
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

-- [HỆ THỐNG XỬ LÝ CHÍNH]
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")

-- Hàm tìm vườn (Sửa lại để quét chuẩn hơn)
local function GetMyGarden()
    local gardens = workspace:FindFirstChild("Gardens")
    if gardens then
        for _, g in pairs(gardens:GetChildren()) do
            local ownerObj = g:FindFirstChild("Owner")
            if ownerObj and (ownerObj.Value == Player.Name or ownerObj.Value == Player.DisplayName) then
                return g
            end
        end
    end
    return nil
end

-- Vòng lặp Farm (Tăng tốc độ quét)
task.spawn(function()
    while task.wait(0.5) do -- Chỉnh lại 0.5 giây cho nhanh
        if CONFIG.AUTO_FARM then
            pcall(function()
                local myGarden = GetMyGarden()
                if myGarden then
                    -- 1. Thu hoạch & Bán
                    Remotes.HarvestAll:FireServer()
                    task.wait(0.1)
                    Remotes.SellAllCrops:FireServer()
                    
                    -- 2. Tự mua hạt (Nếu ông ghi trong text.txt)
                    if CONFIG.AUTO_BUY_SEED then
                        -- Thử mua loại hạt đầu tiên trong danh sách của ông
                        local targetSeed = CONFIG.BUY_SEED_SHOP[1] or "Carrot"
                        Remotes.BuySeed:FireServer(targetSeed, 10)
                        
                        -- 3. Trồng cây
                        local plots = myGarden:FindFirstChild("Plots")
                        if plots then
                            for _, plot in pairs(plots:GetChildren()) do
                                if not plot:FindFirstChild("Plant") then
                                    local seedToPlant = CONFIG.PLANT_SEED[1] or "Carrot"
                                    -- Gửi lệnh trồng ngay tại vị trí ô đất
                                    Remotes.PlantSeed:FireServer(plot.Name, seedToPlant, plot.Position)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Rayfield:Notify({Title = "NHAN HUB", Content = "Đã kích hoạt chế độ Farm siêu tốc!", Duration = 5})
