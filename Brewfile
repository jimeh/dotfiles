# rubocop:disable Naming/FileName

#
# Setup
#

hostname = `hostname -s`.strip
cask_args appdir: '/Applications'
tap 'homebrew/cask'
tap 'homebrew/cask-drivers'

#
# Command-Line Tools (Brew)
#

brew 'ack'
brew 'ansible'
brew 'aspell', args: ['with-lang-el', 'with-lang-sv']
brew 'bash'
brew 'bazaar'
brew 'colordiff'
brew 'ctop'
brew 'dep'
brew 'dpkg'
brew 'geckodriver'
brew 'git'
brew 'git-crypt'
brew 'git-standup'
brew 'global', args: ['with-ctags', 'with-pygments']
brew 'go'
brew 'htop'
brew 'httpie'
brew 'jq'
brew 'less'
brew 'lua'
brew 'luarocks'
brew 'mariadb'
brew 'mas'
brew 'mkvtoolnix'
brew 'peco'
brew 'pgformatter'
brew 'postgresql'
brew 'pyenv'
brew 'rbenv'
brew 'rclone'
brew 'readline'
brew 'reattach-to-user-namespace'
brew 'redis'
brew 'ruby-build'
brew 'shellcheck'
brew 'sops'
brew 'source-highlight'
brew 'telnet'
brew 'the_silver_searcher'
brew 'tmux'
brew 'tree'
brew 'watch'
brew 'wget'
brew 'yank'
brew 'yarn'
brew 'zsh'

# Custom taps

tap 'golangci/tap'
brew 'golangci-lint'

tap 'goreleaser/tap'
brew 'goreleaser'

tap 'heroku/brew'
brew 'heroku'

tap 'nektos/tap'
brew 'act'

# sshfs requires osxfuse

cask 'osxfuse'
brew 'sshfs'

#
# Desktop Apps (Cask)
#

# Core Apps
cask '1password'
cask 'aerial'
cask 'alfred'
cask 'appcleaner'
cask 'bartender'
cask 'betterzip'
cask 'daisydisk'
cask 'emacs'
cask 'firefox'
cask 'fluid'
cask 'flux'
cask 'google-chrome'
cask 'gpg-suite'
cask 'hammerspoon'
cask 'iina'
cask 'intel-power-gadget'
cask 'istat-menus'
cask 'iterm2'
cask 'karabiner-elements'
cask 'logitech-gaming-software'
cask 'logitech-options'
cask 'mplayerx'
cask 'name-mangler'
cask 'resolutionator'
cask 'soulver'
cask 'stay'
cask 'ubersicht'
cask 'vlc'

tap 'homebrew/cask-fonts'
cask 'font-menlo-for-powerline'

# Work Apps
cask 'atom'
cask 'bbedit'
cask 'chromedriver'
cask 'cyberduck'
cask 'dash'
cask 'docker'
cask 'fork'
cask 'github'
cask 'google-cloud-sdk'
cask 'insomnia'
cask 'java'
cask 'kaleidoscope'
cask 'licecap'
cask 'microsoft-teams'
cask 'paw'
cask 'postico'
cask 'postman'
cask 'robo-3t'
cask 'rowanj-gitx'
cask 'sequel-pro'
cask 'slack'
cask 'transmit'
cask 'vagrant'
cask 'virtualbox'
cask 'visual-studio-code'

# noct
if hostname == 'noct'
  brew 'ffmpeg', args: [
    'with-chromaprint',
    'with-fdk-aac',
    'with-libass',
    'with-librsvg',
    'with-libsoxr',
    'with-libssh',
    'with-libvidstab',
    'with-openh264',
    'with-openssl',
    'with-rubberband',
    'with-srt',
    'with-tesseract',
    'with-webp'
  ]
  brew 'get_iplayer'

  brew 'kubernetes-cli'
  brew 'kubernetes-helm'

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
  cask 'boom-3d'
  cask 'calibre'
  cask 'chicken'
  cask 'deluge'
  cask 'discord'
  cask 'dropbox'
  cask 'epic-games'
  cask 'evernote'
  cask 'filebot'
  cask 'get-iplayer-automator'
  cask 'gog-galaxy'
  cask 'google-photos-backup-and-sync'
  cask 'hackety-hack'
  cask 'handbrake'
  cask 'irccloud'
  cask 'istumbler'
  cask 'keybase'
  cask 'little-snitch'
  cask 'makemkv'
  cask 'messenger'
  cask 'micro-snitch'
  cask 'mkvtoolnix-app'
  cask 'monodraw'
  cask 'muzzle'
  cask 'omnigraffle'
  cask 'openemu'
  cask 'parallels'
  cask 'peakhour'
  cask 'plex-media-player'
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
  cask 'rclone-browser'
  cask 'ring'
  cask 'scroll-reverser'
  cask 'sixtyforce'
  cask 'skitch'
  cask 'skyfonts'
  cask 'skype'
  cask 'spotify'
  cask 'steam'
  cask 'suspicious-package'
  cask 'teamviewer'
  cask 'trailer'
  cask 'transmission'
  cask 'virtualc64'
  cask 'viscosity'
  cask 'vmware-fusion'
  cask 'vnc-viewer'
  cask 'wavebox'
  cask 'webpquicklook'
  cask 'whatsapp'
  cask 'witgui'
  cask 'xld'

  mas 'Apple Remote Desktop', id: 409_907_375
  mas 'Awaken', id: 404_221_531
  mas 'HTTP Client', id: 418_138_339
  mas 'HiddenMe', id: 467_040_476
  mas 'Medis', id: 1_063_631_769
  mas 'Microsoft Remote Desktop 10', id: 1_295_203_466
  mas 'Pocket', id: 568_494_494
  mas 'Reeder 3', id: 880_001_334
  mas 'Textual 7', id: 1_262_957_439
  mas 'Wire', id: 931_134_707
  mas 'feedly', id: 865_500_966
end

if hostname == 'UAC00013'
  brew 'gnu-getopt'

  mas 'Microsoft Remote Desktop 8', id: 715_768_417
  mas 'Microsoft Remote Desktop 10', id: 1_295_203_466
end

# rubocop:enable Naming/FileName
