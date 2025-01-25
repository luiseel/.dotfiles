-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo(
        {{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"}, {"\nPress any key to exit..."}}, true, {}
    )
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

-- Editor options
vim.opt.rnu = true
vim.opt.nu = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.guicursor = ''
vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.ttimeoutlen = 10
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·,extends:→,precedes:←,nbsp:␣'

-- Remaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>v', '<C-w>v')
vim.keymap.set('n', '<leader>s', '<C-w>s')
vim.keymap.set('n', '<leader>bn', ':bn<CR>')
vim.keymap.set('n', '<leader>bm', ':bp<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>')
vim.keymap.set('n', '<leader>=', '<C-w>=')

-- Setup lazy.nvim
require("lazy").setup(
    {
      spec = {
        "neoclide/vim-jsx-improve", "nvim-tree/nvim-web-devicons", "github/copilot.vim", "mattn/emmet-vim",
        {'neovim/nvim-lspconfig'}, {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/nvim-cmp'}, {import = "plugins"}
      }
    }
)
