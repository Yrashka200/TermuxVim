#!/bin/bash
set -e
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
PROJECT_DIR="$(pwd)"
VERSION="1.0.0"
LOG_DIR="$HOME/.local/share/termuxide/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/install.log"
ERROR_LOG="$LOG_DIR/errors.log"
echo "$VERSION" > VERSION
log_info() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[INFO]${NC} $msg"
    echo "[$timestamp] [INFO] $msg" >> "$LOG_FILE"
}
log_error() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[ERROR]${NC} $msg" >&2
    echo "[$timestamp] [ERROR] $msg" >> "$ERROR_LOG"
    echo "[$timestamp] [ERROR] $msg" >> "$LOG_FILE"
}
log_success() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[SUCCESS]${NC} $msg"
    echo "[$timestamp] [SUCCESS] $msg" >> "$LOG_FILE"
}
log_warning() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[WARNING]${NC} $msg"
    echo "[$timestamp] [WARNING] $msg" >> "$LOG_FILE"
}
trap 'log_error "Installation failed at step $STEP"' ERR
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
log_info "Starting TermuxIDE installation v$VERSION"
log_info "Project directory: $PROJECT_DIR"
STEP="system_update"
log_info "[1/6] Updating system packages..."
if ! pkg update -y && pkg upgrade -y; then
    log_error "Failed to update system packages"
    exit 1
fi
log_success "System updated successfully"
STEP="core_dependencies"
log_info "[2/6] Installing core dependencies..."
if ! pkg install -y git curl wget tmux fzf ripgrep fd tree htop openssh termux-api; then
    log_error "Failed to install core dependencies"
    exit 1
fi
log_success "Core dependencies installed"
STEP="editor_selection"
log_info "[3/6] Selecting editor..."
echo -e "${YELLOW}Select editor:${NC}"
echo "  1) Helix (recommended - built-in LSP)"
echo "  2) Micro (lightweight)"
echo "  3) Neovim (powerful)"
echo "  4) Skip"
read -p "Choice [1-4]: " editor_choice
log_info "Editor choice: $editor_choice"
case $editor_choice in
    1) 
        log_info "Installing Helix..."
        if ! bash modules/editor/install.sh helix; then
            log_error "Failed to install Helix"
            exit 1
        fi
        ;;
    2) 
        log_info "Installing Micro..."
        if ! bash modules/editor/install.sh micro; then
            log_error "Failed to install Micro"
            exit 1
        fi
        ;;
    3) 
        log_info "Installing Neovim..."
        if ! bash modules/editor/install.sh neovim; then
            log_error "Failed to install Neovim"
            exit 1
        fi
        ;;
    4) 
        log_warning "Skipping editor installation" 
        ;;
    *) 
        log_info "Default: Installing Helix..."
        bash modules/editor/install.sh helix 
        ;;
esac
log_success "Editor installed"
STEP="language_selection"
log_info "[4/6] Installing language support..."
echo -e "${YELLOW}Install language support:${NC}"
echo "  1) Python"
echo "  2) Node.js"
echo "  3) Go"
echo "  4) Rust"
echo "  5) All"
echo "  6) Skip"
read -p "Enter numbers separated by space: " -a lang_choices
log_info "Language choices: ${lang_choices[@]}"
for choice in "${lang_choices[@]}"; do
    case $choice in
        1) 
            log_info "Installing Python..."
            bash modules/lsp/python.sh || log_error "Python installation failed"
            ;;
        2) 
            log_info "Installing Node.js..."
            bash modules/lsp/node.sh || log_error "Node.js installation failed"
            ;;
        3) 
            log_info "Installing Go..."
            bash modules/lsp/go.sh || log_error "Go installation failed"
            ;;
        4) 
            log_info "Installing Rust..."
            bash modules/lsp/rust.sh || log_error "Rust installation failed"
            ;;
        5)
            log_info "Installing all languages..."
            bash modules/lsp/python.sh || log_error "Python installation failed"
            bash modules/lsp/node.sh || log_error "Node.js installation failed"
            bash modules/lsp/go.sh || log_error "Go installation failed"
            bash modules/lsp/rust.sh || log_error "Rust installation failed"
            break
            ;;
        6) 
            log_warning "Skipping language installation" 
            ;;
        *)
            log_warning "Invalid choice: $choice, skipping"
            ;;
    esac
done
STEP="additional_tools"
log_info "[5/6] Installing additional tools..."
if ! bash modules/tools/install.sh; then
    log_error "Failed to install tools"
    exit 1
fi
if ! bash modules/terminal/install.sh; then
    log_error "Failed to install terminal"
    exit 1
fi
if ! bash modules/git/install.sh; then
    log_error "Failed to install git"
    exit 1
fi
log_success "Additional tools installed"
STEP="configuration"
log_info "[6/6] Generating configuration..."
if ! bash core/config.sh generate; then
    log_error "Failed to generate configuration"
    exit 1
fi
mkdir -p "$HOME/.local/share/termuxide/update"
echo "$VERSION" > "$HOME/.local/share/termuxide/update/version"
echo 'alias ide="bash main.sh"' >> ~/.bashrc
echo 'alias menu="bash main.sh"' >> ~/.bashrc
echo -e "${YELLOW}Do you want TermuxIDE to start automatically when Termux opens? [Y/n]${NC}"
read -p "> " auto_start
if [[ "$auto_start" != "n" && "$auto_start" != "N" ]]; then
    if ! grep -q "bash main.sh" ~/.bashrc; then
        echo '' >> ~/.bashrc
        echo '# TermuxIDE auto-start' >> ~/.bashrc
        echo 'if [ -f "$HOME/TermuxIDE/main.sh" ]; then' >> ~/.bashrc
        echo '    cd ~/TermuxIDE && bash main.sh' >> ~/.bashrc
        echo 'fi' >> ~/.bashrc
        log_success "Auto-start enabled"
    fi
else
    log_info "Auto-start disabled by user"
fi
source ~/.bashrc 2>/dev/null || true
log_success "TermuxIDE v$VERSION installed successfully!"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✅ TermuxIDE v$VERSION installed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}Quick start:${NC}"
echo "  ide       - Open main menu"
echo "  menu      - Open main menu"
echo ""
echo -e "${YELLOW}Commands:${NC}"
echo "  ide start  - Start IDE directly"
echo "  ide config - Edit configuration"
echo "  ide update - Check and install updates"
echo ""
echo -e "${YELLOW}Simple Editor:${NC}"
echo "  sedit <file>  - Edit/create file"
echo "  sopen <file>  - Open and view file"
echo ""
echo -e "${YELLOW}Logs:${NC}"
echo "  View logs: cat ~/.local/share/termuxide/logs/install.log"
echo "  View errors: cat ~/.local/share/termuxide/logs/errors.log"
echo ""
echo -e "${YELLOW}To disable auto-start:${NC}"
echo "  nano ~/.bashrc  # Remove the lines with 'main.sh'"
echo ""
echo -e "${BLUE}Enjoy your custom IDE!${NC}"
