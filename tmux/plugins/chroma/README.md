# chroma

Minimal tmux status line theme with per-host accent colors and bundled
CPU/memory status helpers. Each host gets its own chroma, deterministically
seeded to one of the accent presets from its short hostname, so different
machines get different colors with zero configuration. Loaded from
`tmux.conf` via:

```tmux
run-shell "${HOME}/.tmux/plugins/chroma/chroma.tmux"
```

See `palette.html` for a visual reference of all presets.

## Options

Set before the `run-shell` line (e.g. in `tmux/hosts/<host>.conf` or
`~/.tmux.local.conf`, both sourced by `tmux.conf`):

| Option                    | Default     | Description                  |
| ------------------------- | ----------- | ---------------------------- |
| `@chroma_preset`          | host-seeded | Preset name (see below)      |
| `@chroma_base_color`      | unset       | `#rrggbb` accent override;   |
|                           |             | replaces the preset's base   |
| `@chroma_clock_format`    | `%H:%M`     | strftime clock format        |
| `@chroma_clock_min_width` | `91`        | Hide clock on narrower       |
|                           |             | clients; SYNC replaces the   |
|                           |             | clock slot at any width      |
| `@chroma_powerline`       | `off`       | Use Powerline section        |
|                           |             | dividers (`on`/`off`)        |
| `@chroma_status_interval` | `5`         | `status-interval` seconds    |
| `@chroma_show_cpu`        | `on`        | Show CPU metric (`on`/`off`) |
| `@chroma_show_memory`     | `on`        | Show MEM metric (`on`/`off`) |
| `@chroma_show_disk`       | `off`       | Show disk free (`on`/`off`)  |
| `@chroma_disk_path`       | `/`         | Path for the disk metric     |
| `@chroma_host_label`      | `#H`        | Text for the host segment    |
| `@chroma_left_extra`      | unset       | Extra left segment text      |
| `@chroma_right_extra`     | unset       | Extra right segment text     |

Presets: aurora, ember, lagoon, violet, moss, slate, sky, rose, sand,
coral, lime, ash, cherry, orchid, jade, plum, fuchsia.

Bell/activity tabs use `muted` text to remain distinct from the active tab.
Tab flags use `base_alt`, except the bell indicator (`!`), which uses `alert`.
`base_alt` is always derived as a 60% blend of the base color toward the bar
background, including for custom `@chroma_base_color` values.

Powerline mode requires a font containing the `` and `` glyphs. It changes
the dividers between colored sections in the left and right status areas. The
shared metric group continues to use `∙` separators.

## Exported options

The theme publishes its resolved palette as global options for reuse:
`@chroma_base`, `_base_alt`, `_bg`, `_bg_alt`, `_fg`, `_muted`,
`_subtle`, `_border`, `_warn`, `_alert`, `_dark`, `_current_preset`,
`_preset_names`, `_plugin_dir`, `_sync_on`, `_sync_off`.
