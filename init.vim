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
set termguicolors

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

Plug 'nvim-lualine/lualine.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'NLKNguyen/papercolor-theme'
call plug#end()

set background=dark
colorscheme PaperColor

" Mappings
let mapleader=" "

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
        "python", 
        "c",
        "cpp",
        "java",
        "css",
        "html",
        "sql",
        "yaml"
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
}

-- Loads lspconfig

-- require'lspconfig'.pyright.setup{}

-- require'lspconfig'.ccls.setup{}

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  filters = {
    dotfiles = true,
  },
})

require('lualine').setup()

local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  require('lspconfig')['tsserver'].setup {
    capabilities = capabilities,
    filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
    cmd = { "typescript-language-server", "--stdio" },
    on_attach = function()
       vim.keymap.set('n', 'K', vim.lsp.buf.hover())
       vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition())
    end
  }
EOF

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
nnoremap <leader>e <cmd>NvimTreeFindFileToggle<cr>
nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<cr>

nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
