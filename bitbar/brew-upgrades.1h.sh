#!/bin/bash
# <bitbar.title>Homebrew Upgrades</bitbar.title>
# <bitbar.version>1.0.0</bitbar.version>
# <bitbar.author>Jim Myhrberg</bitbar.author>
# <bitbar.author.github>jimeh</bitbar.author.github>
# <bitbar.desc>Show outdated Homebrew formula</bitbar.desc>
# <bitbar.image>https://i.imgur.com/bZn3RYs.png</bitbar.image>
# <bitbar.dependencies>bash,comm,grep,printf</bitbar.dependencies>

shopt -s extglob

main() {
  local count
  local pinned
  local pinned_list
  local formulas
  local formulas_list
  local current_version
  local new_version
  local pinned_version
  local pkg

  pinned=()
  formulas=()
  current_version=()
  new_version=()
  pinned_version=()

  /usr/local/bin/brew update &> /dev/null

  while read -r line; do
    pinned+=("$line")
  done < <(/usr/local/bin/brew list --pinned)

  while read -r line; do
    if [[ "$line" =~ ^(.+)\ \((.+)\)\ \<\ (.*)\ \[pinned\ at\ (.*)]$ ]]; then
      formulas+=("${BASH_REMATCH[1]}")
      current_version+=("${BASH_REMATCH[2]}")
      new_version+=("${BASH_REMATCH[3]}")
      pinned_version+=("${BASH_REMATCH[4]}")
    elif [[ "$line" =~ ^(.+)\ \((.+)\)\ \<\ (.*)$ ]]; then
      formulas+=("${BASH_REMATCH[1]}")
      current_version+=("${BASH_REMATCH[2]}")
      new_version+=("${BASH_REMATCH[3]}")
      pinned_version+=("NONE")
    fi
  done < <(/usr/local/bin/brew outdated --verbose)

  pinned_list="$(printf '%s\n' "${pinned[@]}" | sort)"
  formulas_list="$(printf '%s\n' "${formulas[@]}" | sort)"

  count="$(
    comm -13 <(echo "$pinned_list") <(echo "$formulas_list") |
      grep -c '[^[:space:]]'
  )"

  echo ":beer:↑${count} | dropdown=false"
  echo '---'
  if [ "${#pinned[@]}" -gt 0 ]; then
    echo "$count outdated formula (${#pinned[@]} pinned)"
  else
    echo "$count outdated formula"
  fi

  if [ "$count" -gt 0 ]; then
    echo 'Upgrade all formula | terminal=true refresh=true' \
      'bash=/usr/local/bin/brew param1=upgrade'
    echo '---'

    echo 'Upgrade:'
    for i in "${!formulas[@]}"; do
      pkg="${formulas[$i]}"

      if echo "$pinned_list" | grep "${pkg}" > /dev/null; then
        continue
      fi

      echo "$pkg"
      echo "--${current_version[$i]} → ${new_version[$i]} |" \
        "terminal=true refresh=true bash=/usr/local/bin/brew" \
        "param1=upgrade param2=${pkg}"
    done

    if [ "${#pinned[@]}" -gt 0 ]; then
      echo '---'
      echo 'Pinned:'
      for i in "${!formulas[@]}"; do
        pkg="${formulas[$i]}"

        if ! echo "$pinned_list" | grep "${pkg}" > /dev/null; then
          continue
        fi

        echo "$pkg"
        echo "--${pinned_version[$i]} → ${new_version[$i]}"
      done
    fi
  fi
}

main "$@"
