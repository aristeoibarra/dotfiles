export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  macos
  brew
)

source $ZSH/oh-my-zsh.sh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit
compinit

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7d8590,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif type brew &>/dev/null && [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ]; then
  source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
  source $(brew --prefix)/opt/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --color=fg:#c0caf5,bg:#1a1b26,hl:#7aa2f7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
"

if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

REPORTTIME=2

ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

if [ -n "$TMUX" ]; then
  PROMPT='%F{#a6a69c}$(tmux display-message -p "#S")%f %F{#7aa89f}❯%f '
else
  PROMPT='❯ '
fi
RPROMPT='$(git_prompt_info)'

alias vim='nvim'
alias dns-clean='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'

alias gs='git status -sb'
alias gp='git push'
alias gl='git pull'
alias gc='git clone'
alias glog='git log --oneline --graph --decorate'
alias gcm='git commit -m'

alias ta='tmux attach -t'

alias tl='tmux list-sessions'
alias ts='tmux new-session -s'
alias tr='tmux rename-session -t'
alias tk='tmux kill-session -t'
alias tka='tmux kill-session -a'
alias tkall='tmux kill-server'

if [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ]; then
  if tmux has-session 2>/dev/null; then
    tmux attach
  else
    tmux new-session -s "$(date +%Y%m%d)"
  fi
fi
