return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  lazy = false,
  config = function()
    require('fff').setup({
      debug = {
        enabled = false,
        show_scores = false,
      },
    })

    vim.keymap.set('n', '<leader>ff', function() require('fff').find_files() end, { desc = 'FFF: find files' })
    vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep() end, { desc = 'FFF: live grep' })
    vim.keymap.set('n', '<leader>fz', function()
      require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } })
    end, { desc = 'FFF: fuzzy grep' })
    vim.keymap.set('n', '<leader>fc', function()
      require('fff').live_grep({ query = vim.fn.expand('<cword>') })
    end, { desc = 'FFF: search current word' })
  end,
}
