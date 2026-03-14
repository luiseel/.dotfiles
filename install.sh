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
    node
    yarn
    lua-language-server
    luaformatter
  )

  for pkg in "${packages[@]}"; do
    if brew list "$pkg" &>/dev/null; then
      info "$pkg is already installed"
    else
      info "Installing $pkg..."
      brew install "$pkg"
    fi
  done
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
  stow --no-folding -t ~ nvim tmux

  # Install tmux plugin manager
  local tpm_dir="$HOME/.tmux/plugins/tpm"
  if [ ! -d "$tpm_dir" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
  else
    info "TPM is already installed"
  fi
}

main() {
  local os
  os="$(detect_os)"
  info "Detected OS: $os"

  case "$os" in
    macos) install_macos ;;
    ubuntu) install_ubuntu ;;
  esac

  install_npm_packages
  setup_dotfiles

  echo ""
  info "Installation complete!"
  info "Open Neovim and Treesitter parsers will be installed automatically."
  info "Open a Java file and nvim-java will install its managed Java tooling."
  info "Run 'tmux' and press prefix + I to install tmux plugins."
}

main "$@"
