#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Clone tmux Plugin Manager (TPM) for first-time tmux setup.
# Plugins themselves are installed inside tmux with `prefix + I`.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [[ -d "$TPM_DIR/.git" ]]; then
  echo "✓ TPM already cloned at $TPM_DIR"
  exit 0
fi

mkdir -p "$(dirname "$TPM_DIR")"
git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
echo "→ TPM cloned. Open tmux and press 'prefix + I' to install plugins."
