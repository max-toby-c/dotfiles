#!/bin/bash
set -e

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

# GitHub CLI
echo "==> Installing gh..."
wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install gh -y

# Starship
echo "==> Installing starship..."
curl -sS https://starship.rs/install.sh | sh -s -- --yes

# Lazydocker
echo "==> Installing lazydocker..."
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_via_bash.sh | bash

# nvm (Node / TS / Vue / React)
echo "==> Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pyenv (Python)
echo "==> Installing pyenv..."
curl https://pyenv.run | bash

# Go
echo "==> Installing Go..."
GO_VERSION="1.22.3"
curl -OL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
rm "go${GO_VERSION}.linux-amd64.tar.gz"

# .NET
echo "==> Installing .NET..."
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel LTS

# Claude Code
echo "==> Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# Set default shell to zsh
echo "==> Setting zsh as default shell..."
chsh -s $(which zsh)

echo ""
echo "Done! Open a new terminal and run ./install.sh to symlink dotfiles."
