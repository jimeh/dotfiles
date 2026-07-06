# livery

Minimal tmux status line theme with per-host accent colors and bundled
CPU/memory status helpers. Every machine wears its own livery: hosts are
deterministically seeded to one of the accent presets from their short
hostname, so different machines get different colors with zero
configuration. Loaded from `tmux.conf` via:

```tmux
run-shell "${HOME}/.tmux/plugins/livery/livery.tmux"
```

See `palette.html` for a visual reference of all presets.

## Options

Set before the `run-shell` line (e.g. in `tmux/hosts/<host>.conf` or
`~/.tmux.local.conf`, both sourced by `tmux.conf`):

| Option                    | Default     | Description                  |
| ------------------------- | ----------- | ---------------------------- |
| `@livery_preset`          | host-seeded | Preset name (see below)      |
| `@livery_base_color`      | unset       | `#rrggbb` accent override;   |
|                           |             | replaces the preset's base   |
| `@livery_clock_format`    | `%H:%M`     | strftime clock format        |
| `@livery_clock_min_width` | `91`        | Hide clock on narrower       |
|                           |             | clients; SYNC replaces the   |
|                           |             | clock slot at any width      |
| `@livery_status_interval` | `5`         | `status-interval` seconds    |
| `@livery_show_cpu`        | `on`        | Show CPU metric (`on`/`off`) |
| `@livery_show_memory`     | `on`        | Show MEM metric (`on`/`off`) |
| `@livery_show_disk`       | `off`       | Show disk free (`on`/`off`)  |
| `@livery_disk_path`       | `/`         | Path for the disk metric     |
| `@livery_host_label`      | `#H`        | Text for the host segment    |
| `@livery_left_extra`      | unset       | Extra left segment text      |
| `@livery_right_extra`     | unset       | Extra right segment text     |

Presets: aurora, ember, lagoon, violet, moss, slate, sky, rose, sand,
coral, lime, ash, cherry, orchid, jade, plum, fuchsia.

`base_alt` (bell/activity tab tint) is always derived as a 60% blend of
the base color toward the bar background, including for custom
`@livery_base_color` values.

## Exported options

The theme publishes its resolved palette as global options for reuse:
`@livery_base`, `_base_alt`, `_bg`, `_bg_alt`, `_fg`, `_muted`,
`_subtle`, `_border`, `_warn`, `_alert`, `_dark`, `_current_preset`,
`_preset_names`, `_plugin_dir`, `_sync_on`, `_sync_off`.
