# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular dotfiles repository for macOS. Configurations are managed via symlinks — changes in this repo automatically apply to the user's home directory.

## Installation

```bash
./install                          # Install all modules
./install --only git bash          # Install specific modules
./install --skip macos             # Skip a module
./install --list                   # Show available modules
./install --dry-run --verbose      # Preview without executing
```

**Available modules:** `homebrew`, `editorconfig`, `bash`, `oh-my-zsh`, `git`, `karabiner`, `mackup`, `macos`

Each module lives in its own directory with a `setup.sh` that handles symlinking and any additional setup.

## Architecture

### Symlink-based config management
All dotfiles are symlinked from this repo to `~`. For example, `~/.gitconfig` → `~/dotfiles/git/.gitconfig`. Adding new configs follows this pattern: put the file in the relevant module directory and create the symlink in `setup.sh`.

### Shell loading order
1. `.zshenv` (all shells) — sources `terminal/.path`, `terminal/.exports`, `terminal/.exports_private`
2. `.zprofile` (login shells) — Homebrew shellenv
3. `.zshrc` (interactive) — Oh My Zsh, Powerlevel10k, zsh plugins, all terminal files

### Terminal shared config (`terminal/`)
- `.path` — PATH extensions (`~/dotfiles/bin`, `~/.local/bin`)
- `.exports` — Environment variables (EDITOR, GPG_TTY, history settings)
- `.aliases` — 150+ shell aliases
- `.functions` — Shell utility functions

### Private/secret files (not tracked in git)
- `terminal/.exports_private` — Secret environment variables
- `git/gitconfig_private` — Private git config (included by `.gitconfig`)

### Custom bin scripts (`bin/`)
Added to PATH automatically. Contains git helper scripts (`git-default-branch`, `git-open`, `git-sync-origin`, `git-cleanup-worktrees`, `git-track`, `git-get-diffstats`) and utilities (`iterm`, `open-in-browser`, `e`).

### Git aliases (`git/aliases`)
100+ aliases loaded via `.gitconfig`. Key conventions:
- `rb`/`rbm` for rebase, `mm`/`mg` for merge, `ci`/`cam` for commit
- `db`/`db-all` for branch deletion, `ss`/`sp`/`sl` for stash
- Default branch detection uses `bin/git-default-branch`

### Dracula theme (`themes/`)
All theme variants are git submodules. Update with `git submodule update --remote`.

### Agent mode detection (`.zshrc`)
Zsh detects whether it's running inside Cursor AI and uses a simplified prompt (skips Powerlevel10k and syntax highlighting) to avoid interference with AI tooling.

### Application Support configs
Cursor/VSCode `settings.json` is shared — symlinked to both `~/Library/Application Support/Cursor/User/` and `~/Library/Application Support/Code/User/`. Run `Application Support/Cursor/setup.sh` (or `Application Support/Code/setup.sh`) to install.
