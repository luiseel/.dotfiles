#/bin/sh

CONFIG_DIR=~/.config
NVIM_DIR=~/.config/nvim

[ ! -d $CONFIG_DIR ] && mkdir $CONFIG_DIR
[ ! -d $NVIM_DIR ] && mkdir -p $NVIM_DIR

ln -sf $(pwd)/nvim/* $CONFIG_DIR/nvim
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf
