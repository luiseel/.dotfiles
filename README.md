# .dotfiles

Personal development environment configs for **Neovim**, **tmux**, **herdr**, and **Ghostty**, managed with [GNU Stow](https://www.gnu.org/software/stow/) and a single `./dot` install script. Supports macOS (Homebrew) and Ubuntu (apt).

## What's included

| Directory | What it configures |
|-----------|-------------------|
| `nvim/`   | Neovim (v0.12.5) with LSP, Treesitter, telescope, nvim-tree, and lazy.nvim plugin management |
| `tmux/`   | tmux with TPM, Rose Pine Moon theme, vi keybindings, and vim-style pane navigation |
| `herdr/`  | herdr agent multiplexer with Rose Pine theme and tmux-style keybindings |
| `claude/` | Claude Code status line script (model, repo, worktree, context, cost, rate limits) |
| `ghostty/`| Ghostty terminal with Rose Pine Moon theme and Google Sans Code font |

### Neovim highlights

- **LSP servers:** Lua, TypeScript, Vue (hybrid mode), ESLint, Java (via nvim-java), Kotlin (via kotlin.nvim + Mason)
- **Treesitter parsers:** C, Lua, Vim, VimDoc, Query, JavaScript, TypeScript, TSX, Rust, Zig, Java, Kotlin, Vue, CSS, SCSS, JSON, YAML, Prisma
- **Plugins:** telescope.nvim, fff.nvim, nvim-tree, nvim-cmp, lualine, nvim-colorizer (catgoose fork), emmet-vim, vim-prettier, vim-lua-format, nvim-java, kotlin.nvim, vim-jsx-improve, vim-pico8-syntax
- **Plugin versions:** pinned in `lazy-lock.json`
- **Theme:** Rose Pine Moon
- **Leader key:** `<space>`

### tmux highlights

- Mouse support, vi mode-keys, base index 1
- Split with `|` / `-`, navigate panes with `h/j/k/l`, resize with `H/J/K/L`
- Even layouts with `=` (horizontal) / `+` (vertical), reload config with `r`
- Plugins: tmux-sensible, tmux-menus
- 200k line scrollback, status bar at top

### herdr highlights

- Same prefix as tmux (`ctrl+b`) and the same pane keys: `|` / `-` to split, `h/j/k/l` to move
- `prefix+r` reloads the config; resize mode moves to `prefix+shift+r`
- Rose Pine theme, 20 MB pane scrollback

## Requirements

- [stow](https://www.gnu.org/software/stow/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [jq](https://jqlang.org/) (Claude Code status line)
- [fd](https://github.com/sharkdp/fd)
- [git](https://git-scm.com/)
- [tmux](https://tmux.github.io/)
- [herdr](https://herdr.dev/) (macOS only in `./dot install`; on Ubuntu install it manually)
- [ghostty](https://ghostty.org/) (optional, app install is manual; config is stowed via XDG)
- [neovim](https://neovim.io/) (v0.12.5, installed automatically by `./dot install`)
- [cmake](https://cmake.org/)
- [Node.js](https://nodejs.org/) + npm
- [yarn](https://yarnpkg.com/)
- [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter/tree/master/cli) v0.26.7 (pinned native release, installed privately alongside Neovim)
- [lua-language-server](https://github.com/LuaLS/lua-language-server)
- [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server)
- [vue-language-server](https://github.com/vuejs/language-tools)
- [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) (eslint)
- [luaformatter](https://github.com/Koihik/LuaFormatter)
- [luarocks](https://luarocks.org/) (macOS only, used to install LuaFormatter)
- A JDK with `$JAVA_HOME` set (Kotlin symbol resolution; not installed by `./dot install`)

All of the above (except Ghostty, the JDK, and herdr on Ubuntu) are installed automatically by `./dot install`.

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

### Commands

```sh
./dot install               # Install dependencies, link dotfiles, bootstrap plugins
./dot install --dry-run     # Show what is installed and what is missing
./dot install --skip-node   # Skip Node.js, Yarn, and global npm packages
./dot apply                 # Relink dotfiles and bootstrap Neovim plugins
./dot nvim-install          # Install the pinned Neovim and tree-sitter CLI
./dot nvim-bootstrap        # Restore locked plugins and install parsers
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

- the same `./dot nvim-install` and `./dot apply` path provisions Neovim, plugins, parsers, and TPM
- Vue hybrid mode retains both `ts_ls` and `vue_ls`, with request forwarding
- Lua, TypeScript, and Vue samples parse and have Treesitter highlighting enabled
- Kotlin asynchronous parsing and highlighting work with the installed runtime

## Manual setup

If you prefer to install dependencies yourself, link the dotfiles with stow:

```sh
stow --no-folding -t ~ claude ghostty herdr nvim tmux
```

Then bootstrap Neovim plugins once:

```sh
./dot nvim-bootstrap
```

The config uses nvim-treesitter's `main` API and requires Neovim 0.12 or newer.
Bootstrap restores `lazy-lock.json` and waits for parser installation; errors fail
the command. Use `:Lazy update` only for intentional plugin updates, then review
and commit the lockfile. Additional supported filetypes install their parsers automatically;
you can also use `:TSInstall <language>`.

## Neovim setup and verification

Neovim uses the normal `~/.config/nvim` configuration and data directories.
The installer keeps complete, versioned Neovim and tree-sitter distributions
under `${XDG_DATA_HOME:-~/.local/share}/dotfiles/tools`. Its launcher prepends the
matching private tree-sitter CLI to Neovim's PATH.

To install the pinned editor and bootstrap its plugins:

```sh
./dot nvim-install
./dot apply
```

Before replacing an existing configuration, back up and move aside conflicting
physical files in `~/.config/nvim` so Stow can link the repository configuration.
When migrating from nvim-treesitter's old `master` branch, preserve the old plugin
and parser directories and bootstrap the new ones together. Keep the old complete
Neovim distribution for rollback; replacing only its executable mixes binary and
runtime versions.

Java tooling is installed on first opening a Java file. On first opening a Kotlin
file, Mason installs `kotlin_lsp`.

Run the automated smoke check with:

```sh
nvim --headless -i NONE -S scripts/verify-nvim.lua
```
