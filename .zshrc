export PATH="$HOME/.local/bin:$PATH"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Aliases
alias ll='ls -alF'
alias gs='git status'
alias gl='git lg'
alias dc='docker compose'

# Starship prompt
eval "$(starship init zsh)"
