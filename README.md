# .dotfiles

My dotfiles. Feel free to use them. 😉

## Requirements

- [stow](https://www.gnu.org/software/stow/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [git](https://git-scm.com/)
- [tmux](https://tmux.github.io/)
- [tpm](https://github.com/tmux-plugins/tpm)
- [neovim](https://neovim.io/)

## Install

Clone the repository.

```sh
git clone https://github.com/luiseel/.dotfiles ~/.config/.dotfiles
```

`cd` to cloned repo.

```sh
cd ~/.config/.dotfiles
```

Run stow.

```sh
stow --no-folding -t ~ nvim tmux
```
