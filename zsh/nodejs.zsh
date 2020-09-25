#
# Node.js environment setup.
#

# ==============================================================================
# nodenv
# ==============================================================================

# install nodenv
zinit ice wait lucid as'program' pick'bin/nodenv' from'gh' \
  atclone'src/configure && make -C src' atpull'%atclone' nocompile'!'
zinit light nodenv/nodenv

# install node-build
zinit ice wait lucid as'program' pick'bin/node-build' from'gh'
zinit light nodenv/node-build

# install nodenv-aliases plugin
zinit ice wait lucid as'program' pick'bin/nodenv-aliases' from'gh'
zinit light nodenv/nodenv-aliases

# install nodenv-each plugin
zinit ice wait lucid as'program' pick'bin/nodenv-each' from'gh'
zinit light nodenv/nodenv-each

# install nodenv-nvmrc plugin
zinit ice wait lucid as'program' pick'bin/nodenv-nvmrc' from'gh'
zinit light ouchxp/nodenv-nvmrc

# install nodenv-package-rehash plugin
zinit ice wait lucid as'program' pick'bin/nodenv-package-*' from'gh'
zinit light nodenv/nodenv-package-rehash

# lazy-load nodenv
nodenv() {
  load-nodenv
  nodenv "$@"
}

_nodenv() {
  load-nodenv
  _nodenv "$@"
}

compctl -K _nodenv nodenv

load-nodenv() {
  unset -f load-nodenv _nodenv nodenv
  eval "$(command nodenv init -)"
}

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
