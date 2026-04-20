#!/bin/bash
# =============================================================================
# bootstrap.sh — Fresh machine setup
#
# First time on a new machine:
#   sudo apt install -y git
#   git clone https://github.com/max-toby-c/dotfiles.git ~/source/repos/dotfiles
#   cd ~/source/repos/dotfiles && ./bootstrap.sh && ./install.sh
#
# After bootstrap completes:
#   gh auth login
#   ssh-keygen -t ed25519 -C "Toby.Chappell@maxcontact.com" -f ~/.ssh/id_ed25519
#   gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)"
# =============================================================================
set -e

# Detect environment
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
fi

ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)

echo "==> Environment: $([ "$IS_WSL" = true ] && echo 'WSL' || echo 'Native Linux'), arch: ${ARCH}"

# -----------------------------------------------------------------------------
echo "==> Updating apt..."
sudo apt update && sudo apt upgrade -y

echo "==> Installing system tools..."
sudo apt install -y \
    curl \
    wget \
    git \
    zsh \
    tmux \
    keychain \
    ranger \
    unzip \
    build-essential \
    libssl-dev \
    libffi-dev \
    libreadline-dev \
    zlib1g-dev

# -----------------------------------------------------------------------------
# GitHub CLI
echo "==> Installing gh..."
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y

# -----------------------------------------------------------------------------
# Docker — skip on WSL (Docker Desktop provides this), install natively otherwise
if [ "$IS_WSL" = true ]; then
    echo "==> WSL detected — skipping Docker install (use Docker Desktop + WSL integration)"
    echo "    Docker Desktop → Settings → Resources → WSL Integration → enable your distro"
else
    if ! command -v docker &>/dev/null; then
        echo "==> Installing Docker..."
        curl -fsSL https://get.docker.com | sh
        sudo usermod -aG docker "$USER"
        echo "    Docker installed. Log out and back in for group membership to take effect."
    else
        echo "==> Docker already installed, skipping."
    fi
fi

# -----------------------------------------------------------------------------
# Starship
echo "==> Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Lazydocker
echo "==> Installing lazydocker..."
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
case "$ARCH" in
    amd64|x86_64) LD_ARCH="x86_64" ;;
    arm64|aarch64) LD_ARCH="arm64" ;;
esac
curl -OL "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_${LD_ARCH}.tar.gz"
tar -xzf "lazydocker_${LAZYDOCKER_VERSION}_Linux_${LD_ARCH}.tar.gz" lazydocker
sudo install lazydocker -D -t /usr/local/bin/
rm -f lazydocker "lazydocker_${LAZYDOCKER_VERSION}_Linux_${LD_ARCH}.tar.gz"

# Lazygit
echo "==> Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
case "$ARCH" in
    amd64|x86_64) LG_ARCH="x86_64" ;;
    arm64|aarch64) LG_ARCH="arm64" ;;
esac
curl -OL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"
tar -xzf "lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz" lazygit
sudo install lazygit -D -t /usr/local/bin/
rm -f lazygit "lazygit_${LAZYGIT_VERSION}_Linux_${LG_ARCH}.tar.gz"

# -----------------------------------------------------------------------------
# Performance tooling
echo "==> Installing performance tools..."

# fzf — fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all

# zoxide — smarter cd
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# eza — modern ls
sudo apt install -y gpg
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update && sudo apt install -y eza

# bat — better cat
sudo apt install -y bat
# Ubuntu installs bat as batcat, alias to bat
mkdir -p ~/.local/bin && ln -sf /usr/bin/batcat ~/.local/bin/bat

# ripgrep — faster grep
sudo apt install -y ripgrep

# fd — faster find
sudo apt install -y fd-find
ln -sf "$(which fdfind)" ~/.local/bin/fd

# delta — better git diffs
DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep '"tag_name"' | sed 's/.*"\([^"]*\)".*/\1/')
case "$ARCH" in
    amd64|x86_64) DELTA_DEB_ARCH="amd64" ;;
    arm64|aarch64) DELTA_DEB_ARCH="arm64" ;;
esac
curl -OL "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${DELTA_DEB_ARCH}.deb"
sudo dpkg -i "git-delta_${DELTA_VERSION}_${DELTA_DEB_ARCH}.deb"
rm -f "git-delta_${DELTA_VERSION}_${DELTA_DEB_ARCH}.deb"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum

# -----------------------------------------------------------------------------
# nvm (Node / TS / Vue / React)
echo "==> Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts

# -----------------------------------------------------------------------------
# pyenv (Python)
echo "==> Installing pyenv..."
curl https://pyenv.run | bash

# -----------------------------------------------------------------------------
# Go
echo "==> Installing Go..."
GO_VERSION="1.22.3"
case "$ARCH" in
    amd64|x86_64) GO_ARCH="amd64" ;;
    arm64|aarch64) GO_ARCH="arm64" ;;
    *) echo "Unsupported arch: $ARCH"; exit 1 ;;
esac
curl -OL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"
rm "go${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

# -----------------------------------------------------------------------------
# .NET
echo "==> Installing .NET..."
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel LTS

# -----------------------------------------------------------------------------
# Claude Code
echo "==> Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# OpenAI Codex
echo "==> Installing Codex..."
npm install -g @openai/codex

# GitHub Copilot CLI
echo "==> Installing GitHub Copilot CLI..."
gh extension install github/gh-copilot

# uv (Python package manager)
echo "==> Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# specify-cli (speckit)
echo "==> Installing specify-cli..."
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git

# The Courtroom (adversarial code review plugin)
echo "==> Installing The Courtroom Claude Code plugin..."
claude --dangerously-skip-permissions /plugin marketplace add JustineDaveMagnaye/the-courtroom
claude --dangerously-skip-permissions /plugin install courtroom

# -----------------------------------------------------------------------------
# Set default shell to zsh
echo "==> Setting zsh as default shell..."
chsh -s "$(which zsh)"

# -----------------------------------------------------------------------------
echo ""
echo "Done!"
if [ "$IS_WSL" = true ]; then
    echo "  Reminder: enable WSL integration in Docker Desktop before using Docker."
fi
echo "  Open a new terminal then run: ./install.sh"
echo "  Then open tmux and press prefix + I to install tmux plugins."
