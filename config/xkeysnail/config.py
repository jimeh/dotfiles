from xkeysnail.transform import *
from xkeysnail.key import Key

define_modmap({
    # Treat CAPSLOCK as CTRL.
    Key.CAPSLOCK: Key.LEFT_CTRL,

    # Ensure ` and ~ key is next to left shift.
    Key.KEY_102ND: Key.GRAVE,
    Key.GRAVE: Key.KEY_102ND,
})

define_keymap(lambda wm_class: wm_class in ("Gnome-terminal", "Guake"), {
}, "Terminal keys")

define_keymap(lambda wm_class: wm_class in ("firefox", "Google-chrome"), {
    K("Super-Shift-Left_Brace"): K("C-Shift-tab"),
    K("Super-Shift-Right_Brace"): K("C-tab"),
    K("Super-Left_Brace"): K("M-left"),
    K("Super-Right_Brace"): K("M-right"),
}, "Browser keys")

# Emacs-like keybindings in non-Emacs applications
define_keymap(lambda wm_class: wm_class not in ("Emacs", "URxvt", "Gnome-terminal", "Guake"), {
    K("Super-x"): K("C-x"),
    K("Super-c"): K("C-c"),
    K("Super-v"): K("C-v"),

    K("Super-a"): K("C-a"),
    K("Super-l"): K("C-l"),
    K("Super-t"): K("C-t"),
    K("Super-r"): K("C-r"),
    K("Super-z"): K("C-z"),
    K("Super-Shift-z"): K("C-Shift-z"),

    # Cursor
    K("C-b"): with_mark(K("left")),
    K("C-f"): with_mark(K("right")),
    K("C-p"): with_mark(K("up")),
    K("C-n"): with_mark(K("down")),
    K("C-h"): with_mark(K("backspace")),
    K("Super-f"): K("C-f"),
    K("Super-n"): K("C-n"),
    K("Super-p"): K("C-p"),
    K("Super-h"): K("C-h"),

    # Forward/Backward word
    K("M-b"): with_mark(K("C-left")),
    K("M-f"): with_mark(K("C-right")),

    # Beginning/End of line
    K("C-a"): with_mark(K("home")),
    K("C-e"): with_mark(K("end")),

    # Page up/down
    K("M-v"): with_mark(K("page_up")),
    K("C-v"): with_mark(K("page_down")),

    # Beginning/End of file
    K("M-Shift-comma"): with_mark(K("C-home")),
    K("M-Shift-dot"): with_mark(K("C-end")),

    # Newline
    K("C-m"): K("enter"),
    K("C-j"): K("enter"),
    K("C-o"): [K("enter"), K("left")],
    K("Super-o"): K("C-o"),

    # Copy
    K("C-w"): [K("C-x"), set_mark(False)],
    K("M-w"): [K("C-c"), set_mark(False)],
    K("C-y"): [K("C-v"), set_mark(False)],
    K("Super-w"): K("C-w"),

    # Delete
    K("C-d"): [K("delete"), set_mark(False)],
    K("M-d"): [K("C-delete"), set_mark(False)],
    K("Super-d"): K("C-d"),

    # Backspace
    K("M-backspace"): [K("C-backspace"), set_mark(False)],

    # Kill line
    # K("C-k"): [K("Shift-end"), K("C-x"), set_mark(False)],

    # Undo
    K("M-minus"): [K("C-z"), set_mark(False)],
    # K("C-slash"): [K("C-z"), set_mark(False)],
    # K("C-Shift-ro"): K("C-z"),

    # Mark
    K("C-space"): set_mark(True),
    K("C-M-space"): with_or_set_mark(K("C-right")),

    # Search
    # K("C-s"): K("F3"),
    # K("C-r"): K("Shift-F3"),
    # K("M-Shift-key_5"): K("C-h"),
    K("Super-s"): K("C-s"),

    # Cancel
    K("C-g"): [K("esc"), set_mark(False)],

    # Escape
    K("C-q"): escape_next_key,
    K("C-left_brace"): K("esc"),

    # C-x YYY
    K("C-x"): {
        # C-x h (select all)
        K("h"): [K("C-home"), K("C-a"), set_mark(True)],
        # C-x C-f (open)
        K("C-f"): K("C-o"),
        # C-x C-s (save)
        K("C-s"): K("C-s"),
        # C-x k (kill tab)
        # K("k"): K("C-f4"),
        # C-x C-c (exit)
        # K("C-c"): K("C-q"),
        # cancel
        K("C-g"): pass_through_key,
        # C-x u (undo)
        # K("u"): [K("C-z"), set_mark(False)],
    }
}, "Emacs-like keys")
