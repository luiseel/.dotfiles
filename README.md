# .dotfiles

I can factory reset my computer with confidence.

## Install

Install [Packer](https://github.com/wbthomason/packer.nvim).

Clone the repository.
```sh
git clone https://github.com/luiseel/.dotfiles ~/.config/.dotfiles
```

`cd` to cloned repo.
```sh
cd ~/.config/.dotfiles
```

Add execution permission to install script.
```sh
chmod +x install.sh
```

Execute install script.
```sh
./install.sh
```

Open neovim and sync plugins.
```
:PackerSync
```
