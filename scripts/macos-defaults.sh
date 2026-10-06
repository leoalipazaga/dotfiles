#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Apply macOS user preferences (mirrors current personal setup).
# Idempotent: defaults write is safe to re-run.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "macOS only" >&2
  exit 1
fi

echo "==> Applying macOS defaults..."

# ── dock ─────────────────────────────────────────────────────
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 50

# ── finder ───────────────────────────────────────────────────
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

# ── trackpad ─────────────────────────────────────────────────
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

# Mirror to bluetooth trackpad domain (some laptops use it)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

# ── apply ────────────────────────────────────────────────────
killall Dock     2>/dev/null || true
killall Finder   2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "✓ macOS defaults applied. Some changes may require logout to take full effect."
