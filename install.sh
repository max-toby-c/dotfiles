#!/bin/bash
DOTFILES="$HOME/source/repos/dotfiles"

ln -sf "$DOTFILES/.gitconfig" ~/.gitconfig
ln -sf "$DOTFILES/.gitconfig-maxcontact" ~/.gitconfig-maxcontact
ln -sf "$DOTFILES/.tmux.conf" ~/.tmux.conf
ln -sf "$DOTFILES/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/.ssh/config" ~/.ssh/config

chmod +x "$DOTFILES/bootstrap.sh"

echo "Done."
