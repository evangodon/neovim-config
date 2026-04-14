---
name: building-neovim-ingest-context
description: Builds a single ingest artifact containing the relevant Lua-based Neovim config for AI review. Use when preparing this repo for AI handoff, refreshing the config snapshot, or generating a compact single-file prompt from the active Neovim config.
---

# Building Neovim Ingest Context

## Quick start

Run:

- `./.crush/skills/building-neovim-ingest-context/scripts/build_context.sh`

This writes:

- `./.crush/artifacts/neovim-lua-config.md`

## Included files

The ingest bundle should include only Lua files that directly define this Neovim config:

- `init.lua`
- `vscode.lua`
- `ftdetect/**/*.lua`
- `lua/**/*.lua`
- `after/**/*.lua` when present

## Excluded by design

Do not include files that are not part of the active Lua config handoff:

- `lazy-lock.json`
- `lua-guide.md`
- `.notes/**`
- `.crush/**`
- `spell/**`
- `obsidian.vimrc`
- `save.sh`
- other non-Lua files

## Workflow

1. Run the script from the repo root.
2. Confirm `./.crush/artifacts/neovim-lua-config.md` was updated.
3. Hand the generated file to the AI instead of the whole repo.
4. If the AI needs current Neovim docs, use the local `fetching-neovim-docs` skill to fetch official docs on demand.

## Rules

- Prefer explicit include patterns over broad repo ingestion.
- Keep the scope limited to files that affect runtime Neovim behavior.
- Do not ingest notes, lockfiles, generated artifacts, or skill files.
- Regenerate the artifact after config changes before sharing it with an AI.
- Preserve relative paths and line numbers so the AI can cite locations precisely.

## Script behavior

The script uses `ingest` with:

- `--no-clipboard`
- `--line-number`
- `--relative-paths`
- `--output ./.crush/artifacts/neovim-lua-config.md`
- explicit Lua include patterns only

If the config later grows additional Lua entry points outside these paths, update the script deliberately instead of broadening ingestion to the entire repo.
