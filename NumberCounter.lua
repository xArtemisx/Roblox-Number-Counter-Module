local Tween = game:GetService("TweenService")

local suffixes = {"K", "M", "B", "T", "Q"} -- numbers don't go higher than 'Q' in Lua without the use of tools like BigNum

local Counter = {}
Counter.__index = Counter

local function roundhundreth(num)
	return math.floor(((num*100)+0.5))/100
end

function Counter.fromLabel(Label, Format, StartingValue, Prefix)
	local self = setmetatable({}, Counter)
	
	assert(Label ~= nil, "No TextLabel Passed")
	assert(Label:IsA("GuiObject"), "Not a GUIObject")
	
	self.Label = Label
	self.Format = Format --Comma or Abbrev
	
	self.Value = StartingValue
	self.CurrentValue = Instance.new("IntValue")
	self.CurrentValue.Value = StartingValue
	self.Prefix = ""
	
	if Prefix then
		self.Prefix = Prefix
	end
	
	self.Time = 1 --Target time to accomplish change over
	
	if self.Format == "Comma" then
		self.Label.Text = self.Prefix .. self:CommaValue(self.Value)
		
		self._Changed = self.CurrentValue.Changed:Connect(function()
			self.Label.Text = self.Prefix .. self:CommaValue(self.CurrentValue.Value)
		end)
	elseif self.Format == "Abbrev" then
		self.Label.Text = self.Prefix .. self:AbbrevValue(self.Value)
		
		self._Changed = self.CurrentValue.Changed:Connect(function()
			self.Label.Text = self.Prefix .. self:AbbrevValue(self.CurrentValue.Value)
		end)
	end
	
	return self 
end

function Counter:CommaValue(Value)
	local formatted = Value
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function Counter:AbbrevValue(Value)
	local i = math.floor(math.log(Value, 1e3))
	local divvalue = 1000^i
	local s = roundhundreth(Value / divvalue) .. (suffixes[i] or "")
	
	return s
end

function Counter:UpdateValue(NewValue)
	self.Value = NewValue
	
	if self.UpdateTween ~= nil then
		if self._UpdateTweenComplete then
			self._UpdateTweenComplete:Disconnect()
		end
		
		self.UpdateTween:Destroy()
	end
	
	local Info = TweenInfo.new(self.Time, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	
	self.UpdateTween = Tween:Create(self.CurrentValue, Info, {Value = self.Value})
	
	self._UpdateTweenComplete = self.UpdateTween.Completed:Connect(function()
		self.UpdateTween:Destroy()
		self._UpdateTweenComplete:Disconnect()
	end)
	
	self.UpdateTween:Play()
end

function Counter:Destroy()
	if self._Changed then
		self._Changed:Disconnect()
	end
	
	if self._UpdateTweenComplete then
		self._UpdateTweenComplete:Disconnect()
	end
	
	if self.UpdateTween ~= nil then
		self.UpdateTween:Destroy()
	end
	
	self.CurrentValue:Destroy()
	
	self = nil
	return nil
end

return Counter
