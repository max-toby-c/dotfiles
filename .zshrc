export PATH="$HOME/.local/bin:$PATH"

# SSH agent — reuse existing agent across panes
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# Word navigation
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# History
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Aliases — standard
alias ll='eza -alF --git'
alias ls='eza'
alias cat='bat'
alias grep='rg'
alias find='fd'
alias gs='git status'
alias gl='git lg'
alias dc='docker compose'
alias lg='lazygit'
alias ld='lazydocker'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zoxide (replaces cd)
eval "$(zoxide init zsh)"

# zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last)
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

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

# Starship prompt (must be last)
eval "$(starship init zsh)"
