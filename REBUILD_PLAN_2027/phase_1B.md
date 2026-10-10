# Phase 1B: Utility Layer & Module Port

## Status

Complete. The utility layer and the dependency-free feature modules are ported, and all automated
checks pass.

## Completed

### Utility layer

Created `lua/util/` with explicit, dependency-free modules:

- `notify.lua` replaces the global `Notify` table and the `P` helper. It prefers `Snacks.notify`
  when the snacks plugin is reachable, and falls back to `vim.notify`. This keeps the plugin
  dependency in one module instead of spreading it through every caller.
- `buffer.lua` replaces the global `Get_loaded_buffers` and `close_all_buffers_but_current`.
- `string.lua` holds superscript conversion and truncation.
- `colors.lua` replaces `get_color`.
- `icons.lua` replaces `user.icons`, minus the unused global `Icon` table.
- `floating_window.lua` ports the floating CLI output window.

### Feature modules

Created `lua/features/` for our own non-plugin features:

- `marks.lua` ports the custom mark API. Autocommand registration moved into `M.setup()`.
- `scope_buffers.lua` ports tab-scoped buffer listing. `M.setup()` is now called explicitly.
- `chezmoi.lua` ports the chezmoi integration and was rewritten. Shell command strings were
  replaced with `vim.system()` argument lists, and the feature was restructured after review.

### Wiring

- `init.lua` calls `setup()` on the three feature modules before loading the plugin manager.
- `<leader>B` (close all buffers but current) is restored in `lua/config/keymaps.lua`, now backed by
  `util/buffer.lua`.

### Deleted, not ported

- `user/functions/init.lua` existed only to define globals as a `require` side effect.
- `user/work.lua` was excluded by request.
- `strip_ansi_codes` lost its only caller when `work.lua` was dropped.
- The unused global `Icon` table in `icons.lua`.

## Chezmoi rewrite

The ported file worked but had a verified bug and two design problems, so it was rewritten. The
destination behavior was then changed again, from warning to syncing.

### Direction of sync

`chezmoi apply` runs source to target, so running it after saving a destination file would discard
the edit. Since the destination file is the one being edited day to day, writes are routed by
direction instead:

| File written | Command | Direction |
|---|---|---|
| Destination (`~/.config/starship.toml`) | `chezmoi re-add <target>` | target to source |
| Source (`.../chezmoi/dot_config/starship.toml`) | `chezmoi apply --force --source-path <source>` | source to target |

`re-add` refuses to overwrite templates. Verified: `chezmoi re-add --dry-run` shows a diff for
`~/.config/starship.toml` and produces no output for the templated `~/.gitconfig`. Templated
destinations therefore warn once per session with the source path, so the edit is not silently lost
on the next apply.

Both commands run on `BufWritePost`, because both read the file from disk.

### Bug: apply failures were invisible

The failure guard called `chezmoi source-path` with a **source** path. Verified against chezmoi
v2.62.4:

| Input | Exit | Stdout |
|---|---|---|
| `chezmoi source-path <managed target>` | 0 | the source path |
| `chezmoi source-path <source path>` | 1 | empty, `not managed` |

The guard was always false, so the error notification never ran. This bug was inherited from the
original configuration. Failures are now reported from the command exit code, using chezmoi's own
error text.

### Design: the warning fired too late

The original warned on `VimLeave`, which fires after the user has already quit, and
`vim.fn.expand "%:p"` resolved only the current buffer, so editing several managed files reported
at most one of them.

### Performance: blocking on every save

`chezmoi apply` ran synchronously with `:wait()`, blocking the UI thread. Commands are now
asynchronous and serialized through a single queue, so rapid saves never run concurrent chezmoi
processes.

### Also changed

- The managed-file set and source directory are fetched once at startup and answered from memory.
  The old code spawned a subprocess per check.
- Source paths are resolved once per target and cached, so only the first save of a file pays for
  the lookup.
- `managed_patterns`, which hardcoded file extensions, is gone. Chezmoi already knows what it
  manages.
- The source directory is detected instead of relying on a glob that happened to match because the
  directory is named `chezmoi`.
- `apply --force --source-path <path>` is unchanged and correct: `--source-path` is a boolean flag
  meaning "treat targets as source paths", not a path argument.

### Chezmoi verification

All routing was verified headlessly by stubbing `vim.system` and asserting the exact commands:

| Scenario | Commands issued |
|---|---|
| Source file written | `chezmoi apply --force --source-path <source>` |
| Unmanaged file written | none |
| Destination written, first time | `chezmoi source-path <target>`, then `chezmoi re-add <target>` |
| Destination written again | `chezmoi re-add <target>` only, source path is cached |
| Templated destination written | `chezmoi source-path <target>` only, plus one warning naming the source |
| Templated destination written again | no command, no duplicate warning |
| Failing command | chezmoi's stderr is reported instead of staying silent |
| Two writes during an in-flight command | one command, then a second after the first finishes |

