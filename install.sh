#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
VIM_CONFIG_DIR="$HOME/.config/nvim"
PROJECT_DIR="$(pwd)"
LANGUAGES_DIR="$PROJECT_DIR/languages"
echo -e "${BLUE}"
cat << "EOF"
  _______            _  __     ___ ___ 
 |__   __|          | |/ /    |_ _/ _ \
    | |_ __ ___  ___| ' /_____ | | | | |
    | | '__/ _ \/ _ \  <______| | |_| |
    | | | |  __/  __/ . \     | |\___/ 
    |_|_|  \___|\___|_|\_\    |___|    
    IDE-like environment for Termux
EOF
echo -e "${NC}"
echo -e "${GREEN}[1/6] Updating system packages...${NC}"
pkg update -y && pkg upgrade -y
echo -e "${GREEN}[2/6] Installing core dependencies...${NC}"
pkg install -y neovim git curl wget python python-pip nodejs npm ripgrep fd unzip tree htop openssh termux-api
echo -e "${GREEN}[3/6] Select programming languages to install:${NC}"
echo -e "${YELLOW}Available languages:${NC}"
echo "  1) Python (Default)"
echo "  2) Node.js/JavaScript"
echo "  3) Go"
echo "  4) Rust"
echo "  5) Java"
echo "  6) All languages"
echo "  7) Skip (install manually later)"
echo ""
read -p "Enter numbers separated by space (e.g., 1 2 3): " -a selections
install_language() {
    local lang=$1
    local script="$LANGUAGES_DIR/${lang}.sh"
    if [ -f "$script" ]; then
        echo -e "${GREEN}Installing $lang...${NC}"
        bash "$script"
    else
        echo -e "${RED}Language script not found: $lang${NC}"
    fi
}
if [ ${#selections[@]} -eq 0 ]; then
    selections=(1)
fi
for selection in "${selections[@]}"; do
    case $selection in
        1) install_language "python" ;;
        2) install_language "nodejs" ;;
        3) install_language "go" ;;
        4) install_language "rust" ;;
        5) install_language "java" ;;
        6) 
            install_language "python"
            install_language "nodejs"
            install_language "go"
            install_language "rust"
            install_language "java"
            break
            ;;
        7) echo -e "${YELLOW}Skipping language installation${NC}" ;;
        *) echo -e "${RED}Invalid option: $selection${NC}" ;;
    esac
done
echo -e "${GREEN}[4/6] Setting up Neovim configuration...${NC}"
if [ -d "$VIM_CONFIG_DIR" ]; then
    echo -e "${YELLOW}Backing up existing Neovim config...${NC}"
    mv "$VIM_CONFIG_DIR" "$VIM_CONFIG_DIR.bak.$(date +%s)"
fi
mkdir -p "$VIM_CONFIG_DIR"
cp -r "$PROJECT_DIR/config/"* "$VIM_CONFIG_DIR/"
echo -e "${GREEN}[5/6] Installing vim-plug...${NC}"
curl -fLo "$VIM_CONFIG_DIR/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo -e "${GREEN}Installing Neovim plugins...${NC}"
nvim --headless -c 'PlugInstall' -c 'qa' || true
echo -e "${GREEN}[6/6] Installing LSP servers...${NC}"
if command -v pip &> /dev/null; then
    pip install --upgrade pip
    pip install python-lsp-server pylsp-mypy pyls-isort pyls-black
fi
if command -v npm &> /dev/null; then
    npm install -g typescript typescript-language-server \
        vscode-langservers-extracted \
        yaml-language-server \
        bash-language-server
fi
echo -e "${GREEN}Creating aliases...${NC}"
echo 'alias vim="nvim"' >> "$HOME/.bashrc"
echo 'alias vi="nvim"' >> "$HOME/.bashrc"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ TermuxVim installed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Quick start:${NC}"
echo "  nvim .          - Open current directory"
echo "  nvim file.py    - Edit Python file"
echo ""
echo -e "${YELLOW}Key bindings:${NC}"
echo "  <leader>ff      - Find files"
echo "  <leader>fg      - Live grep"
echo "  <leader>e       - File explorer"
echo "  <leader>l       - LSP diagnostics"
echo ""
echo -e "${YELLOW}To customize:${NC}"
echo "  Edit ~/.config/nvim/init.vim"
echo ""
echo -e "${BLUE}Made with ❤️ for mobile development${NC}"
