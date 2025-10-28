# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# Oh My Zsh plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  macos
  brew
)

source $ZSH/oh-my-zsh.sh

# === Enhanced Autocompletion Configuration ===

# zsh-completions (additional completion definitions)
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# Enable advanced completion system
autoload -Uz compinit
compinit

# zsh-autosuggestions configuration (fish-like autosuggestions)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#7d8590,bold"  # More visible gray color
ZSH_AUTOSUGGEST_STRATEGY=(history completion)       # Use history and completion
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20                  # Limit for performance
ZSH_AUTOSUGGEST_USE_ASYNC=1                         # Async for better performance

# Completion styling
zstyle ':completion:*' menu select                           # Interactive menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Colored completion
zstyle ':completion:*' group-name ''                         # Group results by category
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# fzf integration (fuzzy finder)
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif type brew &>/dev/null && [ -f $(brew --prefix)/opt/fzf/shell/completion.zsh ]; then
  source $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
  source $(brew --prefix)/opt/fzf/shell/completion.zsh
fi

# fzf configuration
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

# Use fd if available for fzf
if command -v fd > /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# History configuration (better search)
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_IGNORE_DUPS          # Ignore duplicates
setopt HIST_IGNORE_ALL_DUPS      # Remove old duplicates
setopt HIST_FIND_NO_DUPS         # Don't show duplicates in search
setopt HIST_SAVE_NO_DUPS         # Don't save duplicates
setopt SHARE_HISTORY             # Share history between sessions

# Show execution time for commands that take longer than 2 seconds
REPORTTIME=2

# Git prompt customization
ZSH_THEME_GIT_PROMPT_PREFIX="%F{cyan}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Custom prompt
PROMPT='❯ '
RPROMPT='$(git_prompt_info)'

# Aliases
alias vim='nvim'
alias dns-clean='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder'
