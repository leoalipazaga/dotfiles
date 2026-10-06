#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# Dev environment bootstrap (Bash + Homebrew + scripts/).
#
# Pipeline:
#   1. require macOS
#   2. install git (Xcode CLT)
#   3. install Homebrew
#   4. apply Brewfile
#   5. macOS defaults
#   6. link configs (~/dotfiles/config → ~/.config + $HOME)
#   7. configure git identity (~/.gitconfig.local)
#   8. bootstrap TPM (tmux plugin manager)
#   9. store secrets in Keychain
#
# Re-runnable: every step is idempotent.
# ─────────────────────────────────────────────────────────────
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

if [[ -t 1 ]]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'
  C_BLUE=$'\033[34m'
else
  C_RESET=''
  C_BOLD=''
  C_GREEN=''
  C_YELLOW=''
  C_RED=''
  C_BLUE=''
fi

log() { printf "%s==>%s %s\n" "$C_BLUE$C_BOLD" "$C_RESET" "$*"; }
ok() { printf "%s✓%s %s\n" "$C_GREEN" "$C_RESET" "$*"; }
warn() { printf "%s!%s %s\n" "$C_YELLOW" "$C_RESET" "$*"; }
err() { printf "%s✗%s %s\n" "$C_RED" "$C_RESET" "$*" >&2; }

confirm() {
  local prompt="$1" default="${2:-N}" reply
  local hint="[y/N]"
  [[ "$default" == "Y" ]] && hint="[Y/n]"
  printf "%s?%s %s %s " "$C_BOLD" "$C_RESET" "$prompt" "$hint"
  read -r reply
  reply="${reply:-$default}"
  [[ "$reply" =~ ^[Yy]$ ]]
}

require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || {
    err "macOS only"
    exit 1
  }
}

install_git() {
  if command -v git >/dev/null 2>&1; then
    ok "git present ($(git --version))"
    return
  fi
  warn "git missing"
  if confirm "Install Xcode Command Line Tools (provides git)?" Y; then
    xcode-select --install || true
    log "Wait for the GUI prompt to finish, then re-run this script."
    exit 0
  else
    err "git required"
    exit 1
  fi
}

install_brew() {
  if command -v brew >/dev/null 2>&1; then
    ok "brew present ($(brew --version | head -1))"
    return
  fi
  warn "brew missing"
  if confirm "Install Homebrew?" Y; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # shellcheck disable=SC2016
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ok "brew installed"
  else
    err "brew required"
    exit 1
  fi
}

apply_brewfile() {
  local brewfile="$DOTFILES_DIR/Brewfile"
  if [[ ! -f "$brewfile" ]]; then
    warn "Brewfile not found at $brewfile, skipping"
    return
  fi
  if confirm "Apply Brewfile (install all listed taps/brews/casks)?" Y; then
    log "Running: brew bundle --file=$brewfile"
    brew bundle --file="$brewfile"
    ok "Brewfile applied"
  fi
}

apply_macos_defaults() {
  if confirm "Apply macOS defaults (dock, finder, trackpad)?" Y; then
    "$DOTFILES_DIR/scripts/macos-defaults.sh"
  fi
}

link_configs() {
  if confirm "Link configs into ~/.config and \$HOME?" Y; then
    "$DOTFILES_DIR/scripts/link-configs.sh"
  fi
}

setup_git_identity() {
  if confirm "Configure git identity in ~/.gitconfig.local?" Y; then
    "$DOTFILES_DIR/scripts/git-identity.sh"
  fi
}

bootstrap_tpm() {
  if confirm "Bootstrap tmux Plugin Manager (TPM)?" Y; then
    "$DOTFILES_DIR/scripts/bootstrap-tpm.sh"
  fi
}

setup_secrets() {
  if confirm "Store secrets in macOS Keychain (ANTHROPIC, etc.)?" Y; then
    "$DOTFILES_DIR/scripts/secrets-keychain.sh"
  fi
}

print_next_steps() {
  cat <<EOF

${C_BOLD}Next steps${C_RESET}
  1. Reload shell:        exec \$SHELL -l
  2. Install tmux plugins: open tmux, press 'prefix + I'
  3. Re-run anytime:       ./install.sh (idempotent)
  4. Individual scripts:   ./scripts/link-configs.sh
                          ./scripts/macos-defaults.sh
                          ./scripts/git-identity.sh
                          ./scripts/secrets-keychain.sh
                          ./scripts/bootstrap-tpm.sh

EOF
}

main() {
  require_macos
  log "Dotfiles bootstrap — $DOTFILES_DIR"
  echo

  confirm "Run full bootstrap (git, brew, configs, secrets)?" Y || {
    warn "Aborted by user"
    exit 0
  }

  install_git
  install_brew
  apply_brewfile
  apply_macos_defaults
  link_configs
  setup_git_identity
  bootstrap_tpm
  setup_secrets
  print_next_steps
}

main "$@"
