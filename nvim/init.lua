require('plugins')

-- Editor options
-- vim.opt.clipboard = 'unnamed'
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
vim.cmd [[colorscheme PaperColor]]

-- Remaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>h', '<C-w>h')
vim.keymap.set('n', '<leader>j', '<C-w>j')
vim.keymap.set('n', '<leader>k', '<C-w>k')
vim.keymap.set('n', '<leader>l', '<C-w>l')
vim.keymap.set('n', '<leader>v', '<C-w>v')
vim.keymap.set('n', '<leader>s', '<C-w>s')
vim.keymap.set('n', '<leader>bn', ':bn<CR>')
vim.keymap.set('n', '<leader>bm', ':bp<CR>')
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>')

-- Remaps Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.git_files, {})

require'nvim-treesitter.configs'.setup {
        ensure_installed = {
                'c',
                'lua',
                'vim',
                'vimdoc',
                'query',
                'javascript',
                'typescript',
                'rust',
                'yaml',
                'json'
        },
        sync_install = false,
        auto_install = true,
        highlight = {
                indent = true,
                enable = true,
                additional_vim_regex_highlighting = false,
        },
}

local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
        'tsserver',
        'eslint',
})

lsp.nvim_workspace()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
})
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
        mapping = cmp_mappings
})

lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local lualine = require('lualine')
lualine.setup({
        options = {
                theme = 'papercolor'
        }
})

require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
                width = 40,
        },
        filters = {
                dotfiles = false,
        },
})
