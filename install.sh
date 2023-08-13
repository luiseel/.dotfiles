#/bin/sh

CONFIG_DIR=~/.config
ALACRITTY_DIR=~/.config/alacritty
NVIM_DIR=~/.config/nvim

[ ! -d $CONFIG_DIR ] && mkdir $CONFIG_DIR
[ ! -d $ALACRITTY_DIR ] && mkdir $ALACRITTY_DIR
[ ! -d $NVIM_DIR ] && mkdir $NVIM_DIR

git clone https://github.com/catppuccin/alacritty.git ~/.config/alacritty/catppuccin
ln -s nvim $CONFIG_DIR/nvim
ln -s alacritty.yml $CONFIG_DIR/alacritty.yml
ln -s .tmux.conf ~/.tmux.conf
