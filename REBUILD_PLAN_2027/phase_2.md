# Phase 2: Theme & Visual Base

## Status

Not started.

## Goal

Make the editor visually usable before configuring complex tools, so later phases can be reviewed
against a real theme.

From `plan.md`:

- Pick a modern dark theme, for example TokyoNight, Catppuccin, or Rose Pine.
- Load the theme plugin with `priority = 1000` so it renders immediately on startup.

## Where the work goes

| File | Purpose |
|---|---|
| `lua/plugins/colorscheme.lua` | Plugin specification and theme configuration, currently an empty placeholder |
| `lua/util/colors.lua` | Existing helper for reading highlight group colors, already ported in Phase 1B |

Theme switching logic belongs in `lua/plugins/colorscheme.lua` rather than a new config module,
because it depends on the theme plugin being loaded.

## What exists today

The old configuration spreads theming across four files.

### `lua/user/colorscheme.lua`, assigned to this phase

- Chooses light or dark at startup from the hour of the day: `hour < 20 and hour > 6`, so light
  between 07:00 and 19:59.
- Allows an override through the `NVIM_USE_DARK_THEME` environment variable.
- Uses `catppuccin-latte` for light and `catppuccin-mocha` for dark.
- Sets `vim.g.background = "light"` for the light theme.
- Applies the theme through `pcall(vim.cmd.colorscheme, ...)` and notifies if it is missing.
- Matches `FloatBorder` background to `NormalFloat`, and re-applies it on the `ColorScheme` event.
- Maps `<leader>C` to `:Telescope colorscheme`.

This module cannot be ported as-is:

- It uses `which-key`, which Phase 1 removed.
- `<leader>C` depends on Telescope, which arrives in Phase 3.
- It reads `user.functions.utils.get_color`, replaced by `util.colors.get`.

### Plugin files, one per theme

| Plugin | Notes |
|---|---|
| `catppuccin/nvim` | Primary theme. Carries a large custom Embark-inspired palette, inactive-window dimming, and integrations for NvimTree, Gitsigns, Notify, Treesitter, completion, tabline, winbar, Grapple, and Markdown rendering |
| `EdenEast/nightfox.nvim` | Compiles a custom Dayfox palette and defines Telescope, diff, split, and tabline highlights |
| `embark-theme/vim` | Installed, but the theme switcher never selects it |

## Findings to resolve during this phase

These came out of reading the old code. They are recorded here rather than fixed, because each one
is a decision.

1. **`embark-theme/vim` looks unused.** The switcher's theme table lists only Catppuccin and
   Nightfox variants, so Embark is never applied. Confirm and then mark it `deleted` in
   `current_state.md`.
2. **The Nightfox entries in the theme table are unreachable.** `LIGHT_THEME` and `DARK_THEME` are
   both Catppuccin, so `dayfox`, `dawnfox`, `duskfox`, `nightfox`, and `carbonfox` can only be
   reached by running `:colorscheme` by hand. Decide whether to keep them as manual options or drop
   the plugin.
3. **The environment override has an edge case.** `NVIM_USE_DARK_THEME` is parsed through a
   `{ ["true"] = true, ["false"] = false }` lookup. Any other value yields `nil`, and `not nil` is
   `true`, which forces the light theme. An unexpected value should either be ignored or rejected
   loudly, not silently switch themes.
4. **Time-based switching is evaluated once.** The choice is made at startup and never revisited,
   so a session open across the boundary keeps its original theme. Decide whether that is intended.
5. **Three themes are a lot to carry.** If only one is actually used, keeping the others costs a
   plugin, a lockfile entry, and palette maintenance for no benefit.

## Decisions needed

| Question | Why it matters |
|---|---|
| Which theme, or themes, to keep? | Determines whether one or three theme plugins are installed |
| Keep automatic light and dark switching, or set one theme? | Determines whether the switcher logic and the environment override are ported at all |
| If switching is kept, keep the clock-based rule or switch to something explicit? | The clock rule is invisible and hard to predict |
| Port the custom Catppuccin palette, or start from stock? | The old palette is roughly 170 lines of overrides tuned to Embark colors |

## Planned work

1. Add the chosen theme plugin to `lua/plugins/colorscheme.lua` with `priority = 1000`.
2. Apply the theme at startup, tolerating a missing plugin rather than crashing.
3. Port the `FloatBorder` handling, using `util.colors.get`.
4. Port the `ColorScheme` autocommand that re-applies the float border.
5. Reimplement light and dark selection if that decision is kept, without `which-key`.
6. Add a colorscheme picker mapping once Phase 3 provides a fuzzy finder, or drop the mapping.
7. Update `current_state.md` for each theme plugin: `migrated` or `deleted`.

## Validation

The usual script:

```sh
.crush/skills/validating-neovim-commands/scripts/validate.sh
```

This phase has one extra risk worth testing directly: a theme failure is the most visible way to
break startup, so the missing-plugin path must be exercised rather than assumed. Phase 1B showed
that LuaLS catches problems `luajit` cannot, so the type check must stay at zero problems.

A theme is also the first thing that cannot be verified headlessly. Confirming it actually renders
requires opening `nvim2027` and looking at it.

## Deferred to later phases

- The colorscheme picker mapping, which needs the fuzzy finder from Phase 3.
- Statusline, tabline, winbar, and other UI integration once those plugins arrive in Phase 6.
