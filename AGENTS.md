# AGENTS.md

Personal dotfiles for macOS/Linux. Files in repo root are symlinked to `$HOME`
with a `.` prefix (e.g., `zshrc` → `~/.zshrc`). Managed by `install.sh`.

## Commands

```sh
./install.sh           # Install symlinks + initialize shell
./install.sh symlinks  # Only install symlinks
./install.sh moshi_hook  # Install/enable moshi-hook user service + linger
./install.sh terminfo  # Install terminfo entries
nix-env -if default.nix  # Install/update Nix packages
```

## Key Patterns

- **Symlinks**: `install.sh` has a `SYMLINKS` array listing all managed files
- **ZSH modules**: Topic files in `zsh/` (e.g., `golang.zsh`, `kubernetes.zsh`)
  sourced by `zshrc`. Helper functions in `zsh/zshrc.funcs.zsh`.
- **PATH**: Built in `zshenv`; interactive setup in `zshrc`
- **XDG config**: Lives under `config/` (ghostty, kitty, mise, starship, etc.)
- **systemd user units**: Host-specific units live under `config/systemd/user/`
  and should be installed by explicit `install.sh` commands, not defaults.
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
- `config/xkeysnail/config.py` is symlinked by `install.sh`; the matching
  `config/xkeysnail/systemd.service` is installed manually per the README.
- xkeysnail fails before config loading if `/dev/uinput` is missing; load the
  `uinput` module and apply the udev rules from `config/xkeysnail/README.md`.
- xkeysnail 0.4.0 is incompatible with evdev 1.9 because it expects
  `InputDevice.fn`; keep the mise `pipx:xkeysnail` entry pinned to `evdev<1.9`.
- xkeysnail app-specific keymaps depend on Xlib `WM_CLASS`; native Wayland apps
  such as VSCode may report an empty class and skip those keymaps.
- `bin/gh-*` scripts are not automatically dispatched by `gh <name>`; install
  them as GitHub CLI extensions or add `gh` aliases when that UX is needed.
- `mise which` re-resolves `latest` version pins over the network when caches
  are stale, taking seconds per call (worse under GitHub rate limits). The
  `mise-which` helper in `zshenv` sets `MISE_OFFLINE=1` to keep shell startup
  network-free; keep that when modifying it.
- `zshrc` bails early when `CLAUDECODE=1`, `TERM=dumb`, or under VSCode env
  resolution — profiling shell startup from agent sessions requires
  `CLAUDECODE=0 TERM=xterm-256color` overrides.
- `moshi-hook.service` is host-specific. Install it with
  `./install.sh moshi_hook`, which also enables user linger.
- `./install.sh moshi_hook` only installs/enables the daemon. Moshi agent
  setup still requires `moshi-hook pair --token <token from Moshi>` and
  `moshi-hook install`; verify with `moshi-hook status` and
  `moshi-hook logs -f`.
