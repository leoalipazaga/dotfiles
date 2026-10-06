#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Link config files from ~/dotfiles/config into $HOME locations.
# Idempotent: existing symlinks pointing to the right source are
# left alone; existing files/dirs are backed up to *.bak.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/dotfiles}"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'; C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'; C_BLUE=$'\033[34m'
else
  C_RESET=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''
fi

ok()   { printf "%s✓%s %s\n" "$C_GREEN"  "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
log()  { printf "%s→%s %s\n" "$C_BLUE"   "$C_RESET" "$*"; }

link() {
  local src="$1" dst="$2"

  if [[ ! -e "$src" ]]; then
    warn "source missing, skipping: $src"
    return
  fi

  if [[ -L "$dst" ]] && [[ "$(readlink "$dst")" == "$src" ]]; then
    ok "already linked: $dst"
    return
  fi

  if [[ -e "$dst" ]] || [[ -L "$dst" ]]; then
    local backup="$dst.bak.$(date +%s)"
    warn "backup: $dst → $backup"
    mv "$dst" "$backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  log "linked: $dst → $src"
}

main() {
  log "Linking configs from $DOTFILES/config"

  # ── ~/.config/* ────────────────────────────────────────────
  for d in nvim tmux starship atuin ghostty; do
    link "$DOTFILES/config/$d" "$HOME/.config/$d"
  done

  # ── $HOME dotfiles ─────────────────────────────────────────
  link "$DOTFILES/config/zsh/.zshrc"     "$HOME/.zshrc"
  link "$DOTFILES/config/zsh/.zshenv"    "$HOME/.zshenv"
  link "$DOTFILES/config/zsh/.zprofile"  "$HOME/.zprofile"
  link "$DOTFILES/config/git/.gitconfig" "$HOME/.gitconfig"

  ok "All links applied."
}

main "$@"
