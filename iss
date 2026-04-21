local P=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local LP=P.LocalPlayer
local Cam=workspace.CurrentCamera

local enabled=true
local FOV=150

-- GUI
local G=Instance.new("ScreenGui",game.CoreGui)

local T=Instance.new("TextButton",G)
T.Size=UDim2.new(0,150,0,40)
T.Position=UDim2.new(0,20,0,20)
T.Text="ON"
T.BackgroundColor3=Color3.fromRGB(0,170,0)

local C=Instance.new("TextLabel",G)
C.Size=UDim2.new(0,200,0,30)
C.Position=UDim2.new(0,20,0,65)
C.Text="By sttam"
C.BackgroundTransparency=1
C.TextColor3=Color3.new(1,1,1)

T.MouseButton1Click:Connect(function()
	enabled=not enabled
	T.Text=enabled and "ON" or "OFF"
	T.BackgroundColor3=enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
end)

-- FOV
local circle=Drawing.new("Circle")
circle.Radius=FOV
circle.Thickness=2
circle.Filled=false

RS.RenderStepped:Connect(function()
	circle.Position=UIS:GetMouseLocation()
	circle.Visible=enabled
end)

-- ESP
local function ESP(p)
	p.CharacterAdded:Connect(function(c)
		local h=c:WaitForChild("Head")

		local g=Instance.new("BillboardGui",h)
		g.Size=UDim2.new(0,200,0,50)
		g.AlwaysOnTop=true

		local t=Instance.new("TextLabel",g)
		t.Size=UDim2.new(1,0,1,0)
		t.BackgroundTransparency=1
		t.TextScaled=true

		while c.Parent do
			if enabled then
				local hum=c:FindFirstChild("Humanoid")
				if hum then
					local hp=hum.Health/hum.MaxHealth*100
					local col=hp>70 and Color3.fromRGB(0,255,0)
						or hp>30 and Color3.fromRGB(255,255,0)
						or Color3.fromRGB(255,0,0)

					t.TextColor3=col
					t.Text="❤️ "..math.floor(hp)
				end

				local tool=c:FindFirstChildOfClass("Tool")
				if tool then
					t.Text=t.Text.."\n🧰 "..tool.Name
				end
			else
				t.Text=""
			end
			task.wait(0.3)
		end
	end)
end

for _,p in pairs(P:GetPlayers()) do
	if p~=LP then ESP(p) end
end

-- Target Part
local function part(c)
	return c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart
end

-- Closest
local function closest()
	local cl,dist=nil,FOV
	for _,p in pairs(P:GetPlayers()) do
		if p~=LP and p.Character then
			local prt=part(p.Character)
			if prt then
				local pos,on=Cam:WorldToViewportPoint(prt.Position)
				if on then
					local d=(Vector2.new(pos.X,pos.Y)-UIS:GetMouseLocation()).Magnitude
					if d<dist then
						dist=d
						cl=p
					end
				end
			end
		end
	end
	return cl
end

-- Aim Assist
UIS.InputBegan:Connect(function(i)
	if i.KeyCode==Enum.KeyCode.Q and enabled then
		local t=closest()
		if t and t.Character then
			local prt=part(t.Character)
			if prt then
				Cam.CFrame=CFrame.new(Cam.CFrame.Position,prt.Position)
				print("By sttam - PRO Assist 🔥")
			end
		end
	end
end)
