#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Store secrets in macOS Keychain (encrypted, biometric-protected).
# Idempotent: skips secrets already present.
#
# Read back from shell:
#   security find-generic-password -a "$USER" -s ANTHROPIC_API_KEY -w
#
# Delete:
#   security delete-generic-password -a "$USER" -s <key>
# ─────────────────────────────────────────────────────────────
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macOS only — Keychain unavailable" >&2
  exit 1
fi

# Secrets to manage. Add/remove keys as needed.
SECRETS=(
  ANTHROPIC_API_KEY
  GITHUB_TOKEN
  GITLAB_TOKEN
)

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_BLUE=$'\033[34m'
else
  C_RESET=''
  C_GREEN=''
  C_YELLOW=''
  C_BLUE=''
fi

ok() { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
log() { printf "%s→%s %s\n" "$C_BLUE" "$C_RESET" "$*"; }

add_secret() {
  local key="$1"

  if security find-generic-password -a "$USER" -s "$key" >/dev/null 2>&1; then
    ok "$key already in Keychain (skip)"
    return
  fi

  printf "Enter value for %s (or blank to skip): " "$key"
  read -rs val
  echo

  if [[ -z "$val" ]]; then
    warn "$key skipped"
    return
  fi

  security add-generic-password \
    -a "$USER" \
    -s "$key" \
    -w "$val" \
    -T "" \
    -U
  log "$key saved to Keychain"
  unset val
}

main() {
  echo "==> Configuring secrets in macOS Keychain..."
  for key in "${SECRETS[@]}"; do
    add_secret "$key"
  done
  ok "Done."
}

main "$@"
