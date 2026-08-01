#!/bin/bash
echo -e "${GREEN}Installing LSP framework...${NC}"
mkdir -p ~/.local/share/termuxide/lsp
echo "LSP_INSTALLED=true" >~/.config/termuxide/lsp.conf
