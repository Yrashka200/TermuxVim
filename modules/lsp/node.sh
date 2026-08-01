#!/bin/bash
pkg install -y nodejs npm yarn
npm install -g typescript typescript-language-server vscode-langservers-extracted yaml-language-server bash-language-server prettier eslint
echo "LSP_NODE=true" >>~/.config/termuxide/lsp.conf
