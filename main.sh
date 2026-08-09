#!/bin/bash
CONFIG_DIR="$HOME/.config/termuxide"
CONFIG_FILE="$CONFIG_DIR/ide.conf"
source core/logger.sh 2>/dev/null
source "$CONFIG_FILE" 2>/dev/null
source core/ui.sh 2>/dev/null
log_info "TermuxIDE main menu started"
show_main_menu() {
    clear
    show_banner
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║              MAIN MENU                    ║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║  1) Start IDE                            ║${NC}"
    echo -e "${GREEN}║  2) Edit Configuration                   ║${NC}"
    echo -e "${GREEN}║  3) Check for Updates                    ║${NC}"
    echo -e "${GREEN}║  4) Install Language Support             ║${NC}"
    echo -e "${GREEN}║  5) Manage Modules                       ║${NC}"
    echo -e "${GREEN}║  6) Show System Info                     ║${NC}"
    echo -e "${GREEN}║  7) View Logs                            ║${NC}"
    echo -e "${GREEN}║  8) Help                                 ║${NC}"
    echo -e "${GREEN}║  9) Exit                                 ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Select option [1-9]: " choice
    case $choice in
        1) log_info "Starting IDE..."; bash core/init.sh start ;;
        2) log_info "Editing config..."; bash core/config.sh edit ;;
        3) log_info "Checking updates..."; bash core/update.sh check ;;
        4) install_language ;;
        5) manage_modules ;;
        6) show_system_info ;;
        7) show_logs; read -p "Press Enter to continue..."; show_main_menu ;;
        8) show_help; read -p "Press Enter to continue..."; show_main_menu ;;
        9) log_info "Exiting TermuxIDE"; echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) log_error "Invalid option: $choice"; echo -e "${RED}Invalid option!${NC}"; sleep 1; show_main_menu ;;
    esac
}
install_language() {
    clear
    echo -e "${YELLOW}Select language to install:${NC}"
    echo "  1) Python"
    echo "  2) Node.js"
    echo "  3) Go"
    echo "  4) Rust"
    echo "  5) All"
    echo "  6) Back"
    read -p "Choice: " lang_choice
    case $lang_choice in
        1) log_info "Installing Python..."; bash modules/lsp/python.sh || log_error "Python installation failed" ;;
        2) log_info "Installing Node.js..."; bash modules/lsp/node.sh || log_error "Node.js installation failed" ;;
        3) log_info "Installing Go..."; bash modules/lsp/go.sh || log_error "Go installation failed" ;;
        4) log_info "Installing Rust..."; bash modules/lsp/rust.sh || log_error "Rust installation failed" ;;
        5) 
            log_info "Installing all languages..."
            bash modules/lsp/python.sh || log_error "Python installation failed"
            bash modules/lsp/node.sh || log_error "Node.js installation failed"
            bash modules/lsp/go.sh || log_error "Go installation failed"
            bash modules/lsp/rust.sh || log_error "Rust installation failed"
            ;;
        6) show_main_menu ;;
        *) log_error "Invalid language choice: $lang_choice"; echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    show_main_menu
}
manage_modules() {
    clear
    echo -e "${YELLOW}Module Manager:${NC}"
    echo "  1) List installed modules"
    echo "  2) Install module"
    echo "  3) Remove module"
    echo "  4) Back"
    read -p "Choice: " mod_choice
    case $mod_choice in
        1) bash core/modules.sh list ;;
        2) 
            read -p "Module name: " mod_name
            log_info "Installing module: $mod_name"
            bash core/modules.sh install "$mod_name" || log_error "Failed to install module: $mod_name"
            ;;
        3)
            read -p "Module name: " mod_name
            log_info "Removing module: $mod_name"
            bash core/modules.sh remove "$mod_name" || log_error "Failed to remove module: $mod_name"
            ;;
        4) show_main_menu ;;
        *) log_error "Invalid module choice: $mod_choice"; echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
    esac
    show_main_menu
}
show_system_info() {
    clear
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}System Information${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Termux Version:${NC} $(pkg --version 2>/dev/null || echo 'N/A')"
    echo -e "${YELLOW}Editor:${NC} $EDITOR_CMD"
    echo -e "${YELLOW}TMUX:${NC} $USE_TMUX"
    echo -e "${YELLOW}LSP Enabled:${NC} $LSP_ENABLED"
    echo -e "${YELLOW}IDE Version:${NC} $(cat ~/.local/share/termuxide/update/version 2>/dev/null || echo '1.0.0')"
    echo ""
    echo -e "${YELLOW}Installed Languages:${NC}"
    if [ -f ~/.config/termuxide/lsp.conf ]; then
        cat ~/.config/termuxide/lsp.conf | grep LSP_ | sed 's/LSP_//g' | sed 's/=true//g' || echo "  None"
    else
        echo "  None installed"
    fi
    echo ""
    echo -e "${YELLOW}Disk Usage:${NC}"
    df -h /data 2>/dev/null | tail -1 || echo "  N/A"
    echo ""
    echo -e "${YELLOW}Log Files:${NC}"
    echo "  Install log: ~/.local/share/termuxide/logs/install.log"
    echo "  Error log: ~/.local/share/termuxide/logs/errors.log"
    echo "  Total errors: $(wc -l < ~/.local/share/termuxide/logs/errors.log 2>/dev/null || echo '0')"
    echo ""
    read -p "Press Enter to continue..."
    show_main_menu
}
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    bash core/config.sh generate
    source "$CONFIG_FILE"
fi
if [ "$1" = "start" ]; then
    show_main_menu
elif [ "$1" = "help" ]; then
    show_help
else
    show_main_menu
fi
