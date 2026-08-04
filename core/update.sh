#!/bin/bash
UPDATE_DIR="$HOME/.local/share/termuxide/update"
VERSION_FILE="$UPDATE_DIR/version"
REPO_URL="https://github.com/Yrashka200/TermuxIDE"
CONFIG_DIR="$HOME/.config/termuxide"
mkdir -p "$UPDATE_DIR"
check_updates() {
    echo -e "${BLUE}Checking for updates...${NC}"
    local current_version=$(cat "$VERSION_FILE" 2>/dev/null || echo "0.0.0")
    local latest_version=$(curl -s "$REPO_URL/raw/main/VERSION" 2>/dev/null || echo "$current_version")
    if [ "$latest_version" != "$current_version" ]; then
        echo -e "${YELLOW}New version available: $latest_version (current: $current_version)${NC}"
        return 0
    else
        echo -e "${GREEN}Already up to date!${NC}"
        return 1
    fi
}
auto_update() {
    echo -e "${GREEN}Updating TermuxIDE...${NC}"
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    git clone --depth 1 "$REPO_URL" . 2>/dev/null
    if [ -d "core" ]; then
        cp -r core/* "$PROJECT_DIR/core/" 2>/dev/null
        cp -r modules/* "$PROJECT_DIR/modules/" 2>/dev/null
        cp -r config/* "$CONFIG_DIR/" 2>/dev/null
        cp installer.sh "$PROJECT_DIR/"
        chmod +x "$PROJECT_DIR"/core/*.sh
        chmod +x "$PROJECT_DIR"/modules/*/install.sh
        chmod +x "$PROJECT_DIR"/modules/lsp/*.sh
        chmod +x "$PROJECT_DIR"/installer.sh
        echo "$(curl -s "$REPO_URL/raw/main/VERSION" 2>/dev/null || echo "1.0.0")" > "$VERSION_FILE"
        echo -e "${GREEN}✅ Update complete!${NC}"
    else
        echo -e "${RED}Update failed!${NC}"
    fi
    cd "$PROJECT_DIR"
    rm -rf "$temp_dir"
}
check_and_update() {
    if check_updates; then
        echo -e "${YELLOW}Update available. Install now? [Y/n]${NC}"
        read -p "> " choice
        if [[ "$choice" != "n" && "$choice" != "N" ]]; then
            auto_update
        fi
    fi
}
if [ "$1" = "check" ]; then
    check_updates
elif [ "$1" = "install" ]; then
    auto_update
elif [ "$1" = "auto" ]; then
    check_and_update
fi
