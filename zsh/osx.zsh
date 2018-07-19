#
# OSX Related
#

if [[ "$(uname)" == "Darwin" ]]; then
  # Fix wifi issues on OS X 10.10.x Yosemite.
  #  - from: https://medium.com/@mariociabarra/wifried-ios-8-wifi-performance-issues-3029a164ce94
  alias fix_wifi="sudo ifconfig awdl0 down"
  alias unfix_wifi="sudo ifconfig awdl0 up"

  # Disable the system built-in cmd+ctrl+d global hotkey to lookup word in
  # dictionary on OS X. Must reboot after running.
  #  - from: ://apple.stackexchange.com/a/114269
  osx-disable-lookup-word-hotkey() {
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 \
             '<dict><key>enabled</key><false/></dict>'
    echo "Command-Control-D hotkey disabled. Please reboot to take effect."
  }

  # Show hidden files in Finder.
  show_files() {
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder "/System/Library/CoreServices/Finder.app"
  }

  # Don't show hidden files in Finder.
  hide_files() {
    defaults write com.apple.finder AppleShowAllFiles NO
    killall Finder "/System/Library/CoreServices/Finder.app"
  }

  # Power management
  alias pm-hibernate="sudo pmset -a hibernatemode 25"
  alias pm-safesleep="sudo pmset -a hibernatemode 3"
  alias pm-sleep="sudo pmset -a hibernatemode 0"

  hibernate() {
    sudo pmset -a hibernatemode 25
    sudo pmset sleepnow
  }
fi
