" General
set clipboard+=unnamed
set mouse=a
set rnu
set nu
set nobackup
set noswapfile
set guicursor=
set hidden
set noerrorbells
set smartcase
set incsearch
set nohlsearch
set expandtab
set shiftwidth=4
set nowrap
set cursorline
" set termguicolors
set wildignore=node_modules/**,build/**,dist/**

" Fix by https://github.com/nvim-telescope/telescope.nvim/issues/2145
hi NormalFloat ctermfg=LightGrey


" Plugins
call plug#begin()
" Emmet for frontend development
Plug 'mattn/emmet-vim'

" I <3 editorconfig
Plug 'editorconfig/editorconfig-vim'

" Telescope and deps
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP
Plug 'neovim/nvim-lspconfig'

" Automatically make directories for new files
Plug 'arp242/auto_mkdir2.vim'
 
" Prettier for JavaScript or TypeScript development
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Copilot
Plug 'github/copilot.vim'

Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

" Mappings
let mapleader=" "

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>e <cmd>NvimTreeToggle<cr>
nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<cr>

nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua <<EOF
-- Telescope config
require'telescope'.setup{ defaults = { file_ignore_patterns = { '.git' } } }

-- Treesitter config
require'nvim-treesitter.configs'.setup{
    ensure_installed = {
        "typescript",
        "lua",
        "javascript",
        "rust",
        "python"
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
}

-- Loads lspconfig
require'lspconfig'.tsserver.setup{
    on_attach = function()
       vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer=0})
       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer=0})
    end
}

require'lspconfig'.pyright.setup{}

-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
EOF
