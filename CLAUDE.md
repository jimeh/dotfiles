# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Overview

Personal dotfiles repository for macOS and Linux. Configuration files are
symlinked to `$HOME` with a `.` prefix (e.g., `zshrc` becomes `~/.zshrc`).

## Commands

### Installation

```sh
./install.sh           # Install symlinks and initialize shell
./install.sh symlinks  # Only install symlinks
./install.sh terminfo  # Install terminfo entries
./install.sh launch-agents  # Install macOS LaunchAgents
```

### Nix packages

```sh
nix-env -if ~/.dotfiles/default.nix  # Install/update global Nix packages
nix flake update                      # Update nixpkgs lock
```

### Hammerspoon

```sh
cd hammerspoon && make install  # Fetch Spoons and dependencies
cd hammerspoon && make update   # Update all dependencies
```

## Structure

- `install.sh` - Main installer, manages symlinks to `$HOME`
- `flake.nix` / `default.nix` - Nix package management (nixfmt, nil LSP)
- `zshrc` / `zshenv` / `zprofile` - ZSH configuration entry points
- `zsh/` - Modular ZSH configs loaded by topic (aliases, kubernetes, golang,
  etc.)
- `zsh/zshrc.funcs.zsh` - Helper functions used throughout ZSH config
- `bin/` - Personal scripts added to PATH
- `config/` - XDG config files (ghostty, kitty, mise, starship, etc.)
- `hammerspoon/` - macOS automation with Hammerspoon
- `tmux/` - Tmux config and plugins (git submodules)
- `private/` - Private dotfiles (separate repo, gitignored)

## Shell Setup

- Uses [zinit](https://github.com/zdharma-continuum/zinit) for ZSH plugin
  management
- Uses [mise](https://mise.jdx.dev/) for runtime version management
- Uses [starship](https://starship.rs/) for prompt
- PATH construction happens in `zshenv`, interactive setup in `zshrc`

## Code Style

Shell scripts: 2-space indent, bash-style (see `.editorconfig` for shfmt
settings).
