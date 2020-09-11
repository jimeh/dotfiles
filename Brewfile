# frozen_string_literal: true

#
# Setup
#

hostname = `hostname -s`.strip
cask_args appdir: '/Applications'

tap 'homebrew/cask'
tap 'homebrew/cask-drivers'
tap 'homebrew/cask-versions'

#
# Command-Line Tools (Brew)
#

brew 'ack'
brew 'aspell'
brew 'bash'
brew 'colordiff'
brew 'coreutils'
brew 'ctop'
brew 'geckodriver'
brew 'git'
brew 'git-crypt'
brew 'go'
brew 'goreleaser'
brew 'hadolint'
brew 'hey'
brew 'highlight'
brew 'htop'
brew 'httpie'
brew 'jq'
brew 'less'
brew 'logrotate'
brew 'lua'
brew 'luarocks'
brew 'mas'
brew 'mosh', args: ['HEAD']
brew 'node'
brew 'pandoc'
brew 'peco'
brew 'pgformatter'
brew 'pyenv'
brew 'rbenv'
brew 'rclone'
brew 'readline'
brew 'redis'
brew 'ripgrep'
brew 'rustup-init'
brew 'shellcheck'
brew 'source-highlight'
brew 'svn'
brew 'telnet'
brew 'terraform'
brew 'the_silver_searcher'
brew 'tldr'
brew 'tmux'
brew 'tree'
brew 'watch'
brew 'wget'
brew 'yank'
brew 'yarn'
brew 'zsh'

tap 'heroku/brew'
brew 'heroku'

# node.js version manager
tap 'nodenv/nodenv'
brew 'nodenv'
brew 'nodenv-aliases'
brew 'nodenv-each'
brew 'nodenv-nvmrc'
brew 'nodenv-package-rehash'

# sshfs requires osxfuse
cask 'osxfuse'
brew 'sshfs'

#
# Desktop Apps (Cask)
#

# Core Apps
cask '1password'
cask 'alfred'
cask 'appcleaner'
cask 'bartender'
cask 'betterzip'
cask 'bitbar'
cask 'daisydisk'
cask 'firefox'
cask 'fluid'
cask 'google-chrome'
cask 'gpg-suite'
cask 'hammerspoon'
cask 'iina'
cask 'intel-power-gadget'
cask 'istat-menus'
cask 'iterm2'
cask 'karabiner-elements'
cask 'logitech-options'
cask 'mplayerx'
cask 'name-mangler'
cask 'resolutionator'
cask 'soulver2'
cask 'stay'
cask 'ubersicht'
cask 'vlc'

# Fonts
tap 'homebrew/cask-fonts'
cask 'font-anonymice-powerline'
cask 'font-clear-sans'
cask 'font-dejavu-sans-mono-for-powerline'
cask 'font-droid-sans-mono-for-powerline'
cask 'font-fira-mono-for-powerline'
cask 'font-fontawesome'
cask 'font-inconsolata-dz-for-powerline'
cask 'font-inconsolata-for-powerline'
cask 'font-inconsolata-for-powerline-bold'
cask 'font-menlo-for-powerline'
cask 'font-meslo-for-powerline'
cask 'font-office-code-pro'
cask 'font-open-sans'
cask 'font-open-sans-condensed'
cask 'font-source-code-pro-for-powerline'
cask 'font-terminus'
cask 'font-ubuntu'
cask 'font-ubuntu-mono-derivative-powerline'
cask 'font-xkcd'

# Work Apps
cask 'bbedit'
cask 'chromedriver'
cask 'cyberduck'
cask 'dash'
cask 'docker'
cask 'drawio'
cask 'fork'
cask 'google-cloud-sdk'
cask 'hex-fiend'
cask 'insomnia'
cask 'insomnia-designer'
cask 'java'
cask 'kaleidoscope'
cask 'licecap'
cask 'paw'
cask 'postico'
cask 'robo-3t'
cask 'sequel-pro'
cask 'slack'
cask 'transmit'
cask 'vagrant'
cask 'virtualbox'
cask 'visual-studio-code'

# noct
if hostname == 'noct'
  brew 'ffmpeg', args: %w[
    with-fdk-aac
    with-libass
    with-librsvg
    with-libsoxr
    with-libssh
    with-libvidstab
    with-openh264
    with-openssl
    with-rubberband
    with-srt
    with-tesseract
    with-webp
  ]
  brew 'get_iplayer'

  brew 'kubernetes-cli'
  brew 'kubernetes-helm'
  brew 'mariadb'

  brew 'grafana'
  brew 'node_exporter'
  brew 'prometheus'

  cask '4k-video-downloader'
  cask 'adguard'
  cask 'adobe-creative-cloud'
  cask 'aegisub'
  cask 'android-file-transfer'
  cask 'android-platform-tools'
  cask 'audio-hijack'
  cask 'authy'
  cask 'autodmg'
  cask 'avidemux'
  cask 'balenaetcher'
  cask 'boom-3d'
  cask 'calibre'
  cask 'deluge'
  cask 'discord'
  cask 'dropbox'
  cask 'dropshare'
  cask 'epic-games'
  cask 'evernote'
  cask 'get-iplayer-automator'
  cask 'gog-galaxy'
  cask 'handbrake'
  cask 'hey'
  cask 'istumbler'
  cask 'kapitainsky-rclone-browser'
  cask 'keybase'
  cask 'little-snitch'
  cask 'makemkv'
  cask 'messenger-unofficial'
  cask 'mkvtoolnix'
  cask 'monodraw'
  cask 'mullvadvpn'
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
  cask 'scroll-reverser'
  cask 'sixtyforce'
  cask 'skype'
  cask 'spotify'
  cask 'steam'
  cask 'suspicious-package'
  cask 'teamspeak-client'
  cask 'teamviewer'
  cask 'transmission'
  cask 'virtualc64'
  cask 'viscosity'
  cask 'vmware-fusion'
  cask 'vnc-viewer'
  cask 'webpquicklook'
  cask 'whatsapp'
  cask 'xld'
  cask 'zoomus'

  # Mac App Store Apps
  mas 'Apple Remote Desktop', id: 409_907_375
  mas 'Awaken', id: 404_221_531
  mas 'Bear', id: 1_091_189_122
  mas 'Blackmagic Disk Speed Test', id: 425_264_550
  mas 'GoodNotes 5', id: 1_444_383_602
  mas 'HTTP Client', id: 418_138_339
  mas 'HiddenMe', id: 467_040_476
  mas 'Kiwi for Gmail Lite', id: 1_006_184_923
  mas 'Medis', id: 1_063_631_769
  mas 'Microsoft Remote Desktop 10', id: 1_295_203_466
  mas 'MindNode', id: 1_289_197_285
  mas 'Pocket', id: 568_494_494
  mas 'Reeder 3', id: 880_001_334
  mas 'Textual 7', id: 1_262_957_439
  mas 'Things 3', id: 904_280_696
  mas 'Twitter', id: 1_482_454_543
  mas 'WireGuard', id: 1_451_685_025
  mas 'feedly', id: 865_500_966

  # Safari Extensions
  mas 'Cascadea', id: 1_432_182_561
  mas 'Evernote Web Clipper', id: 1_481_669_779
  mas 'Octotree Pro', id: 1_457_450_145
  mas 'Save to Pocket', id: 1_477_385_213
end
