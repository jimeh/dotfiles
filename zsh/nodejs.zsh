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
  npm install -g \
      appcenter-cli \
      bash-language-server \
      eslint \
      eslint-config-prettier \
      eslint-plugin-prettier \
      eslint_d \
      htmllint-cli \
      httpsnippet \
      javascript-typescript-langserver \
      jsonlint \
      localtunnel \
      markdown-it \
      prettier \
      stylelint \
      tldr \
      tslint \
      typescript \
      typescript-formatter \
      uuid-cli \
      vscode-css-languageserver-bin
}

# Load nvm if it's available
if [ -f "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh"
fi
