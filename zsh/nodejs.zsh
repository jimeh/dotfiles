#
# Node.js environment setup.
#

# ==============================================================================
# Volta
# ==============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
  if [[ "$(uname -m)" == "arm64" ]]; then
    zinit_volta_bpick='*macos-aarch64*'
  else
    zinit_volta_bpick='*macos.tar*'
  fi
fi

zinit ice wait lucid as'program' from'gh-r' bpick"$zinit_volta_bpick" \
  atclone'./volta completions zsh > _volta' atpull'%atclone'
zinit light volta-cli/volta

# ==============================================================================
# aliases
# ==============================================================================

alias no="node"
alias np="npm"
alias ni="npm install"
alias ngi="npm install -g"
alias cof="coffee"

# ==============================================================================
# global node packages
# ==============================================================================

install_node_global_packages() {
  local packages=(
    npm
    npx
    yarn
    @commitlint/cli
    @commitlint/config-conventional
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
    typescript-language-server
    uuid-cli
    vscode-css-languageserver-bin
    vscode-json-languageserver
    yaml-language-server
  )

  volta install "${packages[@]}"
}
