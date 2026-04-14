#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../" && pwd)"
output_path="$repo_root/.crush/artifacts/neovim-lua-config.md"

ingest_bin="${INGEST_BIN:-$(command -v ingest || true)}"

if [[ -z "$ingest_bin" ]]; then
  echo "ingest not found in PATH. Set INGEST_BIN or install ingest." >&2
  exit 1
fi

mkdir -p "$(dirname "$output_path")"

"$ingest_bin" \
  --no-clipboard \
  --line-number \
  --relative-paths \
  --output "$output_path" \
  --exclude ".crush/**" \
  --exclude ".notes/**" \
  --exclude "lazy-lock.json" \
  --exclude "lua-guide.md" \
  --exclude "obsidian.vimrc" \
  --exclude "save.sh" \
  --exclude "spell/**" \
  --include "init.lua" \
  --include "vscode.lua" \
  --include "ftdetect/**/*.lua" \
  --include "lua/**/*.lua" \
  --include "after/**/*.lua" \
  "$repo_root"

echo "Wrote $output_path"
