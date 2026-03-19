return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {"nvim-lua/plenary.nvim"},
  config = function()
    local builtin = require('telescope.builtin')

    -- Default (clean)
    vim.keymap.set(
        'n', '<leader>ff', function()
          builtin.find_files(
              {
                hidden = true -- show dotfiles
              }
          )
        end, {}
    )

    -- Full (includes gitignored files)
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

    -- live_grep also needs config separately
    vim.keymap.set(
        'n', '<leader>fg', function()
          builtin.live_grep({additional_args = function()
            return {"--hidden", "--no-ignore"}
          end})
        end, {}
    )

    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fs', builtin.git_files, {})
  end
}
