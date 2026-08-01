#!/bin/bash
EDITOR_TYPE="$1"
echo -e "${GREEN}Setting up $EDITOR_TYPE...${NC}"
case $EDITOR_TYPE in
helix)
  mkdir -p ~/.config/helix
  cp modules/editor/config/helix/config.toml ~/.config/helix/
  ;;
micro)
  mkdir -p ~/.config/micro
  ;;
neovim)
  mkdir -p ~/.config/nvim
  ;;
esac
echo -e "${GREEN}Setup complete${NC}"
