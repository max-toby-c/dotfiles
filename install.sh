#!/bin/bash
DOTFILES="$HOME/source/repos/dotfiles"

ln -sf "$DOTFILES/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/.gitconfig-maxcontact" ~/.gitconfig-maxcontact
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/.zshrc" ~/.zshrc
mkdir -p ~/.ssh && chmod 700 ~/.ssh
ln -sf "$DOTFILES/.ssh/config" ~/.ssh/config

mkdir -p ~/.claude
ln -sf "$DOTFILES/.claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES/.claude/plugins" ~/.claude/plugins

chmod +x "$DOTFILES/bootstrap.sh"

echo "Done."
