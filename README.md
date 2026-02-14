# dotfiles

My macOS development environment. Catppuccin Mocha theme everywhere, modern CLI tools, and a clean terminal setup.

## What's Included

| Component | Tool | Config |
|-----------|------|--------|
| Terminal | [Ghostty](https://ghostty.org) | `ghostty/config` |
| Shell | Zsh + [Oh My Zsh](https://ohmyz.sh) | `zsh/.zshrc` |
| Prompt | [Starship](https://starship.rs) | `starship/starship.toml` |
| Git | Git + [Delta](https://github.com/dandavison/delta) | `git/.gitconfig` |
| History | [Atuin](https://atuin.sh) | `atuin/config.toml` |
| Runtimes | [mise](https://mise.jdx.dev) | `mise/config.toml` |
| Font | JetBrains Mono (Nerd Font) | via Homebrew |
| Packages | Homebrew | `Brewfile` |

### Modern CLI Replacements

| Standard | Replacement | Alias |
|----------|------------|-------|
| `ls` | [eza](https://eza.rocks) | `ls`, `ll`, `lt`, `la` |
| `cat` | [bat](https://github.com/sharkdp/bat) | `cat` |
| `find` | [fd](https://github.com/sharkdp/fd) | `find` |
| `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` |
| `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` |
| `top` | [btop](https://github.com/aristocratos/btop) | `top` |
| `git` (TUI) | [lazygit](https://github.com/jesseduffield/lazygit) | `lg` |

### Zsh Plugins

- **zsh-autosuggestions** - Fish-like inline suggestions
- **zsh-syntax-highlighting** - Colors commands as you type
- **alias-tips** - Reminds you of aliases
- **fzf** - Fuzzy finder integration
- **last-working-dir** - Reopens terminal in last directory
- **zsh-pnpm-completions** - pnpm tab completions

## Install

```bash
git clone git@github.com:tirthGajjar/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The install script will:
1. Install Homebrew (if missing)
2. Install all packages from the Brewfile
3. Install mise (runtime version manager)
4. Install Oh My Zsh + custom plugins
5. Symlink all config files (backs up existing ones)
6. Install mise-managed runtimes (Node, pnpm, fzf, uv)

## Structure

```
dotfiles/
├── README.md
├── Brewfile              # Homebrew packages & casks
├── install.sh            # One-command setup
├── atuin/
│   └── config.toml       # -> ~/.config/atuin/config.toml
├── ghostty/
│   └── config            # -> ~/.config/ghostty/config
├── git/
│   ├── .gitconfig        # -> ~/.gitconfig
│   └── .gitignore_global # -> ~/.gitignore_global
├── mise/
│   └── config.toml       # -> ~/.config/mise/config.toml
├── starship/
│   └── starship.toml     # -> ~/.config/starship.toml
└── zsh/
    └── .zshrc            # -> ~/.zshrc
```

## Manual Steps

Some things can't be automated:

- **Ghostty**: Install from [ghostty.org](https://ghostty.org)
- **Cursor**: Install from [cursor.com](https://cursor.com)
- **SSH keys**: Generate or copy `~/.ssh/` keys
- **Atuin sync**: Run `atuin login` to sync shell history
