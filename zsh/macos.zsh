#
# macOS Specific
#

# Aliases
alias o="open"

# Flush DNS cache
alias flush_dns="dscacheutil -flushcache"

# Open man page in Preview.
pman () {
  man -t "${1}" | open -f -a /Applications/Preview.app
}

# Fix wifi issues on OS X 10.10.x Yosemite.
#  - from: https://medium.com/@mariociabarra/wifried-ios-8-wifi-performance-issues-3029a164ce94
alias fix_wifi="sudo ifconfig awdl0 down"
alias unfix_wifi="sudo ifconfig awdl0 up"

# Disable the system built-in cmd+ctrl+d global hotkey to lookup word in
# dictionary on OS X. Must reboot after running.
#  - from: ://apple.stackexchange.com/a/114269
osx-disable-lookup-word-hotkey () {
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 \
           '<dict><key>enabled</key><false/></dict>'
  echo "Command-Control-D hotkey disabled. Please reboot to take effect."
}

#
# Power management
#

# Set all relevant power management settings to force the machine to save a
# sleep image and immediately enter "standby" along with FileVault destroying
# disk decryption keys.
pm-hibernate () {
  sudo pmset -a hibernatemode 25
  sudo pmset -a standby 1
  sudo pmset -a standbydelayhigh 0
  sudo pmset -a standbydelaylow 0
  sudo pmset -a autopoweroffdelay 0
  sudo pmset -a destroyfvkeyonstandby 1
}

# Restore all settings modified by pm-hibernate to their defaults, effectively
# restoring default sleep behavior for macOS laptops.
pm-safesleep () {
  sudo pmset -a hibernatemode 3
  sudo pmset -a standbydelayhigh 86400
  sudo pmset -a standbydelaylow 0
  sudo pmset -a autopoweroffdelay 28800
  sudo pmset -a destroyfvkeyonstandby 0
}

# Trigger hibernation now.
hibernate () {
  pm-hibernate
  sudo pmset sleepnow
}

# Trigger a safe-sleep now.
safesleep () {
  pm-safesleep
  sudo pmset sleepnow
}
