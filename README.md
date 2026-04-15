# .dotfiles

Personal development environment configs for **Neovim**, **tmux**, and **Ghostty**, managed with [GNU Stow](https://www.gnu.org/software/stow/) and a single `./dot` install script. Supports macOS (Homebrew) and Ubuntu (apt).

## What's included

| Directory | What it configures |
|-----------|-------------------|
| `nvim/`   | Neovim (v0.11.7) with LSP, Treesitter, telescope, nvim-tree, and lazy.nvim plugin management |
| `tmux/`   | tmux with TPM, Rose Pine Moon theme, vi keybindings, and vim-style pane navigation |
| `ghostty/`| Ghostty terminal with Rose Pine Moon theme and Google Sans Code font |

### Neovim highlights

- **LSP servers:** Lua, TypeScript, Vue, ESLint, Java (via nvim-java)
- **Treesitter parsers:** C, Lua, Vim, JavaScript, TypeScript, TSX, Rust, Zig, Java, Vue, CSS, SCSS, JSON, YAML, Prisma
- **Plugins:** telescope.nvim, nvim-tree, nvim-cmp, lualine, nvim-colorizer, emmet-vim, prettier
- **Theme:** Rose Pine Moon
- **Leader key:** `<space>`

### tmux highlights

- Mouse support, vi mode-keys, base index 1
- Split with `|` / `-`, navigate panes with `h/j/k/l`
- 200k line scrollback, status bar at top

## Requirements

- [stow](https://www.gnu.org/software/stow/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)
- [git](https://git-scm.com/)
- [tmux](https://tmux.github.io/)
- [ghostty](https://ghostty.org/) (optional, app install is manual; config is stowed via XDG)
- [neovim](https://neovim.io/) (v0.11.7, installed automatically by `./dot install`)
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

All of the above (except Ghostty) are installed automatically by `./dot install`.

## Install

Clone the repository:

```sh
git clone https://github.com/luiseel/.dotfiles ~/.config/.dotfiles
cd ~/.config/.dotfiles
```

Run the install script:

```sh
./dot install
```

This will detect your OS, install all dependencies, link dotfiles via stow, install TPM, and bootstrap Neovim plugins with lazy.nvim.

### Options

```sh
./dot install --dry-run     # Show what is installed and what is missing
./dot install --skip-node   # Skip Node.js, Yarn, and global npm packages
```

### Reapply configs

To relink dotfiles and re-bootstrap Neovim plugins without reinstalling dependencies:

```sh
./dot apply
```

## Docker verification

Build the `verify` target to test the Ubuntu bootstrap path in a container:

```sh
docker build --target verify -t dotfiles-verify .
```

That target checks that:

- tmux can start with this config before TPM is installed
- `./dot install` provisions TPM in the expected path
- the Neovim LSP config keeps `ts_ls` off `.vue` buffers while `vue_ls` owns them

## Manual setup

If you prefer to install dependencies yourself, link the dotfiles with stow:

```sh
stow --no-folding -t ~ ghostty nvim tmux
```

Then bootstrap Neovim plugins once:

```sh
nvim --headless "+Lazy! sync" +qa
```

If `nvim-treesitter.configs` is missing on a fresh machine, the local plugin checkout is incomplete. Run `:Lazy sync` inside Neovim or rerun the headless command above.
