-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
                'nvim-telescope/telescope.nvim', tag = '0.1.1',
                requires = { {'nvim-lua/plenary.nvim'} }
        }
        use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
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
        use('nvim-treesitter/playground')
        use('mattn/emmet-vim')
        use('github/copilot.vim')
        use {
                'nvim-lualine/lualine.nvim',
                requires = { 'nvim-tree/nvim-web-devicons', opt = true }
        }
        use('nvim-tree/nvim-tree.lua')
        use('nvim-tree/nvim-web-devicons')
        use('NLKNguyen/papercolor-theme')
end)