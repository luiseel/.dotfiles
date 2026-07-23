return {
  "AlexandrosAlexiou/kotlin.nvim",
  ft = "kotlin",
  dependencies = {
    {"mason-org/mason.nvim", opts = {}},
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {"mason-org/mason.nvim"},
      opts = {ensure_installed = {"kotlin_lsp"}}
    },
    {"stevearc/oil.nvim", opts = {}},
    {"folke/trouble.nvim", opts = {}}
  },
  config = function()
    require("kotlin").setup(
        {
          -- JDK used to resolve external/library symbols. Point this at a JDK
          -- matching your project's target version.
          jdk_for_symbol_resolution = vim.fn.expand("$JAVA_HOME")
        }
    )
  end
}
