return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify(
          "nvim-treesitter is not available. Run ':Lazy sync' to reinstall plugins.",
          vim.log.levels.ERROR
      )
      return
    end

    configs.setup(
        {
          ensure_installed = {
            'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'rust', 'yaml',
            'json', 'prisma', 'tsx', 'zig', 'java', 'vue', 'css', 'scss'
          },
          sync_install = false,
          auto_install = true,
          highlight = {enable = true, additional_vim_regex_highlighting = false},
          indent = {enable = true}
        }
    )
  end
}
