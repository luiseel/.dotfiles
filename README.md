# .dotfiles

My personal configs.

## Requirements

- [stow](https://www.gnu.org/software/stow/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [git](https://git-scm.com/)
- [tmux](https://tmux.github.io/)
- [ghostty](https://ghostty.org/) (optional, app install is manual; config is stowed via XDG)
- [neovim](https://neovim.io/)
- [cmake](https://cmake.org/)
- [delta](https://github.com/dandavison/delta) (used as git pager)
- [Node.js](https://nodejs.org/) + npm
- [yarn](https://yarnpkg.com/)
- [lua-language-server](https://github.com/LuaLS/lua-language-server)
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- [vue-language-server](https://github.com/vuejs/language-tools)
- [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (eslint)
- [luaformatter](https://github.com/Koihik/LuaFormatter)
- [luarocks](https://luarocks.org/) (macOS only, used to install LuaFormatter)

## Install

Clone the repository.

```sh
git clone https://github.com/luiseel/.dotfiles ~/.config/.dotfiles
```

`cd` to cloned repo.

```sh
cd ~/.config/.dotfiles
```

Run the install script (supports macOS and Ubuntu).

```sh
./install.sh
```

To check what is already installed:

```sh
./install.sh check
```

To skip Node.js, Yarn, and global npm packages:

```sh
./install.sh --skip-node
```

The installer also bootstraps Neovim plugins with `lazy.nvim`.

### Manual setup

If you prefer to install dependencies yourself, link the dotfiles with stow:

```sh
stow --no-folding -t ~ ghostty nvim tmux
```

Ghostty config is stored at `~/.config/ghostty/config.ghostty`.

Then bootstrap Neovim plugins once:

```sh
nvim --headless "+Lazy! sync" +qa
```

If `nvim-treesitter.configs` is missing on a fresh machine, the local plugin checkout is incomplete. Run `:Lazy sync` inside Neovim or rerun the headless command above.
