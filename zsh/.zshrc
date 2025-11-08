# ============================================
# ULTRAMINIMAL ZSHRC (No Oh-My-Zsh)
# ============================================

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export PATH="/opt/homebrew/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Completion system
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS

# FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=fg:#c5c9c5,bg:#181616,hl:#7fb4ca,fg+:#c5c9c5,bg+:#2d4f67,hl+:#7dcfff"
command -v fd > /dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Standalone plugins (install with brew)
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7d8590"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Git branch function (ultra minimal)
git_branch() {
  git branch 2>/dev/null | grep "^*" | cut -d" " -f2
}

# Prompt configuration
if [ -n "$TMUX" ]; then
  PROMPT='%F{#a6a69c}$(tmux display-message -p "#S")%f %F{#7aa89f}❯%f '
else
  PROMPT='❯ '
fi
RPROMPT='%F{cyan}$(git_branch)%f'

# Editor aliases
alias vim='nvim' vi='nvim'
alias lg='lazygit' zshrc='nvim ~/.zshrc' zshreload='source ~/.zshrc'

# Git aliases
alias gs='git status -sb' gp='git push' gl='git pull' gc='git clone'
alias glog='git log --oneline --graph --decorate'
alias gcm='git commit -m' ga='git add' gaa='git add .'

# Tmux aliases
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias ts='tmux new-session -s'
alias tr='tmux rename-session -t'
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'
alias tkall='tmux kill-server'

# Auto-attach to tmux session (only in interactive terminals)
# Skip if: already in tmux, SSH session, VSCode, CI/CD, or non-interactive shell
if [ -z "$TMUX" ] && [ -z "$SSH_CONNECTION" ] && [ -z "$VSCODE_INJECTION" ] && [ -z "$CI" ] && [ -t 0 ]; then
  if tmux has-session 2>/dev/null; then
    tmux attach
  else
    tmux new-session -s "$(date +%Y%m%d)"
  fi
fi
