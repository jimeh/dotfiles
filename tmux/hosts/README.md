# tmux host overrides

Per-machine tmux config, sourced by `tmux.conf` before the chroma
plugin runs. Add a file named `<short-hostname>.conf` (as reported by
`hostname -s`), e.g. `noct.conf`:

```tmux
set -g @chroma_preset ember
```

`~/.tmux.local.conf` (untracked) is sourced after the host file and
overrides it.
