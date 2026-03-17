#!/usr/bin/env bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

ACTION="install"
INSTALL_NODE_DEPS=true

check_missing_count=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [check] [--skip-node]

Options:
  --skip-node  Skip Node.js, Yarn, and global npm package installation.
  -h, --help   Show this help message.

Commands:
  check        Report installed and missing dependencies without installing.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      install)
        ACTION="install"
        ;;
      check)
        ACTION="check"
        ;;
      --skip-node)
        INSTALL_NODE_DEPS=false
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        error "Unknown option: $1"
        ;;
    esac
    shift
  done
}

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if [ -f /etc/os-release ] && grep -qi ubuntu /etc/os-release; then
        echo "ubuntu"
      else
        error "Unsupported Linux distribution. Only Ubuntu is supported."
      fi
      ;;
    *) error "Unsupported operating system." ;;
  esac
}

command_exists() { command -v "$1" &>/dev/null; }

check_ok() { echo -e "${GREEN}[OK]${NC} $1"; }

check_missing() {
  check_missing_count=$((check_missing_count + 1))
  echo -e "${RED}[MISSING]${NC} $1"
}

check_note() { echo -e "${YELLOW}[NOTE]${NC} $1"; }

check_command() {
  local label="$1"
  local cmd="$2"

  if command_exists "$cmd"; then
    check_ok "$label"
  else
    check_missing "$label"
  fi
}

check_any_command() {
  local label="$1"
  shift

  for cmd in "$@"; do
    if command_exists "$cmd"; then
      check_ok "$label"
      return
    fi
  done

  check_missing "$label"
}

check_npm_package() {
  local package="$1"

  if ! command_exists npm; then
    check_missing "$package"
    return
  fi

  if npm list -g --depth=0 "$package" &>/dev/null; then
    check_ok "$package"
  else
    check_missing "$package"
  fi
}

check_linked_path() {
  local label="$1"
  local path="$2"

  if [ -L "$path" ]; then
    if [ -e "$path" ]; then
      check_ok "$label linked at $path"
    else
      check_missing "$label has a broken symlink at $path"
    fi
  elif [ -e "$path" ]; then
    check_note "$label exists at $path but is not symlinked"
  else
    check_missing "$label missing at $path"
  fi
}

check_no_broken_symlinks() {
  local label="$1"
  local path="$2"
  local broken_links

  if [ ! -d "$path" ]; then
    check_missing "$label missing at $path"
    return
  fi

  broken_links="$(find "$path" -type l ! -exec test -e {} \; -print)"

  if [ -n "$broken_links" ]; then
    check_missing "$label has broken symlinks:\n$broken_links"
  else
    check_ok "$label has no broken symlinks"
  fi
}

check_directory() {
  local label="$1"
  local path="$2"

  if [ -d "$path" ]; then
    check_ok "$label"
  else
    check_missing "$label"
  fi
}

check_ghostty_app() {
  local os="$1"

  if command_exists ghostty; then
    check_ok "Ghostty app"
    return
  fi

  if [ "$os" = "macos" ]; then
    if [ -d "/Applications/Ghostty.app" ] || [ -d "$HOME/Applications/Ghostty.app" ]; then
      check_ok "Ghostty app"
    else
      check_note "Ghostty app not found (optional, installed manually)"
    fi
    return
  fi

  check_note "Ghostty app not found (optional, installed manually)"
}

run_checks() {
  local os="$1"
  check_missing_count=0

  info "Checking core dependencies..."
  check_command "stow" stow
  check_command "ripgrep (rg)" rg
  check_any_command "fd" fd fdfind
  check_command "git" git
  check_command "tmux" tmux
  check_command "neovim (nvim)" nvim
  check_command "cmake" cmake
  check_command "lua-language-server" lua-language-server
  check_command "luaformatter (lua-format)" lua-format

  echo ""
  info "Checking Node.js dependencies..."
  if [ "$INSTALL_NODE_DEPS" = true ]; then
    check_command "Node.js" node
    check_command "npm" npm
    check_command "Yarn" yarn
    check_npm_package "typescript"
    check_npm_package "typescript-language-server"
    check_npm_package "@vue/language-server"
    check_npm_package "vscode-langservers-extracted"
  else
    check_note "Skipping Node.js dependency checks (--skip-node)"
  fi

  echo ""
  info "Checking optional/manual dependencies..."
  check_ghostty_app "$os"

  echo ""
  info "Checking local setup..."
  check_linked_path "Ghostty config" "$HOME/.config/ghostty/config.ghostty"
  check_linked_path "Neovim config" "$HOME/.config/nvim/init.lua"
  check_no_broken_symlinks "Neovim config directory" "$HOME/.config/nvim"
  check_linked_path "tmux config" "$HOME/.tmux.conf"
  check_directory "TPM" "$HOME/.tmux/plugins/tpm"

  echo ""
  if [ "$check_missing_count" -eq 0 ]; then
    info "All required checks passed."
  else
    warn "$check_missing_count required checks are missing."
  fi
}

