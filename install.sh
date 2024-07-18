#/bin/sh

CONFIG_DIR=~/.config
NVIM_DIR=~/.config/nvim
KITTY_DIR=~/.config/kitty

[ ! -d $CONFIG_DIR ] && mkdir $CONFIG_DIR
[ ! -d $NVIM_DIR ] && mkdir $NVIM_DIR
[ ! -d $KITTY_DIR ] && mkdir $KITTY_DIR

ln -sf $(pwd)/nvim/* $CONFIG_DIR/nvim
ln -sf $(pwd)/.tmux.conf ~/.tmux.conf

git clone https://github.com/rose-pine/kitty.git $KITTY_DIR/themes
ln -sf $(pwd)/kitty/kitty.conf $KITTY_DIR/kitty.conf
ln -sf $KITTY_DIR/themes/dist/rose-pine-dawn.conf $KITTY_DIR/theme.conf
