#!/bin/bash
# =============================================================================
# bootstrap.sh — Fresh machine setup
#
# First time on a new machine:
#   sudo apt install -y git gh
#   gh auth login
#   git clone git@github.com:tobychappell/dotfiles.git ~/source/repos/dotfiles
#   cd ~/source/repos/dotfiles && ./bootstrap.sh && ./install.sh
# =============================================================================
set -e

# Detect environment
IS_WSL=false
if grep -qi microsoft /proc/version 2>/dev/null; then
    IS_WSL=true
fi

ARCH=$(dpkg --print-architecture 2>/dev/null || uname -m)

echo "==> Environment: $([ "$IS_WSL" = true ] && echo 'WSL' || echo 'Native Linux')"

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
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_via_bash.sh | bash

# -----------------------------------------------------------------------------
# nvm (Node / TS / Vue / React)
echo "==> Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# -----------------------------------------------------------------------------
# pyenv (Python)
echo "==> Installing pyenv..."
curl https://pyenv.run | bash

# -----------------------------------------------------------------------------
# Go (version manager via goenv, or direct install)
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
