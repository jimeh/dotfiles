#!/bin/bash
# <bitbar.title>Homebrew Cask Upgrades</bitbar.title>
# <bitbar.version>1.0.0</bitbar.version>
# <bitbar.author>Jim Myhrberg</bitbar.author>
# <bitbar.author.github>jimeh</bitbar.author.github>
# <bitbar.desc>Show outdated Homebrew Cask formula</bitbar.desc>
# <bitbar.image>https://i.imgur.com/VUMVwZM.png</bitbar.image>
# <bitbar.dependencies>bash</bitbar.dependencies>

shopt -s extglob

main() {
  local count
  local formulas
  local current_version
  local new_version

  formulas=()
  current_version=()
  new_version=()

  /usr/local/bin/brew update &> /dev/null

  while read -r line; do
    if [[ "$line" =~ ^(.+)\ \((.+)\)\ !=\ (.*)$ ]]; then
      formulas+=("${BASH_REMATCH[1]}")
      current_version+=("${BASH_REMATCH[2]}")
      new_version+=("${BASH_REMATCH[3]}")
    fi
  done < <(/usr/local/bin/brew cask outdated -v)

  count="${#formulas[@]}"

  echo ":tropical_drink:↑${count} | dropdown=false"
  echo '---'
  echo "$count outdated casks"

  if [ "$count" -gt 0 ]; then
    echo 'Upgrade all casks | terminal=true refresh=true' \
         'bash=/usr/local/bin/brew param1=cask param2=upgrade'
    echo '---'

    echo 'Upgrade:'
    for i in "${!formulas[@]}"; do
      echo "${formulas[$i]}"
      echo "--${current_version[$i]} → ${new_version[$i]} |" \
           "terminal=true refresh=true bash=/usr/local/bin/brew param1=cask" \
           "param2=upgrade param3=${formulas[$i]}"
    done
  fi
}

main "$@"
