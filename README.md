# oUF: FloatingCombatFeedback

oUF: FloatingCombatFeedback is a plugin for oUF framework.

## Download

- [WoWInterface](http://www.wowinterface.com/downloads/info22674.html)

## Usage

To use this plugin you need to create a frame and a set of font strings, and then register the frame with oUF:

```Lua
local fcf = CreateFrame("Frame", nil, self)
fcf:SetSize(32, 32)
fcf:SetPoint("CENTER")

for i = 1, 6 do
    -- give names to these font strings to avoid breaking /fstack and /tinspect
    fcf[i] = fcf:CreateFontString("$parentFCFText" .. i, "OVERLAY")
end

self.FloatingCombatFeedback = fcf
```

## Options

### Modes

The plugin can use either `UNIT_COMBAT` or `COMBAT_LOG_EVENT_UNFILTERED` to run the update. While `CLEU` fires A LOT more often than `UC`, using it allows to filter combat events by their source, the player and his/her pets, and to add abilities' icons to the floating text, whereas using `UC` doesn't allow for any of that. Performance-wise, on average using `CLEU` instead of `UC` is slower by only 0.012ms, for comparison's sake, at 60fps 1 frame lasts for 16ms, so this performance hit is negligible.

To use `CLEU` set `.useCLEU` to `true` during the initial setup.

```Lua
self.FloatingCombatFeedback.useCLEU = true
```

However, if you need to enable/disable it later on, for instance, if your layout has an in-game config, use the `EnableCLEU` method:

```Lua
self.FloatingCombatFeedback:EnableCLEU(true|false)
```

### Animations

Out of the box, there's 6 animations to choose from:

- "diagonal"
- "fountain"
- "horizontal"
- "random"
- "static"
- "vertical"

However, you can also define additional animations types:

```Lua
self.FloatingCombatFeedback.animations["animName"] = function(self)
    -- Your animation code goes here
end
```

By default, all events use the `"fountain"` animation, and flags don't use any:

```Lua
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
    ["ABSORB"  ] = false,
    ["BLOCK"   ] = false,
    ["CRITICAL"] = false,
    ["CRUSHING"] = false,
    ["GLANCING"] = false,
    ["RESIST"  ] = false,
}
```

But you can always assign some other animation:

```Lua
self.FloatingCombatFeedback.animationsByEvent["WOUND"] = "vertical"
self.FloatingCombatFeedback.animationsByFlag["CRITICAL"] = "random"
```

You can also disable combat events:

```Lua
self.FloatingCombatFeedback.animationsByEvent["HEAL"] = false
```

**Note:** This only applies to events, if a flag's animation is set to `false`, its event's animation will be used instead.

### Colours

```Lua
local colors = {
    ["ABSORB"   ] = rgb(255, 255, 255),
    ["BLOCK"    ] = rgb(255, 255, 255),
    ["DEFLECT"  ] = rgb(255, 255, 255),
    ["DODGE"    ] = rgb(255, 255, 255),
    ["ENERGIZE" ] = rgb(105, 204, 240),
    ["EVADE"    ] = rgb(255, 255, 255),
    ["HEAL"     ] = rgb(26, 204, 26),
    ["IMMUNE"   ] = rgb(255, 255, 255),
    ["INTERRUPT"] = rgb(255, 255, 255),
    ["MISS"     ] = rgb(255, 255, 255),
    ["PARRY"    ] = rgb(255, 255, 255),
    ["REFLECT"  ] = rgb(255, 255, 255),
    ["RESIST"   ] = rgb(255, 255, 255),
    ["WOUND"    ] = rgb(179, 26, 26),
}

local schoolColors = {
    [SCHOOL_MASK_ARCANE     ] = rgb(255, 128, 255),
    [SCHOOL_MASK_FIRE       ] = rgb(255, 128, 000),
    [SCHOOL_MASK_FROST      ] = rgb(128, 255, 255),
    [SCHOOL_MASK_HOLY       ] = rgb(255, 230, 128),
    [SCHOOL_MASK_NATURE     ] = rgb(77, 255, 77),
    [SCHOOL_MASK_NONE       ] = rgb(255, 255, 255),
    [SCHOOL_MASK_PHYSICAL   ] = rgb(179, 26, 26),
    [SCHOOL_MASK_SHADOW     ] = rgb(128, 128, 255),
    -- multi-schools
    [SCHOOL_MASK_ASTRAL     ] = rgb(166, 192, 166),
    [SCHOOL_MASK_CHAOS      ] = rgb(182, 164, 142),
    [SCHOOL_MASK_ELEMENTAL  ] = rgb(153, 212, 111),
    [SCHOOL_MASK_MAGIC      ] = rgb(183, 187, 162),
    [SCHOOL_MASK_PLAGUE     ] = rgb(103, 192, 166),
    [SCHOOL_MASK_RADIANT    ] = rgb(255, 178, 64),
    [SCHOOL_MASK_SHADOWFLAME] = rgb(192, 128, 128),
    [SCHOOL_MASK_SHADOWFROST] = rgb(128, 192, 255),
}

local tryToColorBySchool = {
    ["ABSORB"   ] = false,
    ["BLOCK"    ] = false,
    ["DEFLECT"  ] = false,
    ["DODGE"    ] = false,
    ["ENERGIZE" ] = false,
    ["EVADE"    ] = false,
    ["HEAL"     ] = false,
    ["IMMUNE"   ] = false,
    ["INTERRUPT"] = false,
    ["MISS"     ] = false,
    ["PARRY"    ] = false,
    ["REFLECT"  ] = false,
    ["RESIST"   ] = false,
    ["WOUND"    ] = true,
}
```

**Note:** `rgb` is an internal helper-method:

```Lua
local function rgb(r, g, b)
    return {r = r / 255, g = g / 255, b = b /255}
end
```

You can change these colours:

```Lua
self.FloatingCombatFeedback.colors["INTERRUPT"] = {r = 0.6, g = 0.6, b = 0.6}
self.FloatingCombatFeedback.schoolColors[SCHOOL_MASK_ARCANE] = {r = 0, g = 1, b = 1}
```

`SCHOOL_MASK_*` are variables and not strings:

```Lua
-- Blizz's globals, can be used as is
SCHOOL_MASK_NONE = 0
SCHOOL_MASK_PHYSICAL = 1
SCHOOL_MASK_HOLY = 2
SCHOOL_MASK_FIRE = 4
SCHOOL_MASK_NATURE = 8
SCHOOL_MASK_FROST = 16
SCHOOL_MASK_SHADOW = 32
SCHOOL_MASK_ARCANE = 64

-- plugin's locals, use their values
SCHOOL_MASK_ASTRAL = 72
SCHOOL_MASK_CHAOS = 127
SCHOOL_MASK_ELEMENTAL = 28
SCHOOL_MASK_MAGIC = 126
SCHOOL_MASK_PLAGUE = 40
SCHOOL_MASK_RADIANT = 6
SCHOOL_MASK_SHADOWFLAME = 36
SCHOOL_MASK_SHADOWFROST = 48
```

### Text

The plugin will try to get info on the font and its flags, if it fails to do so, the font and its flags will be set to `"Fonts\\FRIZQT__.TTF"` and `""` respectively. By default, the height is set to `18`px.

All of these can be overridden:

```Lua
self.FloatingCombatFeedback.font = "Fonts\\MORPHEUS.ttf"
self.FloatingCombatFeedback.fontHeight = 24
self.FloatingCombatFeedback.fontFlags = "THINOUTLINE"
```

Various event flags use multipliers to adjust the height:

```Lua
local multipliersByFlag = {
    [""        ] = 1,
    ["ABSORB"  ] = 0.75,
    ["BLOCK"   ] = 0.75,
    ["CRITICAL"] = 1.25,
    ["CRUSHING"] = 1.25,
    ["GLANCING"] = 0.75,
    ["RESIST"  ] = 0.75,
}
```

But they can be adjusted, if needed:

```Lua
self.FloatingCombatFeedback.multipliersByFlag["CRITICAL"] = 1.5
```

If you're using `CLEU`, you might want to add an icon to your floating text:

```Lua
-- text followed by icon
self.FloatingCombatFeedback.format = "%1$s |T%2$s:0:0:0:0:64:64:4:60:4:60|t"

-- icon followed by text
self.FloatingCombatFeedback.format = "|T%2$s:0:0:0:0:64:64:4:60:4:60|t %1$s"
```

### Other

Please, consult the plugin's code to see what other options are available to you.

## Feedback and Feature Requests

If you found a bug or want to share an idea on how to improve my addon, either use the issue tracker on [GitHub](https://github.com/ls-/oUF_FloatingCombatFeedback/issues), or post a comment on [WoWInterface](https://www.wowinterface.com/downloads/info22674.html#comments).
