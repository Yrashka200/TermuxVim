#!/bin/bash
MODULES_DIR="$HOME/.local/share/termuxide/modules"
mkdir -p "$MODULES_DIR"
install_module() {
  local module=$1
  local script="modules/$module/install.sh"
  if [ -f "$script" ]; then
    echo -e "${GREEN}Installing module: $module${NC}"
    bash "$script"
    touch "$MODULES_DIR/$module.installed"
  else
    echo -e "${RED}Module not found: $module${NC}"
  fi
}
remove_module() {
  local module=$1
  echo -e "${YELLOW}Removing module: $module${NC}"
  rm -f "$MODULES_DIR/$module.installed"
}
list_modules() {
  echo -e "${BLUE}Installed modules:${NC}"
  ls "$MODULES_DIR" 2>/dev/null || echo "No modules installed"
}
update_modules() {
  echo -e "${GREEN}Updating all modules...${NC}"
  for module in $(ls "$MODULES_DIR" 2>/dev/null); do
    echo -e "${YELLOW}Updating $module...${NC}"
    rm -f "$MODULES_DIR/$module"
    install_module "${module%.installed}"
  done
}
if [ "$1" = "install" ]; then
  install_module "$2"
elif [ "$1" = "remove" ]; then
  remove_module "$2"
elif [ "$1" = "list" ]; then
  list_modules
elif [ "$1" = "update" ]; then
  update_modules
fi
