---
name: validating-neovim-commands
description: Ensures headless Neovim validation commands exit cleanly. Use when running Neovim headless to test this configuration.
---

# Validating Neovim Commands

Always terminate headless Neovim explicitly, including after delayed checks:

```sh
nvim --headless '+sleep 2' '+lua <check>' '+qa!'
```

Use `+qa!` as the final argument. Do not rely on callbacks to quit Neovim. If a check can fail, wrap it so `+qa!` still runs.
