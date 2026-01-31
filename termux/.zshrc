# ============================================
# TERMUX ZSHRC (Ultra-Light)
# ============================================

# Editor
export EDITOR="nvim"
export PAGER="less"

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# Completion
autoload -Uz compinit && compinit -C
zstyle ':completion:*' menu select

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# FZF (minimal, no preview - faster on small screen)
[ -f "$PREFIX/share/fzf/key-bindings.zsh" ] && source "$PREFIX/share/fzf/key-bindings.zsh"
export FZF_DEFAULT_OPTS="--height 30% --reverse"
export FZF_CTRL_R_OPTS="--height 30%"

# Plugins
[ -f "$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Prompt (minimal, no starship - faster startup)
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
PROMPT='%F{blue}%1~%f %F{magenta}${vcs_info_msg_0_}%f %F{cyan}>%f '

# Aliases esenciales
alias v='nvim'
alias c='clear'
alias q='exit'

# ls (sin iconos, funciona en cualquier terminal)
alias l='ls -la'
alias ll='ls -l'

# Solo si están instalados
command -v bat > /dev/null && alias cat='bat -p'
command -v rg > /dev/null && alias grep='rg'
command -v fd > /dev/null && alias find='fd'

# Git (mínimo)
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline -10'

# Termux
alias clip='termux-clipboard-set'
alias paste='termux-clipboard-get'
alias open='termux-open'
alias share='termux-share'
alias battery='termux-battery-status'
alias wifi='termux-wifi-connectioninfo'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Zoxide (si está instalado)
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"
