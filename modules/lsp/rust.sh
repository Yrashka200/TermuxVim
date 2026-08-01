#!/bin/bash
pkg install -y rust rust-analyzer
cargo install cargo-tree cargo-edit cargo-watch
rustup component add rust-analyzer
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.bashrc
echo "LSP_RUST=true" >>~/.config/termuxide/lsp.conf
