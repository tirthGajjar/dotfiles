#!/usr/bin/env bash
set -euo pipefail

# ══════════════════════════════════════════════════════
# Dotfiles Installer
# ══════════════════════════════════════════════════════
# Usage: ./install.sh
#
# This script:
#   1. Installs Homebrew (if missing)
#   2. Installs packages via Brewfile
#   3. Installs mise (runtime version manager)
#   4. Installs Oh My Zsh + plugins
#   5. Installs Claude Code (AI coding assistant)
#   6. Installs OpenCode
#   7. Symlinks all config files
#   8. Installs mise-managed runtimes

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ── Homebrew ──
install_homebrew() {
  if command -v brew &>/dev/null; then
    success "Homebrew already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    success "Homebrew installed"
  fi
}

# ── Brew Bundle ──
install_packages() {
  info "Installing packages from Brewfile..."
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  success "Packages installed"
}

# ── mise ──
install_mise() {
  if command -v mise &>/dev/null; then
    success "mise already installed"
  else
    info "Installing mise..."
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
    success "mise installed"
  fi
}

# ── Oh My Zsh ──
install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    success "Oh My Zsh already installed"
  else
    info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh installed"
  fi
}

# ── Oh My Zsh Custom Plugins ──
install_zsh_plugins() {
  local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  local plugins=(
    "zsh-autosuggestions|git@github.com:zsh-users/zsh-autosuggestions.git"
    "zsh-syntax-highlighting|git@github.com:zsh-users/zsh-syntax-highlighting.git"
    "alias-tips|git@github.com:djui/alias-tips.git"
  )

  for entry in "${plugins[@]}"; do
    local name="${entry%%|*}"
    local url="${entry##*|}"
    local dest="$ZSH_CUSTOM/plugins/$name"

    if [[ -d "$dest" ]]; then
      success "Plugin $name already installed"
    else
      info "Installing zsh plugin: $name"
      git clone --depth 1 "$url" "$dest"
      success "Plugin $name installed"
    fi
  done
}

# ── Claude Code ──
install_claude() {
  if command -v claude &>/dev/null; then
    success "Claude Code already installed"
  else
    info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
    success "Claude Code installed"
  fi
}

# ── OpenCode ──
install_opencode() {
  if command -v opencode &>/dev/null; then
    success "OpenCode already installed"
  else
    info "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
    success "OpenCode installed"
  fi
}

# ── Symlinks ──
create_symlink() {
  local src="$1"
  local dest="$2"

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    rm "$dest"
  elif [[ -f "$dest" ]]; then
    warn "Backing up existing $dest to ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi

  ln -sf "$src" "$dest"
  success "Linked $dest -> $src"
}

symlink_configs() {
  info "Symlinking config files..."

  # Zsh
  create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

  # Git
  create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

  # Ghostty
  create_symlink "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

  # Starship
  create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

  # mise
  create_symlink "$DOTFILES_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  # Atuin
  create_symlink "$DOTFILES_DIR/atuin/config.toml" "$HOME/.config/atuin/config.toml"

  # Lazygit
  create_symlink "$DOTFILES_DIR/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"

  success "All configs symlinked"
}

# ── mise runtimes ──
install_runtimes() {
  info "Installing mise runtimes..."
  mise install
  success "Runtimes installed"
}

# ── Main ──
main() {
  echo ""
  echo "  ╔══════════════════════════════════════╗"
  echo "  ║        Dotfiles Installer            ║"
  echo "  ╚══════════════════════════════════════╝"
  echo ""

  install_homebrew
  install_packages
  install_mise
  install_oh_my_zsh
  install_zsh_plugins
  install_claude
  install_opencode
  symlink_configs
  install_runtimes

  echo ""
  success "All done! Restart your terminal or run: exec zsh"
  echo ""
}

main "$@"