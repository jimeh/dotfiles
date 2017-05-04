#
# Caskroom related stuff.
#

bootstrap_caskroom() {
  local pkgs=(
    adium-beta
    aerial
    alfred
    android-file-transfer
    appcleaner
    atom
    audio-hijack
    autodmg
    bartender
    betterzip
    bowtie
    calibre
    carbon-copy-cloner
    chicken
    cloudup
    daisydisk
    deluge
    discord
    docker-beta
    dropbox
    ethereum-wallet
    filebot
    firefox
    fluid
    flux
    github-desktop
    gog-galaxy
    google-cloud-sdk
    google-chrome
    gpgtools
    hackety-hack
    handbrake
    insomnia
    irccloud
    istat-menus
    istumbler
    iterm2
    java
    karabiner-elements
    keybase
    licecap
    little-snitch
    logitech-options
    mailplane
    makemkv
    messenger
    micro-snitch
    mist
    moom
    mplayerx
    omnigraffle
    openemu
    parallels-desktop
    paw
    plex-media-player
    postman
    resolutionator
    ring
    screenhero
    sequel-pro
    sixtyforce
    skype
    spotify
    stay
    synology-assistant
    teamviewer
    transmission
    ubersicht
    unetbootin
    virtualbox
    virtualc64
    viscosity
    visual-studio-code
    vlc
    vmware-fusion
    witgui
    wmail
    xld
    yakyak
    ynab
  )

  local installed=( $(brew cask list) )

  for pkg in ${pkgs[@]}; do
    local base=$(echo $pkg | awk '{print $1}')
    local found=""

    for i in ${installed[@]}; do
      if [[ "$base" == "$i" ]]; then
        found=1
      fi
    done

    if [ -z "$found" ]; then
      brew cask install "${pkg[@]}"
    fi
  done
}
