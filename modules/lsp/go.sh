#!/bin/bash
pkg install -y golang
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
echo 'export GOPATH="$HOME/go"' >>~/.bashrc
echo 'export PATH="$PATH:$GOPATH/bin"' >>~/.bashrc
echo "LSP_GO=true" >>~/.config/termuxide/lsp.conf
