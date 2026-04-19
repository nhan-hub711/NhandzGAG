-- [[ NHAN HUB | LITE KAITUN V15 ]]
-- BẢN SIÊU NHẸ - CHUYÊN TRỊ ĐỨNG HÌNH

repeat task.wait() until game:IsLoaded()

-- TẠO MENU ĐƠN GIẢN (KHÔNG DÙNG RAYFIELD)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Status = Instance.new("TextLabel")

ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "NhanHubLite"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0.4, 0)
Title.Text = "NHAN HUB | GAG"
Title.TextColor3 = Color3.fromRGB(255, 255, 0)
Title.TextSize = 18

Status.Parent = MainFrame
Status.Position = UDim2.new(0, 0, 0.5, 0)
Status.Size = UDim2.new(1, 0, 0.4, 0)
Status.Text = "Đang chạy Auto..."
Status.TextColor3 = Color3.fromRGB(0, 255, 0)

-- [LOGIC CHÍNH - TỰ DÒ LỆNH]
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local Events = {}

local function Scan()
    for _, v in pairs(RS:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            if v.Name:find("Harvest") then Events.Harvest = v end
            if v.Name:find("Sell") then Events.Sell = v end
            if v.Name:find("Plant") then Events.Plant = v end
        end
    end
end

Scan()

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            -- Tìm vườn
            local myGarden = nil
            for _, g in pairs(workspace.Gardens:GetChildren()) do
                if g.Owner.Value == Player.Name then myGarden = g break end
            end
            
            if myGarden then
                local root = Player.Character.HumanoidRootPart
                -- Bay tới vườn
                root.CFrame = myGarden.CentralPlot.CFrame + Vector3.new(0, 5, 0)
                
                -- Thực hiện lệnh nếu đã tìm thấy
                if Events.Harvest then Events.Harvest:FireServer() end
                task.wait(0.1)
                if Events.Sell then Events.Sell:FireServer() end
                
                -- Trồng Carrot
                if Events.Plant then
                    for _, p in pairs(myGarden.Plots:GetChildren()) do
                        if not p:FindFirstChild("Plant") then
                            Events.Plant:FireServer(p.Name, "Carrot", myGarden.CentralPlot.Position)
                        end
                    end
                end
                Status.Text = "Đang Farm: OK!"
            else
                Status.Text = "Đang tìm vườn..."
            end
        end)
    end
end)
