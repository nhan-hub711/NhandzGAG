-- [[ NHAN HUB | DIAGNOSTIC KAITUN V13 ]]
-- BẢN NÀY CÓ LOA BÁO LỖI ĐỂ BIẾT TẠI SAO NÓ ĐỨNG YÊN

repeat task.wait() until game:IsLoaded()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "NHAN HUB | GAG FIX 100%",
   LoadingTitle = "Đang kiểm tra hệ thống...",
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

-- 1. TỰ ĐỘNG DÒ TÌM THƯ MỤC LỆNH (REMOTES)
local Remotes = RS:FindFirstChild("Remotes") or RS:FindFirstChild("Events") or RS:FindFirstChild("RemoteEvents")
if not Remotes then
    Rayfield:Notify({Title = "LỖI NẶNG", Content = "Không tìm thấy thư mục Remotes trong ReplicatedStorage!", Duration = 10})
end

-- 2. HÀM TÌM VƯỜN "QUÉT SẠCH BẢN ĐỒ"
local function FindMyGarden()
    -- Thử tìm trong workspace.Gardens
    local gardens = workspace:FindFirstChild("Gardens")
    if gardens then
        for _, g in pairs(gardens:GetChildren()) do
            -- Kiểm tra mọi thứ: Tên owner, ID owner, hoặc tên folder trùng tên người chơi
            if g:FindFirstChild("Owner") and (g.Owner.Value == Player.Name or tostring(g.Owner.Value) == tostring(Player.UserId)) then
                return g
            elseif g.Name == Player.Name or g.Name == tostring(Player.UserId) then
                return g
            end
        end
    end
    -- Nếu không thấy, quét toàn bộ Workspace tìm folder có tên ông
    local altGarden = workspace:FindFirstChild(Player.Name) or workspace:FindFirstChild("Garden_"..Player.Name)
    if altGarden then return altGarden end
    
    return nil
end

task.spawn(function()
    while task.wait(0.5) do
        if _G.Kaitun then
            local garden = FindMyGarden()
            
            if not garden then
                -- Nếu không tìm thấy vườn, nó sẽ hiện thông báo mỗi 5s để ông biết
                Rayfield:Notify({Title = "CẢNH BÁO", Content = "Vẫn chưa tìm thấy vườn của ông trên bản đồ!", Duration = 2})
                task.wait(5)
            else
                pcall(function()
                    local root = Player.Character.HumanoidRootPart
                    -- Bay tới vườn (Dùng CentralPlot hoặc Plot đầu tiên tìm thấy)
                    local targetPos = garden:FindFirstChild("CentralPlot") or garden:FindFirstChild("Plots"):GetChildren()[1]
                    
                    if targetPos then
                        root.CFrame = targetPos.CFrame + Vector3.new(0, 5, 0)
                        
                        -- GỬI LỆNH FARM (Thử mọi tên lệnh có thể có)
                        if Remotes:FindFirstChild("HarvestAll") then Remotes.HarvestAll:FireServer() end
                        if Remotes:FindFirstChild("SellAllCrops") then Remotes.SellAllCrops:FireServer() end
                        
                        -- Trồng cây
                        local plots = garden:FindFirstChild("Plots")
                        if plots then
                            for _, plot in pairs(plots:GetChildren()) do
                                if not plot:FindFirstChild("Plant") then
                                    -- Lấy đại hạt Carrot hoặc Strawberry trong túi để trồng
                                    Remotes.PlantSeed:FireServer(plot.Name, "Carrot", targetPos.Position)
                                    Remotes.PlantSeed:FireServer(plot.Name, "Strawberry", targetPos.Position)
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end)

Rayfield:Notify({Title = "NHAN HUB", Content = "Đã bật radar tìm vườn!", Duration = 5})
