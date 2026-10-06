#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Create ~/.gitconfig.local with user identity (name + email).
# Pulled in by config/git/.gitconfig via [include].
# Idempotent: skips if file already has user.email set.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

LOCAL="$HOME/.gitconfig.local"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'
else
  C_RESET=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''
fi

ok()   { printf "%s✓%s %s\n" "$C_GREEN"  "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
log()  { printf "%s→%s %s\n" "$C_BLUE"   "$C_RESET" "$*"; }

if [[ -f "$LOCAL" ]] && git config -f "$LOCAL" --get user.email >/dev/null 2>&1; then
  ok "$LOCAL already has identity (skip)"
  exit 0
fi

read -rp "Git name:  " NAME
read -rp "Git email: " EMAIL

if [[ -z "$NAME" || -z "$EMAIL" ]]; then
  warn "name or email empty, skipping"
  exit 0
fi

git config -f "$LOCAL" user.name  "$NAME"
git config -f "$LOCAL" user.email "$EMAIL"

log "wrote $LOCAL"
ok "git identity configured"
