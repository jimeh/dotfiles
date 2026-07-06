#!/usr/bin/env bash

set -u

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PRESET_NAMES='aurora ember lagoon violet moss slate sky rose sand coral
lime ash cherry orchid jade plum fuchsia'

get_tmux_option() {
  local option="$1"

  tmux show-option -gqv "$option"
}

set_tmux_option() {
  local option="$1"
  local value="$2"

  tmux set-option -gq "$option" "$value"
}

default_tmux_option() {
  local option="$1"
  local default="$2"
  local value

  value="$(get_tmux_option "$option")"
  if [ -n "$value" ]; then
    printf '%s\n' "$value"
  else
    printf '%s\n' "$default"
  fi
}

host_short() {
  local host

  host="$(tmux display-message -p '#{host_short}' 2> /dev/null)"
  if [ -n "$host" ]; then
    printf '%s\n' "$host"
  else
    hostname -s 2> /dev/null || hostname
  fi
}

seeded_preset() {
  local host="$1"
  local sum

  sum="$(printf '%s' "$host" | cksum | awk '{ print $1 }')"

  # shellcheck disable=SC2086
  set -- $PRESET_NAMES
  shift "$((sum % $#))"
  printf '%s\n' "$1"
}

resolve_preset() {
  local preset="$1"
  local host="$2"
  local name

  for name in $PRESET_NAMES; do
    if [ "$name" = "$preset" ]; then
      printf '%s\n' "$preset"
      return
    fi
  done

  seeded_preset "$host"
}

mix_color() {
  local c1="${1#\#}" c2="${2#\#}" pct="$3"
  local r g b

  r=$((($((16#${c1:0:2})) * pct + $((16#${c2:0:2})) * (100 - pct)) / 100))
  g=$((($((16#${c1:2:2})) * pct + $((16#${c2:2:2})) * (100 - pct)) / 100))
  b=$((($((16#${c1:4:2})) * pct + $((16#${c2:4:2})) * (100 - pct)) / 100))

  printf '#%02x%02x%02x\n' "$r" "$g" "$b"
}

apply_preset() {
  local preset="$1"
  local base_color="$2"
  local bg='#15181d'
  local bg_alt='#20242b'
  local fg='#d7dde7'
  local muted='#8b96a8'
  local subtle='#6f7a8d'
  local border='#343a44'
  local base='#8aadf4'
  local base_alt
  local warn='#eed49f'
  local alert='#ed8796'
  local dark='#101216'

  case "$preset" in
    aurora) base='#8aadf4' ;;
    ember) base='#f5a97f' ;;
    lagoon) base='#8bd5ca' ;;
    violet) base='#c6a0f6' ;;
    moss) base='#a6da95' ;;
    slate) base='#b7bdf8' ;;
    sky) base='#7dc4e4' ;;
    rose) base='#f5bde6' ;;
    sand) base='#eed49f' ;;
    coral) base='#ee99a0' ;;
    lime) base='#c8dd88' ;;
    ash) base='#a5adcb' ;;
    cherry) base='#ed8796' ;;
    orchid) base='#e38dcd' ;;
    jade) base='#8cd9b3' ;;
    plum) base='#d290df' ;;
    fuchsia) base='#e06ee0' ;;
  esac

  if [ -n "$base_color" ]; then
    base="$base_color"
  fi

  # Quieter tint of base, used for bell/activity window tabs.
  base_alt="$(mix_color "$base" "$bg" 60)"

  set_tmux_option @livery_current_preset "$preset"
  set_tmux_option @livery_base "$base"
  set_tmux_option @livery_base_alt "$base_alt"
  set_tmux_option @livery_bg "$bg"
  set_tmux_option @livery_bg_alt "$bg_alt"
  set_tmux_option @livery_fg "$fg"
  set_tmux_option @livery_muted "$muted"
  set_tmux_option @livery_subtle "$subtle"
  set_tmux_option @livery_border "$border"
  set_tmux_option @livery_warn "$warn"
  set_tmux_option @livery_alert "$alert"
  set_tmux_option @livery_dark "$dark"
}

segment() {
  local fg="$1"
  local bg="$2"
  local text="$3"

  printf '#[fg=%s]#[bg=%s]%s' "$fg" "$bg" "$text"
}

