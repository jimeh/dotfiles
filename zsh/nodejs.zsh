#
# Node.js environment setup.
#

# ==============================================================================
# Volta
# ==============================================================================

zinit light-mode wait lucid as'program' from'gh-r' \
  atclone'./volta completions zsh > _volta' atpull'%atclone' \
  for @volta-cli/volta

# ==============================================================================
# aliases
# ==============================================================================

alias no="node"
alias np="npm"

# ==============================================================================
# global node packages
# ==============================================================================

install_node_global_packages() {
  local volta_packages=(
    npm
    npx
    yarn
  )
  local npm_packages=(
    @commitlint/cli
    @commitlint/config-conventional
    @mermaid-js/mermaid-cli
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

  volta install "${volta_packages[@]}" "${npm_packages[@]}"
}
