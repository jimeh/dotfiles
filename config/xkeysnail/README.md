# jimeh's xkeysnail setup

The goal here is to use [xkeysnail][] to make Linux keyboard shortcuts mostly
behave the same as on macOS.

[xkeysnail]: https://github.com/mooz/xkeysnail

## Pre-requisites

To be able to run xkeysnail as a non-root user / with sudo, we need to perform
some initial setup.

1. Load the `uinput` module now and on boot:
   ```bash
   sudo modprobe uinput
   echo uinput | sudo tee /etc/modules-load.d/uinput.conf
   ```
2. Create a `uinput` group and add your user to it:
   ```bash
   sudo groupadd -f uinput
   sudo gpasswd -a $USER uinput
   ```
3. Create udev rules for xkeysnail:
   ```bash
   cat <<EOF | sudo tee /etc/udev/rules.d/70-xkeysnail.rules
   KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
   KERNEL=="event[0-9]*", GROUP="uinput", MODE="0660"
   EOF
   ```
4. Reload udev rules and verify the device exists:
   ```bash
   sudo udevadm control --reload-rules
   sudo udevadm trigger
   ls -l /dev/uinput /dev/input/event*
   ```
5. Reboot, or at least log out and back in so your session picks up the new
   `uinput` group.

(Borrowed from [here][1].)

[1]: https://github.com/mooz/xkeysnail/issues/64#issuecomment-600380800

## Setup systemd user service

1. Copy service into place:
   ```bash
   mkdir -p $HOME/.config/systemd/user
   cp ./systemd.service $HOME/.config/systemd/user/xkeysnail.service
   ```
2. Reload user units:
   ```bash
   systemctl --user daemon-reload
   ```
3. Enable service:
   ```bash
   systemctl --user enable xkeysnail.service
   ```
4. Start service:
   ```bash
   systemctl --user start xkeysnail.service
   ```
5. Check status of service:
   ```bash
   systemctl --user status xkeysnail.service
   ```

## Troubleshooting

If xkeysnail exits with:

```text
AttributeError: 'InputDevice' object has no attribute 'fn'
```

then xkeysnail was installed with an incompatible evdev version. The mise
config pins xkeysnail's pipx environment to `evdev<1.9`; force reinstall it:

```bash
mise install -f pipx:xkeysnail
systemctl --user restart xkeysnail.service
```

If a manual xkeysnail command reports `IOError when grabbing device`, check
whether the user service is already running and has grabbed the keyboard:

```bash
systemctl --user status xkeysnail.service
```

## Wayland app matching

xkeysnail uses Xlib to read the focused window's `WM_CLASS`. Native Wayland
apps can show up as an empty class, which prevents app-specific keymaps like
the VSCode workarounds from matching. To check what xkeysnail sees:

```bash
~/.local/share/mise/installs/pipx-xkeysnail/0.4.0/xkeysnail/bin/python - <<'PY'
from xkeysnail.transform import get_active_window_wm_class
print(repr(get_active_window_wm_class()))
PY
```

If this prints `''` while VSCode is focused, run VSCode through Xwayland or keep
the needed shortcuts in the generic keymap.
