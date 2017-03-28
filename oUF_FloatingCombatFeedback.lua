local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF FloatingCombatFeedback was unable to locate oUF install")

local _G = getfenv(0)
local pairs = _G.pairs
local m_cos = _G.math.cos
local m_max = _G.math.max
local m_pi = _G.math.pi
local m_sin = _G.math.sin
local t_insert = _G.table.insert
local t_remove = _G.table.remove

-- sourced from FrameXML/Constants.lua
local SCHOOL_MASK_NONE = _G.SCHOOL_MASK_NONE or 0x00
local SCHOOL_MASK_PHYSICAL = _G.SCHOOL_MASK_PHYSICAL or 0x01
local SCHOOL_MASK_HOLY = _G.SCHOOL_MASK_HOLY or 0x02
local SCHOOL_MASK_FIRE = _G.SCHOOL_MASK_FIRE or 0x04
local SCHOOL_MASK_NATURE = _G.SCHOOL_MASK_NATURE or 0x08
local SCHOOL_MASK_FROST = _G.SCHOOL_MASK_FROST or 0x10
local SCHOOL_MASK_SHADOW = _G.SCHOOL_MASK_SHADOW or 0x20
local SCHOOL_MASK_ARCANE = _G.SCHOOL_MASK_ARCANE or 0x40

local colors = {
	ABSORB		= {r = 1.00, g = 1.00, b = 1.00},
	BLOCK		= {r = 1.00, g = 1.00, b = 1.00},
	DEFLECT		= {r = 1.00, g = 1.00, b = 1.00},
	DODGE		= {r = 1.00, g = 1.00, b = 1.00},
	ENERGIZE	= {r = 0.41, g = 0.80, b = 0.94},
	EVADE		= {r = 1.00, g = 1.00, b = 1.00},
	HEAL		= {r = 0.10, g = 0.80, b = 0.10},
	IMMUNE		= {r = 1.00, g = 1.00, b = 1.00},
	INTERRUPT	= {r = 1.00, g = 1.00, b = 1.00},
	MISS		= {r = 1.00, g = 1.00, b = 1.00},
	PARRY		= {r = 1.00, g = 1.00, b = 1.00},
	REFLECT		= {r = 1.00, g = 1.00, b = 1.00},
	RESIST		= {r = 1.00, g = 1.00, b = 1.00},
	WOUND		= {r = 0.70, g = 0.10, b = 0.10},
}

local schoolColors = {
	[SCHOOL_MASK_NONE]		= {r = 1.00, g = 1.00, b = 1.00},
	[SCHOOL_MASK_PHYSICAL]	= {r = 0.70, g = 0.10, b = 0.10},
	[SCHOOL_MASK_HOLY]		= {r = 1.00, g = 0.90, b = 0.50},
	[SCHOOL_MASK_FIRE]		= {r = 1.00, g = 0.50, b = 0.00},
	[SCHOOL_MASK_NATURE]	= {r = 0.30, g = 1.00, b = 0.30},
	[SCHOOL_MASK_FROST]		= {r = 0.50, g = 1.00, b = 1.00},
	[SCHOOL_MASK_SHADOW]	= {r = 0.50, g = 0.50, b = 1.00},
	[SCHOOL_MASK_ARCANE]	= {r = 1.00, g = 0.50, b = 1.00},
}

local function RemoveString(self, i, string)
	t_remove(self.FeedbackToAnimate, i)
	string:SetText(nil)
	string:SetAlpha(0)
	string:Hide()

	return string
end

local function GetAvailableString(self)
	for i = 1, self.__max do
		if not self[i]:IsShown() then
			return self[i]
		end
	end

	return RemoveString(self, 1, self.FeedbackToAnimate[1])
end

local function FountainScroll(self)
	return self.x + self.xDirection * 65 * (1 - m_cos(m_pi / 2 * self.elapsed / self.scrollTime)),
		self.y + self.yDirection * 65 * m_sin(m_pi / 2 * self.elapsed / self.scrollTime)
end

local function StandardScroll(self)
	return self.x,
		self.y + self.yDirection * 65 * self.elapsed / self.scrollTime
end

