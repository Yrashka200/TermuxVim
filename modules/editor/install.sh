#!/bin/bash
EDITOR_TYPE="$1"
case $EDITOR_TYPE in
    helix)
        pkg install -y helix
        mkdir -p ~/.config/helix
        cp modules/editor/config/helix/config.toml ~/.config/helix/
        echo "alias hx=helix" >> ~/.bashrc
        echo "alias ide='bash main.sh'" >> ~/.bashrc
        ;;
    micro)
        pkg install -y micro
        echo "alias micro='micro -colorscheme solarized'" >> ~/.bashrc
        echo "alias ide='bash main.sh'" >> ~/.bashrc
        ;;
    neovim)
        pkg install -y neovim
        echo "alias vim=nvim" >> ~/.bashrc
        echo "alias ide='bash main.sh'" >> ~/.bashrc
        ;;
    *)
        pkg install -y helix
        mkdir -p ~/.config/helix
        cp modules/editor/config/helix/config.toml ~/.config/helix/
        echo "alias hx=helix" >> ~/.bashrc
        echo "alias ide='bash main.sh'" >> ~/.bashrc
        ;;
esac
chmod +x modules/editor/simple_editor.sh
echo "alias sedit='bash modules/editor/simple_editor.sh edit'" >> ~/.bashrc
echo "alias sopen='bash modules/editor/simple_editor.sh open'" >> ~/.bashrc
echo -e "${GREEN}Editor installed: $EDITOR_TYPE${NC}"
echo -e "${GREEN}Simple Editor commands:${NC}"
echo "  sedit <file>  - Edit/create file"
echo "  sopen <file>  - Open and view file"
