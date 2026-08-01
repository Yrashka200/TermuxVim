#!/bin/bash
show_banner() {
  clear
  echo -e "${BLUE}"
  cat <<"EOF"
╔═══════════════════════════════════════════╗
║                                           ║
║  ████████╗███████╗██████╗ ███╗   ███╗██╗ ██████╗
║  ╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║██╔═══╝
║     ██║   █████╗  ██████╔╝██╔████╔██║██║██║  ██╗
║     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║██║  ╚╝
║     ██║   ███████╗██║  ██║██║ ╚═╝ ██║██║╚██████╗
║     ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝ ╚═════╝
║                                           ║
║  ██████╗ ██╗   ██╗██╗     ███████╗██████╗
║  ██╔══██╗██║   ██║██║     ██╔════╝██╔══██╗
║  ██████╔╝██║   ██║██║     █████╗  ██████╔╝
║  ██╔══██╗██║   ██║██║     ██╔══╝  ██╔══██╗
║  ██████╔╝╚██████╔╝███████╗███████╗██║  ██║
║  ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
║                                           ║
╚═══════════════════════════════════════════╝
EOF
  echo -e "${NC}"
}
show_status() {
  echo -e "${GREEN}┌─────────────────────────────────────────────┐${NC}"
  echo -e "${GREEN}│  $(date '+%Y-%m-%d %H:%M:%S')                          │${NC}"
  echo -e "${GREEN}│  Session: $(tmux display -t ide -p '#S' 2>/dev/null || echo 'N/A')      │${NC}"
  echo -e "${GREEN}│  Windows: $(tmux list-windows -t ide 2>/dev/null | wc -l || echo '0')           │${NC}"
  echo -e "${GREEN}└─────────────────────────────────────────────┘${NC}"
}
show_help() {
  echo -e "${YELLOW}Available commands:${NC}"
  echo "  ide start    - Start IDE environment"
  echo "  ide config   - Edit configuration"
  echo "  ide help     - Show this help"
  echo ""
  echo -e "${YELLOW}Tmux shortcuts:${NC}"
  echo "  Ctrl+b + c   - New window"
  echo "  Ctrl+b + n   - Next window"
  echo "  Ctrl+b + p   - Previous window"
  echo "  Ctrl+b + %   - Split vertical"
  echo "  Ctrl+b + \"   - Split horizontal"
  echo "  Ctrl+b + x   - Close pane"
}
