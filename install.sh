#/bin/sh

CONFIG_DIR=~/.config
ALACRITTY_DIR=~/.config/alacritty
NVIM_DIR=~/.config/nvim

[ ! -d $CONFIG_DIR ] && mkdir $CONFIG_DIR
[ ! -d $ALACRITTY_DIR ] && mkdir $ALACRITTY_DIR
[ ! -d $NVIM_DIR ] && mkdir $NVIM_DIR

cp -r ./nvim/* $NVIM_DIR
cp ./alacritty.yml $ALACRITTY_DIR/alacritty.yml
cp ./.tmux.conf ~/.tmux.conf