main() {
  local host preset requested_preset base_color
  local host_label left_extra right_extra clock_format clock_min_width
  local interval
  local show_cpu show_memory show_disk disk_path
  local bg bg_alt fg muted subtle border base base_alt warn alert dark
  local cpu memory disk metrics metric_sep sync_on
  local prefix prefix_on prefix_off left right clock wide tail

  host="$(host_short)"
  requested_preset="$(get_tmux_option @livery_preset)"
  preset="$(resolve_preset "$requested_preset" "$host")"
  base_color="$(get_tmux_option @livery_base_color)"

  # mix_color needs a full #rrggbb value; ignore anything else.
  case "$base_color" in
    '#'[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]) ;;
    *) base_color='' ;;
  esac

  apply_preset "$preset" "$base_color"

  host_label="$(default_tmux_option @livery_host_label '#H')"
  left_extra="$(get_tmux_option @livery_left_extra)"
  right_extra="$(get_tmux_option @livery_right_extra)"
  clock_format="$(default_tmux_option @livery_clock_format '%H:%M')"
  clock_min_width="$(default_tmux_option @livery_clock_min_width '91')"
  interval="$(default_tmux_option @livery_status_interval '5')"
  show_cpu="$(default_tmux_option @livery_show_cpu 'on')"
  show_memory="$(default_tmux_option @livery_show_memory 'on')"
  show_disk="$(default_tmux_option @livery_show_disk 'off')"
  disk_path="$(default_tmux_option @livery_disk_path '/')"

  bg="$(get_tmux_option @livery_bg)"
  bg_alt="$(get_tmux_option @livery_bg_alt)"
  fg="$(get_tmux_option @livery_fg)"
  muted="$(get_tmux_option @livery_muted)"
  subtle="$(get_tmux_option @livery_subtle)"
  border="$(get_tmux_option @livery_border)"
  base="$(get_tmux_option @livery_base)"
  base_alt="$(get_tmux_option @livery_base_alt)"
  warn="$(get_tmux_option @livery_warn)"
  alert="$(get_tmux_option @livery_alert)"
  dark="$(get_tmux_option @livery_dark)"

  set_tmux_option @livery_plugin_dir "$CURRENT_DIR"
  # Unquoted echo flattens the newline in PRESET_NAMES to a space.
  # shellcheck disable=SC2086,SC2116
  set_tmux_option @livery_preset_names "$(echo $PRESET_NAMES)"

  cpu="#($CURRENT_DIR/scripts/cpu)"
  memory="#($CURRENT_DIR/scripts/memory)"
  disk="#($CURRENT_DIR/scripts/disk '$disk_path')"
  metric_sep="$(segment "$muted" "$bg_alt" '∙')"

  # The invisible bg-on-bg placeholder keeps the centred window list
  # from shifting every time the prefix indicator flashes on.
  prefix_on="$(segment "$warn" "$bg_alt" '∙ ')"
  prefix_off="$(segment "$bg" "$bg" '∙ ')"
  prefix="#{?client_prefix,$prefix_on,$prefix_off}"
  sync_on="$(segment "$dark" "$alert" ' SYNC ')"
  set_tmux_option @livery_sync_on "$sync_on"
  set_tmux_option @livery_sync_off ''

  # Commas would split the surrounding #{?...} conditional; tmux turns
  # #, back into a literal comma at display time.
  clock="$(segment "$dark" "$base" " ${clock_format//,/#,} ")"
  wide="#{e|>=:#{client_width},$clock_min_width}"
  # SYNC takes over the clock slot while panes are synchronized (at any
  # width); the clock itself only renders on clients wide enough.
  tail="#{?pane_synchronized,$sync_on,#{?$wide,$clock,}}"

  left="$(segment "$dark" "$base" " $host_label ")"
  left="$left$(segment "$fg" "$bg_alt" ' #S ')"
  left="$left$prefix"

  if [ -n "$left_extra" ]; then
    left="$left$(segment "$fg" "$bg_alt" " $left_extra ")"
  fi

  right=''

  if [ -n "$right_extra" ]; then
    right="$right$(segment "$fg" "$bg_alt" " $right_extra ")"
  fi

  metrics=''

  if [ "$show_cpu" = 'on' ]; then
    metrics="$(segment "$fg" "$bg_alt" " CPU $cpu ")"
  fi

  if [ "$show_memory" = 'on' ]; then
    if [ -n "$metrics" ]; then
      metrics="$metrics$metric_sep"
    fi
    metrics="$metrics$(segment "$fg" "$bg_alt" " MEM $memory ")"
  fi

  if [ "$show_disk" = 'on' ]; then
    if [ -n "$metrics" ]; then
      metrics="$metrics$metric_sep"
    fi
    metrics="$metrics$(segment "$fg" "$bg_alt" " $disk_path $disk ")"
  fi

  right="$right$metrics"
  right="$right$tail"

  set_tmux_option status on
  set_tmux_option status-interval "$interval"
  set_tmux_option status-left-length 80
  set_tmux_option status-right-length 140
  set_tmux_option status-justify centre
  set_tmux_option status-style "fg=$fg,bg=$bg"
  set_tmux_option status-left-style "fg=$fg,bg=$bg"
  set_tmux_option status-right-style "fg=$fg,bg=$bg"
  set_tmux_option message-style "fg=$dark,bg=$warn"
  set_tmux_option mode-style "fg=$dark,bg=$base"
  set_tmux_option pane-border-style "fg=$border"
  set_tmux_option pane-active-border-style "fg=$base"
  set_tmux_option window-status-separator ''
  set_tmux_option window-status-style "fg=$subtle,bg=$bg"
  set_tmux_option window-status-current-style "fg=$base,bg=$bg"
  set_tmux_option window-status-bell-style "fg=$base_alt,bg=$bg"
  set_tmux_option window-status-activity-style "fg=$base_alt,bg=$bg"
  set_tmux_option window-status-format ' #I:#W#F '
  set_tmux_option window-status-current-format ' #I:#W#F '
  set_tmux_option status-left "$left#[default]"
  set_tmux_option status-right "$right#[default]"
}

main
