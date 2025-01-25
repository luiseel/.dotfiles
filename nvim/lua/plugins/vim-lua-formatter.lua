return {
    {
        "andrejlevkovitch/vim-lua-format",
        lazy = false, -- Ensures it loads immediately
        config = function() vim.api.nvim_set_keymap('n', '<leader>o', ':call LuaFormat()<CR>', {noremap = true}) end
    }
}
