#!/bin/bash
EDITOR_DIR="$HOME/.local/share/termuxide/simple_editor"
mkdir -p "$EDITOR_DIR"
CURRENT_FILE=""
show_help() {
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Simple Code Editor - Commands${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}File operations:${NC}"
    echo "  :open <file>   - Open file"
    echo "  :new <file>    - Create new file"
    echo "  :save          - Save current file"
    echo "  :saveas <file> - Save as new file"
    echo "  :close         - Close current file"
    echo "  :info          - Show file info"
    echo ""
    echo -e "${YELLOW}Editing:${NC}"
    echo "  :line <num>    - Go to line number"
    echo "  :find <text>   - Find text"
    echo "  :replace <old> <new> - Replace text"
    echo "  :insert <text> - Insert text at cursor"
    echo "  :delete <num>  - Delete line"
    echo "  :clear         - Clear all content"
    echo ""
    echo -e "${YELLOW}System:${NC}"
    echo "  :help          - Show this help"
    echo "  :exit          - Exit editor"
    echo "  :saveexit      - Save and exit"
    echo ""
    echo -e "${YELLOW}Shortcuts:${NC}"
    echo "  Ctrl+S         - Save"
    echo "  Ctrl+Q         - Quit"
    echo "  Ctrl+O         - Open file"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
}
save_file() {
    local file="$1"
    if [ -z "$file" ]; then
        file="$CURRENT_FILE"
    fi
    if [ -z "$file" ]; then
        echo -e "${RED}No file open. Use :saveas <file>${NC}"
        return 1
    fi
    cat > "$file"
    echo -e "${GREEN}File saved: $file${NC}"
    CURRENT_FILE="$file"
    return 0
}
open_file() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo -e "${YELLOW}File not found. Create new? [y/N]${NC}"
        read -r create
        if [[ "$create" != "y" && "$create" != "Y" ]]; then
            return 1
        fi
        touch "$file"
    fi
    CURRENT_FILE="$file"
    echo -e "${GREEN}Opened: $file${NC}"
    cat "$file"
    echo ""
    echo -e "${YELLOW}Type :help for commands${NC}"
    return 0
}
edit_file() {
    local file="$1"
    if [ -z "$file" ]; then
        file="$EDITOR_DIR/temp_$(date +%s).txt"
    fi
    if [ ! -f "$file" ]; then
        touch "$file"
    fi
    CURRENT_FILE="$file"
    echo -e "${GREEN}Editing: $file${NC}"
    echo -e "${YELLOW}Type :help for commands, :saveexit to save and quit${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""
    local content=$(cat "$file")
    if [ -n "$content" ]; then
        echo "$content"
    else
        echo -e "${YELLOW}(empty file)${NC}"
    fi
    echo ""
    while true; do
        echo -e "${BLUE}┌─[$file]${NC}"
        read -p "> " input
        case "$input" in
            :help)
                show_help
                ;;
            :open)
                echo -e "${YELLOW}Enter filename:${NC}"
                read -r new_file
                open_file "$new_file"
                echo ""
                cat "$CURRENT_FILE" 2>/dev/null
                echo ""
                ;;
            :open\ *)
                open_file "${input#:open }"
                echo ""
                cat "$CURRENT_FILE" 2>/dev/null
                echo ""
                ;;
            :new)
                echo -e "${YELLOW}Enter filename:${NC}"
                read -r new_file
                touch "$new_file"
                CURRENT_FILE="$new_file"
                echo -e "${GREEN}Created: $new_file${NC}"
                echo ""
                ;;
            :new\ *)
                local new_file="${input#:new }"
                touch "$new_file"
                CURRENT_FILE="$new_file"
                echo -e "${GREEN}Created: $new_file${NC}"
                echo ""
                ;;
            :save)
                save_file "$CURRENT_FILE"
                echo ""
                ;;
            :saveas)
                echo -e "${YELLOW}Enter filename:${NC}"
                read -r new_file
                save_file "$new_file"
                echo ""
                ;;
            :saveas\ *)
                save_file "${input#:saveas }"
                echo ""
                ;;
            :close)
                CURRENT_FILE=""
                echo -e "${YELLOW}File closed${NC}"
                echo ""
                ;;
            :info)
                if [ -n "$CURRENT_FILE" ]; then
                    echo -e "${YELLOW}File:${NC} $CURRENT_FILE"
                    echo -e "${YELLOW}Lines:${NC} $(wc -l < "$CURRENT_FILE")"
                    echo -e "${YELLOW}Words:${NC} $(wc -w < "$CURRENT_FILE")"
                    echo -e "${YELLOW}Size:${NC} $(wc -c < "$CURRENT_FILE") bytes"
                else
                    echo -e "${YELLOW}No file open${NC}"
                fi
                echo ""
                ;;
            :line)
                echo -e "${YELLOW}Enter line number:${NC}"
                read -r line_num
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -n "${line_num}p" "$CURRENT_FILE"
                fi
                echo ""
                ;;
            :line\ *)
                local line_num="${input#:line }"
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -n "${line_num}p" "$CURRENT_FILE"
                fi
                echo ""
                ;;
            :find)
                echo -e "${YELLOW}Enter text to find:${NC}"
                read -r search
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    grep -n "$search" "$CURRENT_FILE" || echo -e "${YELLOW}Not found${NC}"
                fi
                echo ""
                ;;
            :find\ *)
                local search="${input#:find }"
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    grep -n "$search" "$CURRENT_FILE" || echo -e "${YELLOW}Not found${NC}"
                fi
                echo ""
                ;;
            :replace)
                echo -e "${YELLOW}Enter text to find:${NC}"
                read -r search
                echo -e "${YELLOW}Enter replacement:${NC}"
                read -r replace
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -i "s/$search/$replace/g" "$CURRENT_FILE"
                    echo -e "${GREEN}Replaced all occurrences${NC}"
                fi
                echo ""
                ;;
            :replace\ *)
                local args="${input#:replace }"
                local search="${args% *}"
                local replace="${args#* }"
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -i "s/$search/$replace/g" "$CURRENT_FILE"
                    echo -e "${GREEN}Replaced all occurrences${NC}"
                fi
                echo ""
                ;;
            :insert)
                echo -e "${YELLOW}Enter text to insert:${NC}"
                read -r text
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    echo "$text" >> "$CURRENT_FILE"
                    echo -e "${GREEN}Text inserted${NC}"
                fi
                echo ""
                ;;
            :insert\ *)
                local text="${input#:insert }"
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    echo "$text" >> "$CURRENT_FILE"
                    echo -e "${GREEN}Text inserted${NC}"
                fi
                echo ""
                ;;
            :delete)
                echo -e "${YELLOW}Enter line number to delete:${NC}"
                read -r line_num
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -i "${line_num}d" "$CURRENT_FILE"
                    echo -e "${GREEN}Line $line_num deleted${NC}"
                fi
                echo ""
                ;;
            :delete\ *)
                local line_num="${input#:delete }"
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    sed -i "${line_num}d" "$CURRENT_FILE"
                    echo -e "${GREEN}Line $line_num deleted${NC}"
                fi
                echo ""
                ;;
            :clear)
                echo -e "${RED}Clear all content? [y/N]${NC}"
                read -r confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    > "$CURRENT_FILE"
                    echo -e "${GREEN}File cleared${NC}"
                fi
                echo ""
                ;;
            :view)
                if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                    cat "$CURRENT_FILE"
                else
                    echo -e "${YELLOW}No file open${NC}"
                fi
                echo ""
                ;;
            :exit)
                echo -e "${YELLOW}Exit without saving? [y/N]${NC}"
                read -r confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    echo -e "${YELLOW}Exiting...${NC}"
                    break
                fi
                echo ""
                ;;
            :saveexit)
                if [ -n "$CURRENT_FILE" ]; then
                    save_file "$CURRENT_FILE"
                fi
                echo -e "${GREEN}Saved and exiting...${NC}"
                break
                ;;
            :q)
                echo -e "${YELLOW}Exit without saving? [y/N]${NC}"
                read -r confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    echo -e "${YELLOW}Exiting...${NC}"
                    break
                fi
                echo ""
                ;;
            :wq)
                if [ -n "$CURRENT_FILE" ]; then
                    save_file "$CURRENT_FILE"
                fi
                echo -e "${GREEN}Saved and exiting...${NC}"
                break
                ;;
            "")
                continue
                ;;
            *)
                if [[ "$input" == \: * ]]; then
                    echo -e "${RED}Unknown command. Type :help${NC}"
                    echo ""
                else
                    if [ -n "$CURRENT_FILE" ] && [ -f "$CURRENT_FILE" ]; then
                        echo "$input" >> "$CURRENT_FILE"
                        echo -e "${GREEN}Line added${NC}"
                    else
                        echo -e "${RED}No file open. Use :open or :new${NC}"
                    fi
                    echo ""
                fi
                ;;
        esac
    done
}
if [ "$1" = "edit" ]; then
    edit_file "$2"
elif [ "$1" = "open" ]; then
    open_file "$2"
elif [ "$1" = "new" ]; then
    touch "$2"
    edit_file "$2"
elif [ "$1" = "help" ]; then
    show_help
else
    edit_file "$1"
fi
