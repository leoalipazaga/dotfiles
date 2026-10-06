# dotfiles

macOS dev env. Bash + Homebrew + symlinks. Re-runnable, idempotent.

## Install

```bash
git clone https://github.com/leoalipazaga/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Prompts before each step. Safe to re-run.

## Pipeline

`install.sh` runs:

1. Check macOS
2. Install git (Xcode CLT)
3. Install Homebrew
4. Apply `Brewfile`
5. macOS defaults (dock, finder, trackpad)
6. Symlink configs into `~/.config` + `$HOME`
7. Configure git identity in `~/.gitconfig.local`
8. Bootstrap TPM (tmux plugin manager)
9. Store API keys in macOS Keychain

## Layout

```
.
├── Brewfile              # taps, brews, casks, vscode, go
├── install.sh            # bootstrap entry point
├── config/               # symlinked into ~/.config and $HOME
│   ├── atuin/
│   ├── ghostty/
│   ├── git/
│   ├── nvim/
│   ├── starship/
│   ├── tmux/
│   └── zsh/
└── scripts/              # called by install.sh, runnable standalone
    ├── bootstrap-tpm.sh
    ├── git-identity.sh
    ├── link-configs.sh
    ├── macos-defaults.sh
    └── secrets-keychain.sh
```

## Symlink map

`scripts/link-configs.sh` creates:

| Source                  | Target               |
| ----------------------- | -------------------- |
| `config/nvim`           | `~/.config/nvim`     |
| `config/tmux`           | `~/.config/tmux`     |
| `config/starship`       | `~/.config/starship` |
| `config/atuin`          | `~/.config/atuin`    |
| `config/ghostty`        | `~/.config/ghostty`  |
| `config/zsh/.zshrc`     | `~/.zshrc`           |
| `config/zsh/.zshenv`    | `~/.zshenv`          |
| `config/zsh/.zprofile`  | `~/.zprofile`        |
| `config/git/.gitconfig` | `~/.gitconfig`       |

Existing targets backed up to `*.bak.<timestamp>`.

## Git identity

`config/git/.gitconfig` ships **without** `[user]`. Personal name/email live in
`~/.gitconfig.local` (machine-local, never committed) and are pulled in via
`[include]`.

`install.sh` runs `scripts/git-identity.sh` which prompts for name + email
and writes `~/.gitconfig.local`. Idempotent — skips if already configured.

Manual setup (if you skipped the prompt):

```bash
./scripts/git-identity.sh
# or
git config -f ~/.gitconfig.local user.name  "Your Name"
git config -f ~/.gitconfig.local user.email "you@example.com"
```

Verify:

```bash
git config --get user.email   # should print your email
```

## Local shell overrides (`~/.zshrc.local`)

`config/zsh/.zshrc` sources `~/.zshrc.local` if it exists. Use it for
machine-specific or work-specific shell config that should NOT be committed.

Typical contents:

- Work-only paths and SDK initializers
- Per-machine `PATH` additions
- Private aliases or functions
- Env vars that shouldn't live in the repo

Example `~/.zshrc.local`:

```bash
# Per-machine PATH
export PATH="$HOME/.local/bin:$PATH"

# Private aliases
alias work="cd ~/Documents/workspace/acme"

# Per-machine env vars
export EDITOR="nvim"
```

Loaded automatically on shell start. Sourced AFTER core config — overrides win.

Never commit `~/.zshrc.local`. It lives in `$HOME`, not in this repo.

## Secrets

`scripts/secrets-keychain.sh` stores keys in macOS Keychain:

- `ANTHROPIC_API_KEY`
- `GITHUB_TOKEN`
- `GITLAB_TOKEN`

Read back:

```bash
security find-generic-password -a "$USER" -s ANTHROPIC_API_KEY -w
```

Delete:

```bash
security delete-generic-password -a "$USER" -s ANTHROPIC_API_KEY
```

## Run individual steps

```bash
./scripts/link-configs.sh
./scripts/macos-defaults.sh
./scripts/git-identity.sh
./scripts/secrets-keychain.sh
./scripts/bootstrap-tpm.sh
```

## After install

1. Reload shell: `exec $SHELL -l`
2. Open tmux, press `prefix + I` to install plugins
3. Re-run `./install.sh` any time — every step idempotent

## Requirements

- macOS (Darwin)
- Internet (Homebrew, git clone)
