# ══════════════════════════════════════════════════════
# Zsh Configuration
# ══════════════════════════════════════════════════════

# Add Homebrew completions to fpath (must be before Oh My Zsh)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""  # Disabled - using starship prompt instead

plugins=(
  git
  last-working-dir        # Reopens terminal in last directory
  zsh-autosuggestions     # Fish-like inline suggestions
  zsh-syntax-highlighting # Colors commands as you type
  fzf                     # Fuzzy finder integration
  npm                     # npm/node completions & aliases
  alias-tips              # Shows tips when you type a long command that has an alias
)

source $ZSH/oh-my-zsh.sh

# ── History (bigger, deduped, shared across sessions) ──
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS    # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS       # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt SHARE_HISTORY           # Share history across sessions
setopt INC_APPEND_HISTORY      # Write immediately, not on exit

# ── mise (runtime manager) ──
eval "$(mise activate zsh)"
export PATH="$HOME/.local/bin:$PATH"

# ── Homebrew ──
export PATH=/opt/homebrew/bin:$PATH

# ── Better defaults ──
export EDITOR="cursor -w"
export PAGER="delta"
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -l man -p'"

# ── Claude Code aliases ──
alias cc="claude"
alias ccd="claude --dangerously-skip-permissions"
alias ccc="claude --continue"

# ── Directory completion enhancements ──
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*:messages' format '%F{purple}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{red}── no matches ──%f'

# ── eza (modern ls) ──
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"
alias la="eza -a --icons"

# ── bat (modern cat) ──
alias cat="bat --paging=never"
export BAT_THEME="Catppuccin Mocha"

# ── fd (modern find) ──
alias find="fd"

# ── ripgrep (modern grep) ──
alias grep="rg"

# ── lazygit ──
alias lg="lazygit"

# ── btop (system monitor) ──
alias top="btop"

# ── Quick navigation ──
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"

# ── Quick edit configs ──
alias zshrc="$EDITOR ~/.zshrc"
alias ghosttyrc="$EDITOR ~/.config/ghostty/config"
alias gitrc="$EDITOR ~/.gitconfig"

# ── Misc shortcuts ──
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"
alias ip="curl -s https://ipinfo.io/ip"
alias reload="exec zsh"
alias path='echo $PATH | tr ":" "\n"'
alias brewup="brew update && brew upgrade && brew cleanup"

# ── fzf config (Catppuccin Mocha theme) ──
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS=" \
  --height=60% \
  --layout=reverse \
  --border=rounded \
  --info=inline \
  --marker='▎' \
  --pointer='▎' \
  --prompt='  ' \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --color=border:#585b70,label:#cdd6f4"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

# ── zoxide (smart cd, replaces cd) ──
eval "$(zoxide init zsh --cmd cd)"

# ── atuin (magical shell history) ──
eval "$(atuin init zsh --disable-up-arrow)"

# ── fzf shell integration ──
source <(fzf --zsh)

# ── starship prompt (must be last) ──
eval "$(starship init zsh)"
