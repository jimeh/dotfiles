# frozen_string_literal: true

#
# Setup
#

hostname = `hostname -s`.strip
cask_args appdir: '/Applications'

tap 'homebrew/cask-versions'

#
# Command-Line Tools (Brew)
#

brew 'ack'
brew 'aspell'
brew 'bash'
brew 'caddy'
brew 'cmake'
brew 'colordiff'
brew 'coreutils'
brew 'efm-langserver'
brew 'fd'
brew 'ffmpeg'
brew 'geckodriver'
brew 'git'
brew 'git-crypt'
brew 'git-delta'
brew 'highlight'
brew 'htop'
brew 'httpie'
brew 'less'
brew 'libvterm'
brew 'libyaml'
brew 'logrotate'
brew 'make'
brew 'mas'
brew 'mosh'
brew 'node'
brew 'pandoc'
brew 'pgformatter'
brew 'pv'
brew 'readline'
brew 'redis'
brew 'source-highlight'
brew 'svn'
brew 'telnet'
brew 'tflint'
brew 'tmux'
brew 'trash'
brew 'tree'
brew 'wget'
brew 'yank'
brew 'zsh'

tap 'MisterTea/et'
brew 'MisterTea/et/et'

#
# Desktop Apps (Cask)
#

# Core Apps
cask '1password'
cask 'alfred'
cask 'appcleaner'
cask 'firefox'
cask 'google-chrome'
cask 'gpg-suite'
cask 'hammerspoon'
cask 'handbrake'
cask 'iina'
cask 'iterm2'
cask 'karabiner-elements'
cask 'microsoft-edge'
cask 'orion'
cask 'resolutionator'
cask 'suspicious-package'
cask 'transmission'
cask 'ubersicht'
cask 'vlc'
cask 'xbar'

# Fonts
tap 'homebrew/cask-fonts'
cask 'font-clear-sans'
cask 'font-menlo-for-powerline'
cask 'font-office-code-pro'
cask 'font-open-sans'
cask 'font-terminus'
cask 'font-ubuntu'
cask 'font-xkcd'

# Work Apps
cask 'bbedit'
cask 'chromedriver'
cask 'cyberduck'
cask 'drawio'
cask 'gitx'
cask 'hex-fiend'
cask 'insomnia'
cask 'keycastr'
cask 'licecap'
cask 'orbstack'
cask 'rapidapi'
cask 'sequel-pro'
cask 'slack'
cask 'utm'
cask 'visual-studio-code-insiders'
cask 'zoom'

# noct
if hostname == 'noct'
  brew 'mariadb'
  cask 'lens'

  brew 'grafana'
  brew 'node_exporter'
  brew 'prometheus'

  tap 'jimeh/macos-battery-exporter'
  brew 'macos-battery-exporter'

  cask '4k-video-downloader'
  cask 'adobe-creative-cloud'
  cask 'aegisub'
  cask 'android-file-transfer'
  cask 'android-platform-tools'
  cask 'audio-hijack'
  cask 'authy'
  cask 'autodmg'
  cask 'avidemux'
  cask 'balenaetcher'
  cask 'bartender'
  cask 'betterzip'
  cask 'calibre'
  cask 'carbon-copy-cloner'
  cask 'daisydisk'
  cask 'discord-ptb'
  cask 'dropshare'
  cask 'element'
  cask 'epic-games'
  cask 'evernote'
  cask 'get-iplayer-automator'
  cask 'gog-galaxy'
  cask 'istat-menus'
  cask 'kaleidoscope2'
  cask 'kapitainsky-rclone-browser'
  cask 'keybase'
  cask 'lastfm'
  cask 'ledger-live'
  cask 'little-snitch'
  cask 'lm-studio'
  cask 'mailplane'
  cask 'makemkv'
  cask 'messenger'
  cask 'mkvtoolnix'
  cask 'monodraw'
  cask 'name-mangler'
  cask 'notion'
  cask 'obsidian'
  cask 'openemu'
  cask 'paparazzi'
  cask 'parallels'
  cask 'plex'
  cask 'pocket-casts'
  cask 'qlcolorcode'
  cask 'qlimagesize'
  cask 'qlmarkdown'
  cask 'qlprettypatch'
  cask 'qlstephen'
  cask 'qlvideo'
  cask 'quicklook-csv'
  cask 'quicklook-json'
  cask 'quicklookapk'
  cask 'raspberry-pi-imager'
  cask 'scroll-reverser'
  cask 'sixtyforce'
  cask 'skype'
  cask 'soulver2'
  cask 'soundsource'
  cask 'spotify'
  cask 'steam'
  cask 'transmit'
  cask 'upscayl'
  cask 'virtualc64'
  cask 'viscosity'
  cask 'vnc-viewer'
  cask 'webpquicklook'
  cask 'whatsapp'
  cask 'xld'

  # Mac App Store Apps
  mas 'Apple Remote Desktop', id: 409_907_375
  mas 'Awaken', id: 404_221_531
  mas 'Bear', id: 1_091_189_122
  mas 'Blackmagic Disk Speed Test', id: 425_264_550
  mas 'Calca', id: 635_758_264
  mas 'ColorSlurp', id: 1_287_239_339
  mas 'Flame', id: 325_206_381
  mas 'GoodNotes 5', id: 1_444_383_602
  mas 'HiddenMe', id: 467_040_476
  mas 'Keepa', id: 1_533_805_339
  mas 'MeetingBar', id: 1_532_419_400
  mas 'Pocket', id: 568_494_494
  mas 'Reeder 3', id: 880_001_334
  mas 'Tailscale', id: 1_475_387_142
  mas 'TestFlight', id: 899_247_664
  mas 'Textual 7', id: 1_262_957_439
  mas 'Things 3', id: 904_280_696
  mas 'feedly', id: 865_500_966

  # Safari Extensions
  mas 'Adguard for Safari', id: 1_440_147_259
  mas 'Cascadea', id: 1_432_182_561
  mas 'Dark Reader for Safari', id: 1_438_243_180
  mas 'Notion Web Clipper', id: 1_559_269_364
  mas 'OctoLinkter', id: 1_549_308_269
  mas 'xSearch for Safari', id: 1_579_902_068
end

# hati
if hostname == 'hati'
  brew 'grafana'
  brew 'influxdb'
  brew 'mariadb'
  brew 'node_exporter'
  brew 'prometheus'

  tap 'int128/kubelogin'
  brew 'kubelogin'

  tap 'jimeh/macos-battery-exporter'
  brew 'macos-battery-exporter'

  cask 'obsidian'
  cask 'setapp'
  cask 'teamspeak-client'

  mas 'MeetingBar', id: 1_532_419_400
  mas 'Tailscale', id: 1_475_387_142
end