local function SetScrolling(self, elapsed)
	for index, string in pairs(self.FeedbackToAnimate) do
		if string.elapsed >= string.scrollTime then
			RemoveString(self, index, string)
		else
			string.elapsed = string.elapsed + elapsed

			string:SetPoint("CENTER", self, "CENTER", self.Scroll(string))

			if (string.elapsed >= self.fadeout) then
				string:SetAlpha(m_max(1 - (string.elapsed - self.fadeout) / (self.scrollTime - self.fadeout), 0))
			end
		end
	end

	if #self.FeedbackToAnimate == 0 then
		self:SetScript("OnUpdate", nil)
	end
end

local function OnShow(self)
	for index, string in pairs(self.FeedbackToAnimate) do
		RemoveString(self, index, string)
	end
end

local function Update(self, event, unit, message, flag, amount, school)
	if self.unit ~= unit then return end

	local fcf = self.FloatingCombatFeedback
	local multiplier = 1
	local text, color

	if message == "WOUND" and not fcf.ignoreDamage then
		if amount ~= 0	then
			text = "-"..fcf.HandleNumbers(amount)
			color = schoolColors[school] or
					fcf.colors and fcf.colors[message] or
					colors[message]

			if flag == "CRITICAL" or flag == "CRUSHING" then
				multiplier = 1.25
			elseif flag == "GLANCING" then
				multiplier = 0.75
			end
		elseif flag and flag ~= "CRITICAL" and flag ~= "CRUSHING" and flag ~= "GLANCING" and not fcf.ignoreMisc then
			text = _G[flag]
			color = fcf.colors and fcf.colors[flag] or colors[flag]
		end
	elseif message == "ENERGIZE" and not fcf.ignoreEnergize then
		text = "+"..fcf.HandleNumbers(amount)
		color = fcf.colors and fcf.colors[message] or colors[message]

		if flag == "CRITICAL" then
			multiplier = 1.25
		end
	elseif message == "HEAL" and not fcf.ignoreHeal then
		text = "+"..fcf.HandleNumbers(amount)
		color = fcf.colors and fcf.colors[message] or colors[message]

		if flag == "CRITICAL" then
			multiplier = 1.25
		end
	elseif not fcf.ignoreMisc then
		text = _G[message]
		color = fcf.colors and fcf.colors[message] or colors[message]
	end

	if text then
		local string = GetAvailableString(fcf)

		string.elapsed = 0
		string.scrollTime = fcf.scrollTime
		string.xDirection = fcf.xDirection
		string.yDirection = fcf.yDirection
		string.x = fcf.xOffset * string.xDirection
		string.y = fcf.yOffset * string.yDirection

		string:SetText(text)
		string:SetTextHeight(fcf.fontHeight * multiplier)
		string:SetTextColor(color.r, color.g, color.b)
		string:SetPoint("CENTER", fcf, "CENTER", string.x, string.y)
		string:SetAlpha(1)
		string:Show()

		t_insert(fcf.FeedbackToAnimate, string)

		fcf.xDirection = fcf.xDirection * -1

		if not fcf:GetScript("OnUpdate") then
			fcf:SetScript("OnUpdate", SetScrolling)
		end
	end
end

local function Path(self, ...)
	return (self.FloatingCombatFeedback.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local fcf = self.FloatingCombatFeedback

	if not fcf then return end

	fcf.__owner = self
	fcf.__max = #fcf
	fcf.ForceUpdate = ForceUpdate

	fcf.scrollTime = fcf.scrollTime or 1.5
	fcf.fadeout = fcf.scrollTime / 3
	fcf.xDirection = 1
	fcf.yDirection = fcf.yDirection or 1
	fcf.fontHeight = fcf.fontHeight or 18
	fcf.HandleNumbers = fcf.abbreviateNumbers and _G.AbbreviateNumbers or _G.BreakUpLargeNumbers
	fcf.FeedbackToAnimate = {}

	if fcf.mode == "Fountain" then
		fcf.Scroll = FountainScroll
		fcf.xOffset = fcf.xOffset or 6
		fcf.yOffset = fcf.yOffset or 8
	else
		fcf.Scroll = StandardScroll
		fcf.xOffset = fcf.xOffset or 30
		fcf.yOffset = fcf.yOffset or 8
	end

	for i = 1, fcf.__max do
		fcf[i]:Hide()
	end

	fcf:HookScript("OnShow", OnShow)

	self:RegisterEvent("UNIT_COMBAT", Path)

	return true
end

local function Disable(self)
	local fcf = self.FloatingCombatFeedback

	if fcf then
		self:UnregisterEvent("UNIT_COMBAT", Path)
	end
end

oUF:AddElement("FloatingCombatFeedback", Path, Enable, Disable)
