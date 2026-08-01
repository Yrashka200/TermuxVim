#!/bin/bash
print_header() {
  echo -e "${BLUE}═══════════════════════════════════════════${NC}"
  echo -e "${CYAN}  $1${NC}"
  echo -e "${BLUE}═══════════════════════════════════════════${NC}"
}
print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}
print_error() {
  echo -e "${RED}❌ $1${NC}"
}
print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}
check_command() {
  if command -v $1 &>/dev/null; then
    print_success "$1 is installed"
    return 0
  else
    print_error "$1 is not installed"
    return 1
  fi
}
wait_for_user() {
  read -p "Press Enter to continue..."
}
