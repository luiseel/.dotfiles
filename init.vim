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
set scrolloff=24
set smartcase
set termguicolors
set incsearch
set nohlsearch

" Plugins
call plug#begin()
" Emmet for frontend development.
Plug 'mattn/emmet-vim'

" I <3 editorconfig.
Plug 'editorconfig/editorconfig-vim'

" Telescope and deps.
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
call plug#end()

" Mappings
let mapleader=" "

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>c :Config<CR>
inoremap <C-e> <C-y>,
nnoremap <leader>x :bd!<CR>

nnoremap <leader>ff <cmd>Telescope find_files hidden=true<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
