#!/bin/bash
pkg install -y golang
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
echo 'export GOPATH="$HOME/go"' >>"$HOME/.bashrc"
echo 'export PATH="$PATH:$GOPATH/bin"' >>"$HOME/.bashrc"
