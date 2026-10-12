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
- **The light palette is retained but unused.** The old file defined a light override table and
  left the reference to it commented out, with a `TODO: fix colors`. That table is preserved as
  `embark_light` so the work is not lost, and the reference is still commented out, so the light
  flavour runs on stock Catppuccin exactly as before. It is the one remaining LuaLS hint in the
  tree, and hints do not fail the check.
- **Palette values shift by one in the blue channel.** `#1E1C31` resolves to `#1E1C32`. This is
  Catppuccin's own palette processing, not the port: `require("catppuccin.palettes").get_palette(
  "mocha")` reports the shifted values itself. The old configuration fed in the same hex values, so
  the result is identical.
- **One dead local was dropped.** The old `custom_highlights` defined an `accent_color` that
  nothing used. It was removed; the palette it referenced is unchanged.

## Deferred

- **The `<leader>C` colorscheme picker** needs a fuzzy finder, which arrives in Phase 3. The old
  mapping used Telescope and also depended on `which-key`, which Phase 1 removed.
- **UI integrations** for statusline, tabline, winbar, and file tree take effect once those plugins
  arrive in Phase 6. The integration flags and custom highlight groups for them are already in
  place, so they will apply without further changes.
