-- [[ NHAN HUB | REMOTE DETECTIVE V14 ]]
-- TỰ ĐỘNG DÒ TÌM LỆNH TRONG TOÀN BỘ HỆ THỐNG

repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG ULTIMATE",
   LoadingTitle = "Đang lùng sục bộ lệnh...",
   LoadingSubtitle = "by Nhan"
})

local Tab = Window:CreateTab("Kaitun", 4483362458)
_G.Kaitun = true

Tab:CreateToggle({
   Name = "Bật/Tắt Kaitun",
   CurrentValue = true,
   Callback = function(v) _G.Kaitun = v end
})

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- [HỆ THỐNG DÒ LỆNH THÔNG MINH]
local Events = {}
local function ScanRemotes()
    local all = RS:GetDescendants()
    for _, obj in pairs(all) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            -- Dò các lệnh quan trọng
            if obj.Name:find("Harvest") then Events.Harvest = obj end
            if obj.Name:find("Sell") then Events.Sell = obj end
            if obj.Name:find("Plant") then Events.Plant = obj end
            if obj.Name:find("Buy") then Events.Buy = obj end
        end
    end
end

ScanRemotes()

-- Thông báo kết quả dò tìm cho ông Nhân biết
if not Events.Harvest then
    Rayfield:Notify({Title = "CẢNH BÁO", Content = "Không tìm thấy lệnh Harvest! Game có thể đã đổi tên lệnh.", Duration = 5})
else
    Rayfield:Notify({Title = "THÀNH CÔNG", Content = "Đã kết nối được với bộ lệnh của Game!", Duration = 5})
end

local function GetMyGarden()
    local gardens = workspace:FindFirstChild("Gardens")
    if gardens then
        for _, g in pairs(gardens:GetChildren()) do
            if g:FindFirstChild("Owner") and g.Owner.Value == Player.Name then return g end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.Kaitun and Events.Harvest then
            pcall(function()
                local garden = GetMyGarden()
                if garden then
                    local root = Player.Character.HumanoidRootPart
                    root.CFrame = garden.CentralPlot.CFrame + Vector3.new(0, 5, 0)
                    
                    -- Gửi lệnh bằng bộ đã dò được
                    Events.Harvest:FireServer()
                    task.wait(0.1)
                    Events.Sell:FireServer()

                    local plots = garden:FindFirstChild("Plots")
                    if plots and Events.Plant then
                        for _, plot in pairs(plots:GetChildren()) do
                            if not plot:FindFirstChild("Plant") then
                                -- Thử trồng Carrot
                                Events.Plant:FireServer(plot.Name, "Carrot", garden.CentralPlot.Position)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
