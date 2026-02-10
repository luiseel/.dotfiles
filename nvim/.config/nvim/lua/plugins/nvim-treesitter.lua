return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.10.0",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter")
    configs.setup(
        {
          ensure_installed = {
            'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'rust', 'yaml', 'json', 'prisma', 'tsx', 'zig', 'java'
          },
          sync_install = false,
          auto_install = true,
          highlight = {indent = true, enable = true, additional_vim_regex_highlighting = false}
        }
    )
  end
}
