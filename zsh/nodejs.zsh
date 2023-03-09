#
# Node.js environment setup.
#

# ==============================================================================
# global node packages
# ==============================================================================

install_node_global_packages() {
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
    yarn
  )

  npm install -g "${npm_packages[@]}"
}
