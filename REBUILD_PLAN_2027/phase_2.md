# Phase 2: Theme & Visual Base

## Status

Complete. The theme applies at startup and all automated checks pass.

## Decisions taken

| Question | Decision |
|---|---|
| Which theme | Catppuccin, as today |
| Light and dark switching | Keep the clock-based rule, fixing the environment edge case |
| Custom palette | Port as-is, preserving the current look |

## What was built

`lua/plugins/colorscheme.lua` now holds the whole theme concern:

- The `catppuccin/nvim` specification, with `lazy = false` and `priority = 1000` so the theme
  loads at startup, as the plan requires.
- The custom Embark-derived dark palette, the inactive-window dimming, the integrations, and the
  full `custom_highlights` set, all ported from the old `catppuccin.lua`.
- Clock-based flavour selection, with `NVIM_USE_DARK_THEME` as an override.
- `FloatBorder` matched to the `NormalFloat` background, plus a `ColorScheme` autocommand that
  re-applies it.

The old configuration spread theming across four files and applied it from `user/colorscheme.lua`.
All of it now lives in one plugin file, which is where the plan said it belongs.

## Verification

The flavour cannot be checked headlessly alone, because it depends on the clock, so every path was
exercised directly.

| Scenario | Result |
|---|---|
| No override, hour 10 | `catppuccin-latte`, `background=light` |
| `NVIM_USE_DARK_THEME=true` | `catppuccin-mocha`, `background=dark` |
| `NVIM_USE_DARK_THEME=false` | `catppuccin-latte`, `background=light` |
| `NVIM_USE_DARK_THEME=yes` | Warns, then falls back to the clock |
| Manual `:colorscheme` switch | `FloatBorder` still matches `NormalFloat` |
| Dark palette applied | `Normal` resolves to the custom base and text, not stock Catppuccin |

The full validation script also passes, including the LuaLS check at zero problems:

```text
== headless startup ==
ok:   headless startup

== startup messages ==
ok:   no startup errors

== missing dependencies ==
ok:   startup with restricted PATH

== Lua syntax ==
ok:   luajit syntax check

== formatting ==
ok:   stylua format check

== LuaLS diagnostics ==
ok:   lua-language-server diagnostics

All executed checks passed.
```

`lazy-lock.json` was generated and pins `catppuccin` and `lazy.nvim`.

## Findings resolved

1. **`embark-theme/vim` was unused.** Confirmed: the switcher never selected it. Marked `deleted`
   in `current_state.md` and not ported.
2. **The Nightfox flavours were unreachable.** Both light and dark resolved to Catppuccin, so
   `dayfox`, `dawnfox`, `duskfox`, `nightfox`, and `carbonfox` could only be reached by hand.
   Marked `deleted` and not ported.
3. **The environment override no longer fails silently.** The old lookup mapped `"true"` and
   `"false"` and turned everything else into the light theme, because `not nil` is `true`. Anything
   unrecognised is now reported and ignored, leaving the clock rule in charge.
4. **Time-based switching is still evaluated once.** Kept deliberately, matching the old behavior.
   A session open across the boundary keeps its original flavour.

## Notes

- **`vim.o.background` is now set for both flavours.** The old code only set it for light. Setting
  it explicitly is more correct for plugins that read `background`, and it matches the flavour in
  use.
- **The light palette is derived, not original.** See the section below.
- **Palette values shift by one in the blue channel.** `#1E1C31` resolves to `#1E1C32`. This is
  Catppuccin's own palette processing, not the port: `require("catppuccin.palettes").get_palette(
  "mocha")` reports the shifted values itself. The old configuration fed in the same hex values, so
  the result is identical.
- **One dead local was dropped.** The old `custom_highlights` defined an `accent_color` that
  nothing used. It was removed; the palette it referenced is unchanged.

## Light palette rework

The old configuration defined a light override table but left it disabled, with a `TODO: fix
colors`. Enabling it as-is produced unreadable output, so the values were re-derived.

### The problem was structural

The old overrides were Embark's dark palette reused on a light background. Measured with
`scripts/contrast_checker.lua`, **14 of 20 foregrounds failed the 3.0 WCAG graphics threshold**, with
green at 1.36, yellow at 1.14, and teal at 1.12. Those pastels are tuned to glow against `#1E1C32`;
against `#f4f7fc` they have no separation.

For reference, stock Catppuccin Latte fails 11 of 20 at 3.0, including yellow at 2.31 and green at
2.96. So the bar is not "pass 3.0", it is "at least as readable as a proven light theme".

### Two ordering bugs were also present

- `crust` was the **lightest** neutral rather than the darkest, so chrome meant to recede from the
  background instead sat above it.
- `surface0/1/2` ran **dark to light** instead of light to dark, so low surface numbers were the
  loudest thing on screen.
- `subtext1/subtext0` were lighter than `overlay2`, inverting Catppuccin's text hierarchy.

### What was done

- **Neutrals reversed** so the ramp runs light to dark: `base > mantle > crust > surface0 > surface1
  > surface2`, and `text > subtext1 > subtext0 > overlay2 > overlay1 > overlay0`. Verified
  monotonic by relative luminance. The six Embark neutral hues were reassigned rather than replaced,
  since there are exactly six and all six were already in use.
- **Accents darkened** by holding hue and saturation and reducing lightness until a target ratio was
  met. Targets were assigned by prominence rank across a 3.0 to 5.0 range rather than pinned at 3.0.
  Two reasons: a flat target flattens the lightness hierarchy so every accent carries equal weight,
  and it makes `teal` and `sky` collapse to the same hex, because their hues are 180 degrees and 179
  degrees and they only stay distinct while their lightness differs.

### Result

| | Before | After |
|---|---|---|
| Latte foregrounds below 3.0 | 14 of 20 | 2 of 20 |

The two remaining are `overlay0` and `overlay1`, the deliberately weakest de-emphasis levels, which
stock Latte also leaves below the threshold.

The dark palette was not touched.

### Contrast checker

`scripts/contrast_checker.lua` reports WCAG ratios for the resolved palette, per flavour. It reads
through `require("catppuccin.palettes")` so it measures the colours that actually render, including
overrides, rather than a copy. Backgrounds are reported separately from foregrounds, because a
background compared against the background is always near 1.0.

```sh
NVIM_APPNAME=nvim-2027 bob run nightly --headless \
  "+lua dofile(vim.fn.stdpath('config') .. '/scripts/contrast_checker.lua')" '+qa!'
```

It cannot run through `nvim -l`, because that does not load the configuration and so cannot resolve
the palette.

## Deferred

- **The `<leader>C` colorscheme picker** needs a fuzzy finder, which arrives in Phase 3. The old
  mapping used Telescope and also depended on `which-key`, which Phase 1 removed.
- **UI integrations** for statusline, tabline, winbar, and file tree take effect once those plugins
  arrive in Phase 6. The integration flags and custom highlight groups for them are already in
  place, so they will apply without further changes.
