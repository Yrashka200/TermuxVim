#!/bin/bash
LOG_DIR="$HOME/.local/share/termuxide/logs"
LOG_FILE="$LOG_DIR/termuxide.log"
ERROR_LOG="$LOG_DIR/errors.log"
mkdir -p "$LOG_DIR"
log_info() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[INFO]${NC} $msg"
    echo "[$timestamp] [INFO] $msg" >> "$LOG_FILE"
}
log_error() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${RED}[ERROR]${NC} $msg" >&2
    echo "[$timestamp] [ERROR] $msg" >> "$ERROR_LOG"
    echo "[$timestamp] [ERROR] $msg" >> "$LOG_FILE"
}
log_warning() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${YELLOW}[WARNING]${NC} $msg"
    echo "[$timestamp] [WARNING] $msg" >> "$LOG_FILE"
}
log_debug() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${BLUE}[DEBUG]${NC} $msg"
    echo "[$timestamp] [DEBUG] $msg" >> "$LOG_FILE"
}
log_success() {
    local msg="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${GREEN}[SUCCESS]${NC} $msg"
    echo "[$timestamp] [SUCCESS] $msg" >> "$LOG_FILE"
}
show_logs() {
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}Recent Logs${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    if [ -f "$LOG_FILE" ]; then
        tail -30 "$LOG_FILE"
    else
        echo -e "${YELLOW}No logs found${NC}"
    fi
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${RED}Error Logs${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    if [ -f "$ERROR_LOG" ]; then
        tail -15 "$ERROR_LOG"
    else
        echo -e "${YELLOW}No errors found${NC}"
    fi
}
clear_logs() {
    if [ -f "$LOG_FILE" ]; then
        > "$LOG_FILE"
        log_info "Logs cleared"
    fi
    if [ -f "$ERROR_LOG" ]; then
        > "$ERROR_LOG"
    fi
}
if [ "$1" = "show" ]; then
    show_logs
elif [ "$1" = "clear" ]; then
    clear_logs
elif [ "$1" = "error" ]; then
    if [ -f "$ERROR_LOG" ]; then
        cat "$ERROR_LOG"
    fi
fi
