local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF FloatingCombatFeedback was unable to locate oUF install")

local _G = getfenv(0)
local m_cos = _G.math.cos
local m_max = _G.math.max
local m_pi = _G.math.pi
local m_sin = _G.math.sin
local pairs = _G.pairs
local t_insert = _G.table.insert
local t_remove = _G.table.remove
local t_wipe = _G.table.wipe

local AbbreviateNumbers = _G.AbbreviateNumbers
local BreakUpLargeNumbers = _G.BreakUpLargeNumbers

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
	["ABSORB"   ] = {r = 1.00, g = 1.00, b = 1.00},
	["BLOCK"    ] = {r = 1.00, g = 1.00, b = 1.00},
	["DEFLECT"  ] = {r = 1.00, g = 1.00, b = 1.00},
	["DODGE"    ] = {r = 1.00, g = 1.00, b = 1.00},
	["ENERGIZE" ] = {r = 0.41, g = 0.80, b = 0.94},
	["EVADE"    ] = {r = 1.00, g = 1.00, b = 1.00},
	["HEAL"     ] = {r = 0.10, g = 0.80, b = 0.10},
	["IMMUNE"   ] = {r = 1.00, g = 1.00, b = 1.00},
	["INTERRUPT"] = {r = 1.00, g = 1.00, b = 1.00},
	["MISS"     ] = {r = 1.00, g = 1.00, b = 1.00},
	["PARRY"    ] = {r = 1.00, g = 1.00, b = 1.00},
	["REFLECT"  ] = {r = 1.00, g = 1.00, b = 1.00},
	["RESIST"   ] = {r = 1.00, g = 1.00, b = 1.00},
	["WOUND"    ] = {r = 0.70, g = 0.10, b = 0.10},
}

local schoolColors = {
	[SCHOOL_MASK_ARCANE  ] = {r = 1.00, g = 0.50, b = 1.00},
	[SCHOOL_MASK_FIRE    ] = {r = 1.00, g = 0.50, b = 0.00},
	[SCHOOL_MASK_FROST   ] = {r = 0.50, g = 1.00, b = 1.00},
	[SCHOOL_MASK_HOLY    ] = {r = 1.00, g = 0.90, b = 0.50},
	[SCHOOL_MASK_NATURE  ] = {r = 0.30, g = 1.00, b = 0.30},
	[SCHOOL_MASK_NONE    ] = {r = 1.00, g = 1.00, b = 1.00},
	[SCHOOL_MASK_PHYSICAL] = {r = 0.70, g = 0.10, b = 0.10},
	[SCHOOL_MASK_SHADOW  ] = {r = 0.50, g = 0.50, b = 1.00},
}

local animations = {
	["fountain"] = function(self)
		return self.x + self.xDirection * 65 * (1 - m_cos(m_pi / 2 * self.elapsed / self.scrollTime)),
			self.y + self.yDirection * 65 * m_sin(m_pi / 2 * self.elapsed / self.scrollTime)
	end,
	["vertical"] = function(self)
		return self.x,
			self.y + self.yDirection * 65 * self.elapsed / self.scrollTime
	end,
	["horizontal"] = function(self)
		return self.x  + self.xDirection * 65 * self.elapsed / self.scrollTime,
			self.y
	end,
	["diagonal"] = function(self)
		return self.x  + self.xDirection * 65 * self.elapsed / self.scrollTime,
			self.y + self.yDirection * 65 * self.elapsed / self.scrollTime
	end,
}

local animationsByEvent = {
	["ABSORB"   ] = "fountain",
	["BLOCK"    ] = "fountain",
	["DEFLECT"  ] = "fountain",
	["DODGE"    ] = "fountain",
	["ENERGIZE" ] = "fountain",
	["EVADE"    ] = "fountain",
	["HEAL"     ] = "fountain",
	["IMMUNE"   ] = "fountain",
	["INTERRUPT"] = "fountain",
	["MISS"     ] = "fountain",
	["PARRY"    ] = "fountain",
	["REFLECT"  ] = "fountain",
	["RESIST"   ] = "fountain",
	["WOUND"    ] = "fountain",
}

local animationsByFlag = {
	-- [" "       ] = "fountain",
	-- ["CRITICAL"] = "fountain",
	-- ["CRUSHING"] = "fountain",
	-- ["GLANCING"] = "fountain",
}

local xOffsetsByAnimation = {
	["diagonal"  ] = 24,
	["fountain"  ] = 24,
	["horizontal"] = 8,
	["vertical"  ] = 8,
}

local yOffsetsByAnimation = {
	["diagonal"  ] = 8,
	["fountain"  ] = 8,
	["horizontal"] = 8,
	["vertical"  ] = 8,
}

local multipliersByFlag = {
	[" "       ] = 1,
	["CRITICAL"] = 1.25,
	["CRUSHING"] = 1.25,
	["GLANCING"] = 0.75,
}

local function removeString(self, i, string)
	t_remove(self.FeedbackToAnimate, i)
	string:SetText(nil)
	string:SetAlpha(0)
	string:Hide()

	return string
