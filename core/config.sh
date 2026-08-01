#!/bin/bash
CONFIG_DIR="$HOME/.config/termuxide"
CONFIG_FILE="$CONFIG_DIR/ide.conf"
KEYBINDINGS_FILE="$CONFIG_DIR/keybindings.conf"
mkdir -p "$CONFIG_DIR"
generate_config() {
  cat >"$CONFIG_FILE" <<'EOF'
EDITOR="helix"
EDITOR_CMD="hx"
USE_TMUX="true"
TMUX_SESSION="ide"
THEME="default"
LSP_ENABLED="true"
AUTO_SAVE="true"
TAB_SIZE="4"
EOF
  cat >"$KEYBINDINGS_FILE" <<'EOF'
# IDE Keybindings
# Editor: Ctrl+s - Save
# Editor: Ctrl+q - Quit
# Tmux: Ctrl+b + c - New window
# Tmux: Ctrl+b + n - Next window
# Tmux: Ctrl+b + p - Previous window
# Tmux: Ctrl+b + % - Split vertical
# Tmux: Ctrl+b + " - Split horizontal
# Tmux: Ctrl+b + x - Close pane
EOF
  echo -e "${GREEN}Config generated at $CONFIG_DIR${NC}"
}
load_config() {
  if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
  else
    generate_config
    source "$CONFIG_FILE"
  fi
}
if [ "$1" = "generate" ]; then
  generate_config
elif [ "$1" = "load" ]; then
  load_config
elif [ "$1" = "edit" ]; then
  nano "$CONFIG_FILE"
fi
