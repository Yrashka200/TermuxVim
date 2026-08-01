#!/bin/bash
CONFIG_DIR="$HOME/.config/termuxide"
CONFIG_FILE="$CONFIG_DIR/ide.conf"
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    cp config/ide.conf "$CONFIG_FILE"
fi
source "$CONFIG_FILE"
source core/ui.sh
source core/modules.sh
start_ide() {
    clear
    show_banner
    echo -e "${GREEN}Starting TermuxIDE...${NC}"
    if [ "$USE_TMUX" = "true" ]; then
        if ! tmux has-session -t ide 2>/dev/null; then
            tmux new-session -d -s ide
            tmux send-keys -t ide "clear" C-m
            tmux send-keys -t ide "echo 'Welcome to TermuxIDE!'" C-m
            tmux send-keys -t ide "$EDITOR_CMD" C-m
        fi
        tmux attach -t ide
    else
        $EDITOR_CMD
    fi
}
if [ "$1" = "start" ]; then
    start_ide
elif [ "$1" = "config" ]; then
    nano "$CONFIG_FILE"
else
    echo "Usage: ide [start|config]"
fi