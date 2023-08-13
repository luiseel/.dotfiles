#/bin/sh

CONFIG_DIR=~/.config
ALACRITTY_DIR=~/.config/alacritty
NVIM_DIR=~/.config/nvim

[ ! -d $CONFIG_DIR ] && mkdir $CONFIG_DIR
[ ! -d $ALACRITTY_DIR ] && mkdir $ALACRITTY_DIR
[ ! -d $NVIM_DIR ] && mkdir $NVIM_DIR

[ ! -d $ALACRITTY_DIR/catppuccin ] && git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin
ln -s $(pwd)/nvim/* $CONFIG_DIR/nvim
ln -s $(pwd)/alacritty.yml $ALACRITTY_DIR/alacritty.yml
ln -s $(pwd)/.tmux.conf ~/.tmux.conf
