# tmux host overrides

Per-machine tmux config, sourced by `tmux.conf` before the livery
plugin runs. Add a file named `<short-hostname>.conf` (as reported by
`hostname -s`), e.g. `noct.conf`:

```tmux
set -g @livery_preset ember
```

`~/.tmux.local.conf` (untracked) is sourced after the host file and
overrides it.