Confirmed interactively with a real save: editing a managed destination and writing it updated both
the destination and the source file.

Note: `~/.config/nvim` is not chezmoi-managed, so this feature only applies to other managed files.

### Diagnosing a write that did not sync

`:ChezmoiStatus` reports the state of the integration:

```text
{
  busy = false,
  cached_source_paths = 0,
  current_is_managed_target = true,
  current_is_source_file = false,
  executable = true,
  managed_targets = 271,
  queued = "(none)",
  source_dir = "/Users/evan.godon/.local/share/chezmoi"
}
```

`managed_targets = 0` means the startup lookup has not finished or failed, so no write will be
routed. A missing command means the session loaded an older version of the module. Neovim caches
required modules for the life of the process, so a session started before a change to this file
keeps the old behavior until it is restarted. This is worth remembering when testing config
changes, and it was the cause of the first failed manual test.


Three changes deliberately differ from the old configuration. Each one was verified.

| Change | Old behavior | New behavior | Reason |
|---|---|---|---|
| `util/buffer.close_all_but_current` | `nvim_buf_delete` failed loudly with `E89` on a modified buffer | Modified buffers are detected first, kept, and reported in one warning | Avoids the `E89` error noise and handles the `TODO` the old code left behind |
| `features/scope_buffers` tab leave | Set `buflisted = true`, which made the feature a no-op | Sets `buflisted = false` so buffers are scoped to their tab | Verified: leaving a tab unlists its buffers, returning relists them |
| `util/floating_window` | Set `nomodifiable` on the terminal buffer | Left modifiable | The old setting prevented typing into the terminal it opened |

`util/string.truncate` also fixes a crash. The old `truncate_string` called `str.sub(str, 1, max)`,
but strings have no `.sub` field, so any call with a long string raised an error.

## Validation

```sh
.crush/skills/validating-neovim-commands/scripts/validate.sh
```

Result:

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

## LuaLS verification

`lua-language-server` was installed and wired into the validation script. This closed the phase's
only outstanding gap, and it found four real problems that `luajit` could not see.

### Configuration

`.luarc.json` sets `runtime.version` to `LuaJIT`, adds `vim` and `Snacks` as known globals, and
points `workspace.library` at `$VIMRUNTIME/lua` so the Neovim API types resolve. The validation
script resolves `$VIMRUNTIME` from Neovim itself and exports it before checking. Without it, the
report contains 161 problems that are almost all `Undefined global vim`, which is noise.

### Problems found and fixed

| Problem | Kind | Resolution |
|---|---|---|
| `keymap_popup.lua` annotated the keymap parameter as `vim.keymap.set.Opts` | Real annotation defect | Corrected to `vim.api.keyset.get_keymap`, the type returned by `nvim_get_keymap` |
| `autocmds.lua` used `vim.hl.on_yank` | Deprecated since 0.14 | Replaced with `vim.hl.hl_op`, which `on_yank` merely forwarded to |
| `floating_window.lua` used `vim.fn.termopen` | Deprecated | Replaced with `vim.fn.jobstart` and `term = true` |
| `options.lua` reported `assign-type-mismatch` on every option | False positive | File-scoped suppression with an explanatory comment |
| `keymaps.lua` option toggle | False positive | Single-line suppression |
| `marks.lua` used `vim.fn.getmarklist "%"` | False positive | Single-line suppression |

The `getmarklist` case was verified before suppressing. The generated type only accepts an integer,
but `getmarklist(0)` returns an empty list while `getmarklist("%")` returns the current buffer's
local marks, so the string form is correct and the type definition is too narrow.

Both deprecation fixes were verified functionally: yanking raises no error, and the floating window
opens a `terminal` buffer containing the command output.

### Before and after

| Stage | Problems |
|---|---|
| No `.luarc.json` | 161, almost all `Undefined global vim` |
| `.luarc.json` with `$VIMRUNTIME` | 36 |
| All fixes applied | 0 |


Functional checks run headlessly:

- `util.notify` falls back to `vim.notify` when snacks is not loaded, and reports no errors.
- `util.string.truncate("abcdefghij", 4)` returns `abcd…` instead of raising.
- `util.colors.get("Normal", "bg#")` returns a color.
- `util.buffer.close_all_but_current` closes unmodified buffers, keeps modified ones, and emits a
  single warning naming them.
- `features.marks` places an extmark sign on the marked line.
- `features.scope_buffers` unlists a tab's buffers on leave and relists them on return.

## Deferred

Still deferred to their feature phases:

- `functions/commands.lua` and `functions/kitty.lua`, which need `presenterm`, `zk`, and Kitty.
- `ai.lua` and `colorscheme.lua`, which must be rewritten without `which-key`.
- `env.lua`, which belongs with the knowledge-base picker.
- `util/floating_window.lua` is ported and kept deliberately. Its only caller was the deleted
  `work.lua`, so it has no caller in the new tree yet, but the behavior is still used and the
  helper must not be deleted during cleanup. It needs a caller when that feature is ported.
