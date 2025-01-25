return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        local nvimtree = require("nvim-tree")

        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({sort_by = "case_sensitive", view = {width = 40}, filters = {dotfiles = false}})
    end
}
