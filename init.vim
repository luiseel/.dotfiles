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
set termguicolors
set incsearch
set nohlsearch
set cc=80 

" Plugins
call plug#begin()
" Emmet for frontend development.
Plug 'mattn/emmet-vim'

" I <3 editorconfig.
Plug 'editorconfig/editorconfig-vim'

" Telescope and deps.
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" LSP
Plug 'neovim/nvim-lspconfig'
call plug#end()

" Mappings
let mapleader=" "

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>e <cmd>Explore<cr>

nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua <<EOF
require'telescope'.setup{ defaults = { file_ignore_patterns = { '.git' } } }

require'nvim-treesitter.configs'.setup{
  ensure_installed = {
    "typescript",
    "lua",
    "javascript",
    "java",
    "rust"
  },
  highlight = {
     enable = true,
  },
  indent = {
     enable = true
  },
}
EOF
