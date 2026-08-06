#!/bin/bash
CONFIG_DIR="$HOME/.config/termuxide"
CONFIG_FILE="$CONFIG_DIR/ide.conf"
source "$CONFIG_FILE" 2>/dev/null
source core/ui.sh 2>/dev/null
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
    echo -e "${GREEN}║  7) Help                                 ║${NC}"
    echo -e "${GREEN}║  8) Exit                                 ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════╝${NC}"
    echo ""
    read -p "Select option [1-8]: " choice
    case $choice in
        1) bash core/init.sh start ;;
        2) bash core/config.sh edit ;;
        3) bash core/update.sh check ;;
        4) install_language ;;
        5) manage_modules ;;
        6) show_system_info ;;
        7) show_help ;;
        8) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; show_main_menu ;;
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
        1) bash modules/lsp/python.sh ;;
        2) bash modules/lsp/node.sh ;;
        3) bash modules/lsp/go.sh ;;
        4) bash modules/lsp/rust.sh ;;
        5) 
            bash modules/lsp/python.sh
            bash modules/lsp/node.sh
            bash modules/lsp/go.sh
            bash modules/lsp/rust.sh
            ;;
        6) show_main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
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
            bash core/modules.sh install "$mod_name"
            ;;
        3)
            read -p "Module name: " mod_name
            bash core/modules.sh remove "$mod_name"
            ;;
        4) show_main_menu ;;
        *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
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
        cat ~/.config/termuxide/lsp.conf | grep LSP_ | sed 's/LSP_//g' | sed 's/=true//g'
    else
        echo "  None installed"
    fi
    echo ""
    echo -e "${YELLOW}Disk Usage:${NC}"
    df -h /data 2>/dev/null | tail -1
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
