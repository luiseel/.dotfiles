return {
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {"neovim/nvim-lspconfig"},
  config = function()
    require('java').setup({spring_boot_tools = {enable = false}})
    vim.lsp.enable('jdtls')
  end
}
