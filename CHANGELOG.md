# CHANGELOG

## Version 4.2.0

- Added optional colouring by school for non-WOUND events. See the `.tryToColorBySchool` table for more info;
- Added `SPELL_INTERRUPT` support to CLEU mode. TY Rav99@GitHub for the idea and base implementation.

## Version 4.1.0

- Added `COMBAT_LOG_EVENT_UNFILTERED` support. See [Options > Modes](https://github.com/ls-/oUF_FloatingCombatFeedback/tree/dev#modes);
- Added colours for known multi-schools. See [Options > Colours](https://github.com/ls-/oUF_FloatingCombatFeedback/tree/dev#colours);
- Reworked the way the font is handled. There's no need to use FontObject templates anymore, they  
  are optional now, to set the font and its flags use `.font` and `.fontFlags` options. See  
  [Options > Text](https://github.com/ls-/oUF_FloatingCombatFeedback/tree/dev#text).

## Version 4.0.0

- Rewrote the entire plugin. Readopted semver because using INTERFACE_VERSION  
  for a plugin that's so rarely updated isn't a good choice;  
- Numerous new options. It's way more configurable now. Please, see the README  
  on GitHub or just read the code.

## Version 70200.02

- Made sure that it's possible to update all options on the fly.

## Version 70200.01

- New version format: INTERFACE_VERSION.PATCH;
- Added 7.2 support;
- Added `.schoolColors` option to override school colours;
- Refactored and optimised code.

## Version 2.02

- Fixed text blinking issue;
- Tweaked standard vertical scrolling.

## Version 2.01

- Widget revamp;
- Damage text is now coloured according to damage type/school;
- Added an option to abbreviate numbers.
