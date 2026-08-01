#!/bin/bash
pkg install -y git
git config --global user.name "TermuxIDE User"
git config --global user.email "user@termux.ide"
git config --global core.editor "hx"
git config --global init.defaultBranch main
git config --global color.ui auto
echo "alias gs='git status'" >>~/.bashrc
echo "alias ga='git add'" >>~/.bashrc
echo "alias gc='git commit'" >>~/.bashrc
echo "alias gp='git push'" >>~/.bashrc
echo "alias gl='git pull'" >>~/.bashrc
