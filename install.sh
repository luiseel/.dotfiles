#/bin/sh

CONFIG_DIR=~/.config/.dotfiles

ln -s $CONFIG_DIR/init.vim ~/.config/nvim/init.vim
ln -s $CONFIG_DIR/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -s $CONFIG_DIR/.tmux.conf ~/.tmux.conf
