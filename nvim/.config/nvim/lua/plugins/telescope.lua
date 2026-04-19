return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim", {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
  },
  config = function()
    require('telescope').load_extension('fzf')
    local builtin = require('telescope.builtin')

    -- Full find files (includes gitignored files) - use <leader>fF for telescope fallback
    vim.keymap.set(
        'n', '<leader>fF', function()
          builtin.find_files(
              {
                hidden = true,
                no_ignore = true -- include .gitignore
              }
          )
        end, {}
    )

    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fc', builtin.lsp_document_symbols, {})
    vim.keymap.set('n', '<leader>fs', builtin.git_files, {})
  end
}
