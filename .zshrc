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

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Go
export PATH="$PATH:/usr/local/go/bin"

# .NET
export PATH="$PATH:$HOME/.dotnet"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Starship prompt
eval "$(starship init zsh)"
