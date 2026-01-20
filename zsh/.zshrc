# ============================================
# ULTRAMINIMAL ZSHRC (No Oh-My-Zsh)
# ============================================

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export PATH="$HOME/dotfiles/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.opencode/bin:/opt/homebrew/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Completion system (include Homebrew completions)
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# FZF configuration (optimized for 27" monitor @ 1920x1080)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# =============================================================================
# KANAGAWA DRAGON COLORS
# =============================================================================
# Background: #181616 | Foreground: #c5c9c5
# Red: #c4746e | Green: #8a9a7b | Yellow: #c4b28a | Blue: #8ba4b0
# Bright Blue: #7fb4ca | Magenta: #938aa9 | Cyan: #7aa89f | Gray: #a6a69c
# =============================================================================

export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border \
  --preview-window=right:50%:wrap \
  --bind=ctrl-p:toggle-preview \
  --bind=J:down,K:up \
  --bind=ctrl-j:preview-down,ctrl-k:preview-up \
  --bind=ctrl-d:preview-page-down,ctrl-u:preview-page-up \
  --color=fg:#c5c9c5,bg:#181616,hl:#7fb4ca,fg+:#c5c9c5,bg+:#223249,hl+:#7fb4ca \
  --color=info:#8a9a7b,prompt:#c4746e,pointer:#c4b28a,marker:#8a9a7b,spinner:#a292a3"
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {} 2>/dev/null | head -100' --preview-window=right:50%:wrap --bind 'enter:execute(nvim {})+abort'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window=up:3:wrap"
export FZF_ALT_C_OPTS="--preview 'ls -la {}' --preview-window=right:50%:wrap"
command -v fd > /dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
command -v fd > /dev/null && export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Autosuggestions config (MUST be before loading plugin)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#625e5a"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Standalone plugins (install with brew)
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt
eval "$(starship init zsh)"

# Editor aliases
alias vim='nvim'
alias vi='nvim'
alias lg='lazygit'
alias zshrc='nvim ~/.zshrc'
alias zshreload='source ~/.zshrc'

# Modern ls with eza (icons + git status)
alias ls='eza --icons'
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'
alias lt='eza -la --icons --git --tree --level=2'

# Modern CLI tools (bat, rg, fd)
alias cat='bat --paging=never'
alias catp='bat'  # with pager
alias grep='rg'
alias find='fd'

# FZF + bat integration
alias fzfbat='fzf --preview "bat -n --color=always {}"'
alias fzfnvim='nvim $(fzf --preview "bat -n --color=always {}")'

# Git aliases
alias gs='git status -sb' gp='git push' gl='git pull' gc='git clone'
alias glog='git log --oneline --graph --decorate'
alias gcm='git commit -m' ga='git add' gaa='git add .'

# Tmux aliases (minimal)
alias tl='tmux list-sessions'
alias ta='tmux attach -t'
alias td='tmux detach'
alias tk='tmux kill-session -t'

# Create new tmux session with optional name (defaults to date yyyymmdd)
tn() {
  local session_name="${1:-$(date +%Y%m%d)}"
  tmux new-session -s "$session_name"
}

# System utilities
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

# Arrow keys for autosuggestions
bindkey '^[[C' forward-char      # Right arrow - accept full suggestion
bindkey '^[OC' forward-char      # Right arrow (alternate escape sequence)
bindkey '^[[1;5C' forward-word   # Ctrl+Right - accept word


# Zoxide (smart cd replacement)
eval "$(zoxide init zsh)"

# nextdns-blocker shell completion
eval "$(_NEXTDNS_BLOCKER_COMPLETE=zsh_source nextdns-blocker)"
