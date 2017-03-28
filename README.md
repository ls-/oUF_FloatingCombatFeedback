## oUF: FloatingCombatFeedback
oUF: FloatingCombatFeedback is a plug-in for oUF framework, and provides floating combat feedback support for oUF-based layouts.

## Download
- [WoWInterface](http://www.wowinterface.com/downloads/info22674-oUFFloatingCombatFeedback.html)

## Features
- Two scrolling modes: fountain and vertical;
- Two scrolling directions: upwards and downwards.

## Usage
To use this plug-in you have to create two things:
- This frames is the main widget, it'll also be used as the anchor for and the table of feedback FontStrings:
```Lua
local fcf = CreateFrame("Frame", nil, self)
fcf:SetSize(32, 32)
fcf:SetPoint("CENTER")
```
- You can create as many feedback FontStrings as you want, but I recommend to create only 4-8 of them:
```Lua
for i = 1, 6 do
	fcf[i] = fcf:CreateFontString(nil, "OVERLAY", "CombatTextFont")
end
```
- Register with oUF:
```Lua
self.FloatingCombatFeedback = fcf
```
**Note:** If you create your own font object, I **strongly recommend** to use **big font sizes**, e.g. CombatTextFont's size is 64px.

## Options
### Scrolling mode
By default, vertical scrolling mode is used:
```Lua
self.FloatingCombatFeedback.mode = "Fountain" -- will switch FCF to fountain mode
```

### Vertical scrolling direction
By default, text scrolls upwards:
```Lua
self.FloatingCombatFeedback.yDirection = -1 -- will make text scroll downwards
```

### Starting point offsets
Feedback text spawns symmetrically at two points that are offset from FCF frame's centre point. Default offsets: `x = 6`, `y = 8` in fountain mode, and `x = 30`, `y = 8` in vertical mode:
```Lua
self.FloatingCombatFeedback.xOffset = 60
self.FloatingCombatFeedback.yOffset = 16
```

### Scrolling time
By default, it takes 1.5s for a text to scroll and fadeout:
```Lua
self.FloatingCombatFeedback.scrollTime = 3 -- will make text float for 3 seconds
```

### Font height
By default, font strings are scaled down to 18px height, critical hit text height is multiplied by 1.25:
```Lua
self.FloatingCombatFeedback.fontHeight = 24
```

### Number abbreviation
By default, damage/healing numbers aren't abbreviated:
```Lua
self.FloatingCombatFeedback.abbreviateNumbers = true -- will abbreviate numbers
```

### Text colours
Default colours may be overridden:
```Lua
-- Default colour table:
-- local colors = {
-- 	ABSORB    = {r = 1.00, g = 1.00, b = 1.00},
-- 	BLOCK     = {r = 1.00, g = 1.00, b = 1.00},
-- 	DEFLECT   = {r = 1.00, g = 1.00, b = 1.00},
-- 	DODGE     = {r = 1.00, g = 1.00, b = 1.00},
-- 	ENERGIZE  = {r = 0.41, g = 0.80, b = 0.94},
-- 	EVADE     = {r = 1.00, g = 1.00, b = 1.00},
-- 	HEAL      = {r = 0.10, g = 0.80, b = 0.10},
-- 	IMMUNE    = {r = 1.00, g = 1.00, b = 1.00},
-- 	INTERRUPT = {r = 1.00, g = 1.00, b = 1.00},
-- 	MISS      = {r = 1.00, g = 1.00, b = 1.00},
-- 	PARRY     = {r = 1.00, g = 1.00, b = 1.00},
-- 	REFLECT   = {r = 1.00, g = 1.00, b = 1.00},
-- 	RESIST    = {r = 1.00, g = 1.00, b = 1.00},
-- 	WOUND     = {r = 0.70, g = 0.10, b = 0.10},
-- }

-- will override miss event colour:
self.FloatingCombatFeedback.colors = {
	["MISS"] = {r = 1, g = 0, b = 1},
}
```
Additionally you can override colours that are used for incoming damage text:
```Lua
-- Default school colour table:
-- local schoolColors = {
-- 	[SCHOOL_MASK_NONE]     = {r = 1.00, g = 1.00, b = 1.00},
-- 	[SCHOOL_MASK_PHYSICAL] = {r = 0.70, g = 0.10, b = 0.10},
-- 	[SCHOOL_MASK_HOLY]     = {r = 1.00, g = 0.90, b = 0.50},
-- 	[SCHOOL_MASK_FIRE]     = {r = 1.00, g = 0.50, b = 0.00},
-- 	[SCHOOL_MASK_NATURE]   = {r = 0.30, g = 1.00, b = 0.30},
-- 	[SCHOOL_MASK_FROST]    = {r = 0.50, g = 1.00, b = 1.00},
-- 	[SCHOOL_MASK_SHADOW]   = {r = 0.50, g = 0.50, b = 1.00},
-- 	[SCHOOL_MASK_ARCANE]   = {r = 1.00, g = 0.50, b = 1.00},
-- }

-- will override arcane school colour:
self.FloatingCombatFeedback.schoolColors = {
	[SCHOOL_MASK_ARCANE] = {r = 0, g = 1, b = 1},
}
```
**Note:** `SCHOOL_MASK_*` are global variables and not strings.

### Event blacklisting
```Lua
self.FloatingCombatFeedback.ignoreDamage = true -- will ignore damage events
self.FloatingCombatFeedback.ignoreEnergize = true -- will ignore energize events
self.FloatingCombatFeedback.ignoreHeal = true -- will ignore heals events
self.FloatingCombatFeedback.ignoreMisc = true  -- will ignore miss, block, parry and other events
```

## Feedback and Feature Requests
If you found a bug or want to share an idea on how to improve my addon, either report to [Issue Tracker](https://github.com/ls-/oUF_FloatingCombatFeedback/issues) on my GitHub page, or post a comment on [WoWInterfrace](http://www.wowinterface.com/downloads/info22674-oUFFloatingCombatFeedback.html#comments).

## Credits
This plug-in is based on Blizzard combat feedback and floating combat text code.