install_macos() {
  if ! command_exists brew; then
    error "Homebrew is required. Install it from https://brew.sh"
  fi

  info "Updating Homebrew..."
  brew update

  info "Installing system packages..."
  local packages=(
    stow
    neovim
    ripgrep
    fd
    git
    tmux
    cmake
    lua-language-server
    luarocks
  )

  if [ "$INSTALL_NODE_DEPS" = true ]; then
    packages+=(
      node
      yarn
    )
  else
    info "Skipping Node.js and Yarn installation"
  fi

  for pkg in "${packages[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      info "$pkg is already installed"
    else
      info "Installing $pkg..."
      brew install "$pkg"
    fi
  done

  if ! command_exists lua-format; then
    info "Installing luaformatter via LuaRocks..."
    luarocks install --server=https://luarocks.org/dev luaformatter
  else
    info "lua-format is already installed"
  fi
}

install_ubuntu() {
  info "Updating apt..."
  sudo apt-get update

  info "Installing system packages..."
  local packages=(
    stow
    ripgrep
    fd-find
    git
    tmux
    cmake
    curl
    build-essential
  )

  sudo apt-get install -y "${packages[@]}"

  # Neovim (stable PPA for latest version)
  if ! command_exists nvim; then
    info "Installing Neovim..."
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
  else
    info "Neovim is already installed"
  fi

  if [ "$INSTALL_NODE_DEPS" = true ]; then
    # Node.js via NodeSource
    if ! command_exists node; then
      info "Installing Node.js..."
      curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
      sudo apt-get install -y nodejs
    else
      info "Node.js is already installed"
    fi

    # Yarn
    if ! command_exists yarn; then
      info "Installing Yarn..."
      sudo npm install -g yarn
    else
      info "Yarn is already installed"
    fi
  else
    info "Skipping Node.js and Yarn installation"
  fi

  # Lua language server
  if ! command_exists lua-language-server; then
    info "Installing lua-language-server..."
    sudo snap install lua-language-server --classic 2>/dev/null \
      || warn "Could not install lua-language-server via snap. Install it manually."
  else
    info "lua-language-server is already installed"
  fi

  # luaformatter
  if ! command_exists lua-format; then
    info "Installing luaformatter..."
    sudo apt-get install -y luaformatter 2>/dev/null \
      || warn "luaformatter not available in apt. Install it manually: https://github.com/Koihik/LuaFormatter"
  else
    info "lua-format is already installed"
  fi

}

install_npm_packages() {
  if [ "$INSTALL_NODE_DEPS" != true ]; then
    info "Skipping global npm package installation"
    return
  fi

  info "Installing global npm packages..."
  local packages=(
    typescript
    typescript-language-server
    @vue/language-server
    vscode-langservers-extracted
  )

  for pkg in "${packages[@]}"; do
    if npm list -g "$pkg" &>/dev/null; then
      info "$pkg is already installed"
    else
      info "Installing $pkg..."
      npm install -g "$pkg"
    fi
  done
}

setup_dotfiles() {
  local dotfiles_dir
  dotfiles_dir="$(cd "$(dirname "$0")" && pwd)"

  info "Linking dotfiles with stow..."
  cd "$dotfiles_dir"
  local packages=(
    ghostty
    nvim
    tmux
  )

  stow --restow --no-folding -t ~ "${packages[@]}"

  # Install tmux plugin manager
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    info "TPM is already installed"
  fi
}

setup_neovim_plugins() {
  if ! command_exists nvim; then
    warn "Neovim is not installed. Skipping plugin bootstrap."
    return
  fi

  info "Bootstrapping Neovim plugins with lazy.nvim..."
  if ! nvim --headless "+Lazy! sync" +qa; then
    warn "Neovim plugin bootstrap failed. Open Neovim and run ':Lazy sync' to inspect the error."
  fi
}

main() {
  parse_args "$@"

  local os
  os="$(detect_os)"
  info "Detected OS: $os"

  if [ "$ACTION" = "check" ]; then
    run_checks "$os"
    return
  fi

  case "$os" in
    macos) install_macos ;;
    ubuntu) install_ubuntu ;;
  esac

  install_npm_packages
  setup_dotfiles
  setup_neovim_plugins

  echo ""
  info "Installation complete!"
  info "Treesitter parsers and other Neovim plugins were bootstrapped during install."
  info "Open a Java file and nvim-java will install its managed Java tooling."
  info "Run 'tmux' and press prefix + I to install tmux plugins."
}

main "$@"
