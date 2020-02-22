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

install_node_global_packages () {
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
    stylelint
    tslint
    typescript
    typescript-formatter
    uuid-cli
    vscode-css-languageserver-bin
  )

  npm install -g "${packages[@]}"
}
