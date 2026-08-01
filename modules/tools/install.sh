#!/bin/bash
pkg install -y ranger lf bat exa zoxide
echo "alias ll='exa -la'" >>~/.bashrc
echo "alias tree='tree -C'" >>~/.bashrc
echo "alias cat='bat'" >>~/.bashrc
echo "eval \"\$(zoxide init bash)\"" >>~/.bashrc
echo "alias cd='z'" >>~/.bashrc
