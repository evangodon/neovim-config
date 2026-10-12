# Agent Notes

## Comments

- Keep a comment to one line at most.
- Never write a multi-line prose comment block.
- Comment the reason, not the mechanics. If a line restates the code, delete it.

### Exception: LuaLS annotations

`---@param`, `---@return`, `---@class`, `---@type`, and `---@field` are annotations, not prose
comments. They are required by the type-safety rule in `REBUILD_PLAN_2027/plan.md` and are exempt
from the one-line limit, since a function with several parameters needs several of them.

Keep the annotation block itself tight. One annotation per parameter, no extra prose between them.

## Layout

- `REBUILD_PLAN_2027/plan.md` holds the requirements, architecture rules, and phase list. Read it
  before making structural decisions.
- `REBUILD_PLAN_2027/phase_*.md` are per-phase logs of what was done, verified, and deferred.
- `REBUILD_PLAN_2027/current_state.md` is the audit of the old configuration, with a migration
  status per plugin.
- `lua/config/` is editor configuration, `lua/util/` is reusable helpers, `lua/features/` is our own
  behaviour with an explicit `setup()`, and `lua/plugins/` holds plugin specifications.

## Before calling work complete

```sh
.crush/skills/validating-neovim-commands/scripts/validate.sh
```

All checks must pass, including LuaLS at zero problems. Do not silence a diagnostic by weakening
code or annotations; see the validation skill for the two accepted suppressions.
