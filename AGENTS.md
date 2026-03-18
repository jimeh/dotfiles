# AGENTS.md

Personal dotfiles for macOS/Linux. Files in repo root are symlinked to `$HOME`
with a `.` prefix (e.g., `zshrc` → `~/.zshrc`). Managed by `install.sh`.

## Commands

```sh
./install.sh           # Install symlinks + initialize shell
./install.sh symlinks  # Only install symlinks
./install.sh terminfo  # Install terminfo entries
nix-env -if default.nix  # Install/update Nix packages
```

## Key Patterns

- **Symlinks**: `install.sh` has a `SYMLINKS` array listing all managed files
- **ZSH modules**: Topic files in `zsh/` (e.g., `golang.zsh`, `kubernetes.zsh`)
  sourced by `zshrc`. Helper functions in `zsh/zshrc.funcs.zsh`.
- **PATH**: Built in `zshenv`; interactive setup in `zshrc`
- **XDG config**: Lives under `config/` (ghostty, kitty, mise, starship, etc.)
- **Hammerspoon**: Lua-based macOS automation, host-specific config in
  `hammerspoon/hosts/`. Has its own Makefile (`cd hammerspoon && make install`).
- **Private dotfiles**: Separate repo cloned into `private/`, gitignored
- **Nix**: `flake.nix` / `default.nix` for package management
- **Tmux plugins**: Git submodules under `tmux/plugins/`

## Code Style

Shell: 2-space indent, bash-style. See `.editorconfig` for shfmt settings.
Markdown: 80-char line length. See `markdownlint.yaml`.

## Discoveries

- `karabiner/*.json` files are standalone complex-modification snippets for
  Karabiner-Elements import. They are not installed by `install.sh`.
