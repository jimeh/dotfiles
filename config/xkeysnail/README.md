# jimeh's xkeysnail setup

The goal here is to use [xkeysnail][] Linux keyboard shortcuts mostly behave the
same as on macOS.

[xkeysnail]: https://github.com/mooz/xkeysnail

## Pre-requisites

To be able to run xkeysnail as a non-root user / with sudo, we need to perform
some initial setup.

1. Create a `uinput` group and add your user to it:
   ```bash
   sudo groupadd -f uinput
   sudo gpasswd -a $USER uinput
   ```
2. Create udev rules for xkeysnail:
   ```bash
   cat <<EOF | sudo tee /etc/udev/rules.d/70-xkeysnail.rules
   KERNEL=="uinput", GROUP="uinput", MODE="0660", OPTIONS+="static_node=uinput"
   KERNEL=="event[0-9]*", GROUP="uinput", MODE="0660"
   EOF
   ```
3. Reboot.

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
