#!/bin/bash
pkg install -y tmux
mkdir -p ~/.config/tmux
cat >~/.config/tmux/tmux.conf <<'EOF'
set -g default-terminal "screen-256color"
set -g mouse on
set -g status-style bg=black,fg=green
set -g window-style fg=white,bg=black
set -g window-active-style fg=white,bg=black
bind C-c new-window
bind C-n next-window
bind C-p previous-window
bind % split-window -h
bind '"' split-window -v
bind x kill-pane
set -g status-left "[#S] "
set -g status-right "[%Y-%m-%d %H:%M]"
EOF
echo "alias tmux='tmux -f ~/.config/tmux/tmux.conf'" >>~/.bashrc
