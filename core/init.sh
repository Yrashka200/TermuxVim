#!/bin/bash
CONFIG_DIR="$HOME/.config/termuxide"
CONFIG_FILE="$CONFIG_DIR/ide.conf"
UPDATE_DIR="$HOME/.local/share/termuxide/update"
VERSION_FILE="$UPDATE_DIR/version"
mkdir -p "$CONFIG_DIR" "$UPDATE_DIR"
if [ ! -f "$CONFIG_FILE" ]; then
    cp config/ide.conf "$CONFIG_FILE"
fi
if [ ! -f "$VERSION_FILE" ]; then
    echo "1.0.0" > "$VERSION_FILE"
fi
source "$CONFIG_FILE"
source core/ui.sh
source core/modules.sh
source core/update.sh
start_ide() {
    clear
    show_banner
    if [ "$AUTO_CHECK_UPDATE" = "true" ]; then
        check_and_update
    fi
    show_status
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
elif [ "$1" = "update" ]; then
    auto_update
elif [ "$1" = "check" ]; then
    check_updates
elif [ "$1" = "help" ]; then
    show_help
else
    echo "Usage: ide [start|config|update|check|help]"
fi
