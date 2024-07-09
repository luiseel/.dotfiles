-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
                'nvim-telescope/telescope.nvim', tag = '0.1.4',
                requires = { {'nvim-lua/plenary.nvim'} }
        }
        use {
                'VonHeikemen/lsp-zero.nvim',
                branch = 'v2.x',
                requires = {
                        {'neovim/nvim-lspconfig'},
                        {
                                'williamboman/mason.nvim',
                                run = function()
                                        pcall(vim.cmd, 'MasonUpdate')
                                end,
                        },
                        {'williamboman/mason-lspconfig.nvim'},
                        {'hrsh7th/nvim-cmp'},
                        {'hrsh7th/cmp-nvim-lsp'},
                        {'L3MON4D3/LuaSnip'},
                }
        }
        use('mattn/emmet-vim')
        use('github/copilot.vim')
        use {
                'nvim-lualine/lualine.nvim',
                requires = { 'nvim-tree/nvim-web-devicons', opt = true }
        }
        use('nvim-tree/nvim-tree.lua')
        use('nvim-tree/nvim-web-devicons')
        use('prettier/vim-prettier', {run = 'yarn install --forzen-lockfile --production'})
        use('neoclide/vim-jsx-improve')
        use {
                'nvim-treesitter/nvim-treesitter',
                run = ':TSUpdate'
        }
        use { "norcalli/nvim-colorizer.lua" }
        use { "rose-pine/neovim", as = "rose-pine" }
        -- use({
        --           'projekt0n/github-nvim-theme',
        --           config = function()
        --             require('github-theme').setup({})
        --             vim.cmd('colorscheme github_dark')
        --           end
        -- })

        -- use {
        --         'maxmx03/solarized.nvim',
        --          config = function()
        --                 vim.o.background = 'dark'

        --                 vim.cmd.colorscheme 'solarized'
        --         end
        -- }
        -- use {
        --         'ribru17/bamboo.nvim',
        --         config = function()
        --                require('bamboo').setup()
        --                require('bamboo').load()
        --         end
        -- }
        -- use {
        --         "loctvl842/monokai-pro.nvim",
        --         config = function()
        --                 require("monokai-pro").setup()
        --         end
        -- }
        -- use { 
        --         "gbprod/nord.nvim",
        --         config = function()
        --                 require('nord').setup()
        --                 vim.cmd.colorscheme('nord')
        --         end
        -- }
end)
