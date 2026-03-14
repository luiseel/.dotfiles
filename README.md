# .dotfiles

My personal configs.

## Requirements

- [stow](https://www.gnu.org/software/stow/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [git](https://git-scm.com/)
- [tmux](https://tmux.github.io/)
- [tpm](https://github.com/tmux-plugins/tpm)
- [ghostty](https://ghostty.org/)
- [neovim](https://neovim.io/)
- [Node.js](https://nodejs.org/) + npm
- [yarn](https://yarnpkg.com/)
- [lua-language-server](https://github.com/LuaLS/lua-language-server)
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- [vue-language-server](https://github.com/vuejs/language-tools)
- [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (eslint)
- [luaformatter](https://github.com/Koihik/LuaFormatter)

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

The installer also bootstraps Neovim plugins with `lazy.nvim`.

### Manual setup

If you prefer to install dependencies yourself, link the dotfiles with stow:

```sh
stow --no-folding -t ~ ghostty nvim tmux
```

Then bootstrap Neovim plugins once:

```sh
nvim --headless "+Lazy! sync" +qa
```

If `nvim-treesitter.configs` is missing on a fresh machine, the local plugin checkout is incomplete. Run `:Lazy sync` inside Neovim or rerun the headless command above.
