#!/bin/bash
EDITOR_TYPE="$1"
case $EDITOR_TYPE in
helix)
  pkg install -y helix
  mkdir -p ~/.config/helix
  cp modules/editor/config/helix/config.toml ~/.config/helix/
  echo "alias hx=helix" >>~/.bashrc
  echo "alias ide='bash core/init.sh start'" >>~/.bashrc
  ;;
micro)
  pkg install -y micro
  echo "alias micro='micro -colorscheme solarized'" >>~/.bashrc
  echo "alias ide='micro'" >>~/.bashrc
  ;;
neovim)
  pkg install -y neovim
  echo "alias vim=nvim" >>~/.bashrc
  echo "alias ide='nvim'" >>~/.bashrc
  ;;
*)
  pkg install -y helix
  mkdir -p ~/.config/helix
  cp modules/editor/config/helix/config.toml ~/.config/helix/
  echo "alias hx=helix" >>~/.bashrc
  echo "alias ide='bash core/init.sh start'" >>~/.bashrc
  ;;
esac
echo -e "${GREEN}Editor installed: $EDITOR_TYPE${NC}"
