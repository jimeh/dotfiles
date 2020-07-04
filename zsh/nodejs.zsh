#
# Node.js
#

# Aliases
alias no="node"
alias np="npm"
alias ni="npm install"
alias ngi="npm install -g"
alias cof="coffee"
alias tl="tldr"

install_node_global_packages() {
  local packages=(
    @prettier/plugin-php
    @prettier/plugin-ruby
    @prettier/plugin-xml
    appcenter-cli
    eslint
    eslint-config-prettier
    eslint-plugin-prettier
    eslint_d
    htmllint-cli
    httpsnippet
    javascript-typescript-langserver
    js-beautify
    jsonlint
    localtunnel
    markdown-it
    mermaid.cli
    prettier
    prettier-plugin-toml
    standard-version
    stylelint
    tslint
    typescript
    typescript-formatter
    uuid-cli
    vscode-css-languageserver-bin
  )

  npm install -g "${packages[@]}"
}

if [ -f "$HOME/.nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"

  # If default alias is set, add that Node version's bin direcotry to PATH to
  # ensure CLI tools from npm packages work before nvm is lazy-loaded.
  if [ -s "$NVM_DIR/alias/default" ]; then
    path_prepend "$NVM_DIR/versions/node/$(cat "$NVM_DIR/alias/default")/bin"
  fi

  # lazy-load nvm
  nvm() {
    load-nvm
    nvm "$@"
  }

  _nvm() {
    load-nvm
    _nvm "$@"
  }

  compctl -K _nvm nvm

  load-nvm() {
    unset -f load-nvm nvm _nvm
    source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
  }
fi
