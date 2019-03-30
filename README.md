# oUF: FloatingCombatFeedback

oUF: FloatingCombatFeedback is a plug-in for oUF framework.

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
    fcf[i] = fcf:CreateFontString("$parentFCFText" .. i, "OVERLAY", "CombatTextFont")
end

self.FloatingCombatFeedback = fcf
```

**Note:** If you create your own font object, I **strongly recommend** to use **big font sizes**, e.g. CombatTextFont's size is 64px.

## Options

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

**Note:** This only applies to events, if flag's animation is set to `false`, its event's animation will be used instead.

### Colours

```Lua
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
```

You can change these colours:

```Lua
self.FloatingCombatFeedback.colors["INTERRUPT"] = {r = 0.6, g = 0.6, b = 0.6}
self.FloatingCombatFeedback.schoolColors[SCHOOL_MASK_ARCANE] = {r = 0, g = 1, b = 1}
```

**Note:** `SCHOOL_MASK_*` are global variables and not strings.

### Text Size

By default, the font strings' height is set to 18px, which can be overridden:

```Lua
self.FloatingCombatFeedback.fontHeight = 24
```

However, various event flags use multipliers to adjust the height:

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

### Other

Please, consult the plugin's code to see what other options are available to you.

## Feedback and Feature Requests

If you found a bug or want to share an idea on how to improve my addon, either use the issue tracker on [GitHub](https://github.com/ls-/oUF_FloatingCombatFeedback/issues), or post a comment on [WoWInterface](https://www.wowinterface.com/downloads/info22674.html#comments).