end

local function getAvailableString(self)
	for i = 1, #self do
		if not self[i]:IsShown() then
			return self[i]
		end
	end

	return removeString(self, 1, self.FeedbackToAnimate[1])
end

local function onUpdate(self, elapsed)
	for index, string in pairs(self.FeedbackToAnimate) do
		if string.elapsed >= string.scrollTime then
			removeString(self, index, string)
		else
			string.elapsed = string.elapsed + elapsed

			string:SetPoint("CENTER", self, "CENTER", string:GetXY())

			if (string.elapsed >= self.fadeout) then
				string:SetAlpha(m_max(1 - (string.elapsed - self.fadeout) / (self.scrollTime - self.fadeout), 0))
			end
		end
	end
end

local function onShowHide(self)
	t_wipe(self.FeedbackToAnimate)

	for i = 1, #self do
		self[i]:SetText(nil)
		self[i]:SetAlpha(0)
		self[i]:Hide()
	end
end

local function Update(self, _, unit, event, flag, amount, school)
	if self.unit ~= unit then return end
	local element = self.FloatingCombatFeedback

	local text, color
	if event == "WOUND" and not element.ignoreDamage then
		if amount ~= 0	then
			if element.abbreviateNumbers then
				text = "-"..AbbreviateNumbers(amount)
			else
				text = "-"..BreakUpLargeNumbers(amount)
			end

			color = element.schoolColors and element.schoolColors[school] or schoolColors[school]
				or element.colors and element.colors[event] or colors[event]
		elseif flag and flag ~= "CRITICAL" and flag ~= "CRUSHING" and flag ~= "GLANCING" and not element.ignoreMisc then
			text = _G[flag]
			color = element.colors and element.colors[flag] or colors[flag]
		end
	elseif event == "ENERGIZE" and not element.ignoreEnergize then
		if element.abbreviateNumbers then
			text = "+"..AbbreviateNumbers(amount)
		else
			text = "+"..BreakUpLargeNumbers(amount)
		end

		color = element.colors and element.colors[event] or colors[event]
	elseif event == "HEAL" and not element.ignoreHeal then
		if element.abbreviateNumbers then
			text = "+"..AbbreviateNumbers(amount)
		else
			text = "+"..BreakUpLargeNumbers(amount)
		end

		color = element.colors and element.colors[event] or colors[event]
	elseif not element.ignoreMisc then
		text = _G[event]
		color = element.colors and element.colors[event] or colors[event]
	end

	if text then
		local animation = element.animationsByFlag and element.animationsByFlag[flag] or animationsByFlag[flag]
			or element.animationsByEvent and element.animationsByEvent[event] or animationsByEvent[event]
			or "fountain"
		local string = getAvailableString(element)

		string.elapsed = 0
		string.GetXY = animations[animation]
		string.scrollTime = element.scrollTime
		string.xDirection = element.xDirection
		string.yDirection = element.yDirection
		string.x = (element.xOffsetsByAnimation and element.xOffsetsByAnimation[animation] or xOffsetsByAnimation[animation]) * string.xDirection
		string.y = (element.yOffsetsByAnimation and element.yOffsetsByAnimation[animation] or yOffsetsByAnimation[animation]) * string.yDirection

		string:SetText(text)
		string:SetTextHeight(element.fontHeight * (multipliersByFlag[flag] or multipliersByFlag[" "]))
		string:SetTextColor(color.r, color.g, color.b)
		string:SetPoint("CENTER", element, "CENTER", string.x, string.y)
		string:SetAlpha(1)
		string:Show()

		t_insert(element.FeedbackToAnimate, string)

		element.xDirection = element.xDirection * -1
	end
end

local function Path(self, ...)
	return (self.FloatingCombatFeedback.Override or Update) (self, ...)
end

local function ForceUpdate(element)
	return Path(element.__owner, "ForceUpdate", element.__owner.unit)
end

local function Enable(self)
	local element = self.FloatingCombatFeedback
	if not element then return end

	element.__owner = self
	element.ForceUpdate = ForceUpdate
	element.FeedbackToAnimate = {}

	element.scrollTime = element.scrollTime or 1.5
	element.fadeout = element.scrollTime / 3
	element.fontHeight = element.fontHeight or 18
	element.xDirection = 1
	element.yDirection = element.yDirection or 1

	for i = 1, #element do
		element[i]:Hide()
	end

	element:SetScript("OnHide", onShowHide)
	element:SetScript("OnShow", onShowHide)
	element:SetScript("OnUpdate", onUpdate)

	self:RegisterEvent("UNIT_COMBAT", Path)

	return true
end

local function Disable(self)
	local element = self.FloatingCombatFeedback

	if element then
		element:SetScript("OnHide", nil)
		element:SetScript("OnShow", nil)
		element:SetScript("OnUpdate", nil)

		self:UnregisterEvent("UNIT_COMBAT", Path)
	end
end

oUF:AddElement("FloatingCombatFeedback", Path, Enable, Disable)
