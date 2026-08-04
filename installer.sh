#!/bin/bash
set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
PROJECT_DIR="$(pwd)"
VERSION="1.0.0"
echo "$VERSION" > VERSION
echo -e "${BLUE}"
cat << "EOF"
  _______            _  __     ___ ___
 |__   __|          | |/ /    |_ _/ _ \
    | |_ __ ___  ___| ' /_____ | | | | |
    | | '__/ _ \/ _ \  <______| | |_| |
    | | | |  __/  __/ . \     | |\___/
    |_|_|  \___|\___|_|\_\    |___|
    TermuxIDE - Custom IDE System
    Version 1.0.0
EOF
echo -e "${NC}"
echo -e "${GREEN}[1/6] Updating system...${NC}"
pkg update -y && pkg upgrade -y
echo -e "${GREEN}[2/6] Installing core dependencies...${NC}"
pkg install -y git curl wget tmux fzf ripgrep fd tree htop openssh termux-api
echo -e "${GREEN}[3/6] Select editor:${NC}"
echo "  1) Helix (recommended - built-in LSP)"
echo "  2) Micro (lightweight)"
echo "  3) Neovim (powerful)"
echo "  4) Skip"
read -p "Choice [1-4]: " editor_choice
case $editor_choice in
    1) bash modules/editor/install.sh helix ;;
    2) bash modules/editor/install.sh micro ;;
    3) bash modules/editor/install.sh neovim ;;
    4) echo -e "${YELLOW}Skipping editor${NC}" ;;
    *) bash modules/editor/install.sh helix ;;
esac
echo -e "${GREEN}[4/6] Install language support:${NC}"
echo "  1) Python"
echo "  2) Node.js"
echo "  3) Go"
echo "  4) Rust"
echo "  5) All"
echo "  6) Skip"
read -p "Enter numbers separated by space: " -a lang_choices
for choice in "${lang_choices[@]}"; do
    case $choice in
        1) bash modules/lsp/python.sh ;;
        2) bash modules/lsp/node.sh ;;
        3) bash modules/lsp/go.sh ;;
        4) bash modules/lsp/rust.sh ;;
        5)
            bash modules/lsp/python.sh
            bash modules/lsp/node.sh
            bash modules/lsp/go.sh
            bash modules/lsp/rust.sh
            break
            ;;
        6) echo -e "${YELLOW}Skipping languages${NC}" ;;
    esac
done
echo -e "${GREEN}[5/6] Installing additional tools...${NC}"
bash modules/tools/install.sh
bash modules/terminal/install.sh
bash modules/git/install.sh
echo -e "${GREEN}[6/6] Generating configuration...${NC}"
bash core/config.sh generate
mkdir -p "$HOME/.local/share/termuxide/update"
echo "$VERSION" > "$HOME/.local/share/termuxide/update/version"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ TermuxIDE v$VERSION installed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Quick start:${NC}"
echo "  ide start   - Start IDE environment"
echo "  ide update  - Check and install updates"
echo "  ide check   - Check for updates only"
echo "  ide config  - Edit configuration"
echo ""
echo -e "${YELLOW}Auto-update:${NC}"
echo "  Set AUTO_CHECK_UPDATE=false in ~/.config/termuxide/ide.conf to disable"
echo ""
echo -e "${BLUE}Enjoy your custom IDE!${NC}"
