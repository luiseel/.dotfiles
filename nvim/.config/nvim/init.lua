require("config.lazy")

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
local java_ok, java = pcall(require, 'java')

if java_ok then java.setup({spring_boot_tools = {enable = false}}) end

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd(
    'LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
      end
    }
)

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = {
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<up>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<down>'] = cmp.mapping.select_next_item(cmp_select),
  ['<CR>'] = cmp.mapping.confirm({select = true}),
  ["<C-Space>"] = cmp.mapping.complete()
}
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil
cmp.setup(
    {
      completion = {completeopt = 'menu,menuone,noinsert'},
      mapping = cmp_mappings,
      sources = {{name = 'nvim_lsp'}, {name = 'buffer'}}
    }
)

vim.lsp.config(
    'lua_ls', {
      cmd = {'lua-language-server'},
      root_markers = {
        '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml',
        'selene.yml', '.git'
      },
      capabilities = default_capabilities,
      settings = {
        Lua = {
          diagnostics = {globals = {'vim'}},
          workspace = {library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false}
        }
      }
    }
)

local npm_global_root = vim.fn.system('npm root -g'):gsub('\n', '')

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = npm_global_root .. '/@vue/language-server',
  languages = {'vue'},
  configNamespace = 'typescript'
}

vim.lsp.config(
    'ts_ls', {
      cmd = {'typescript-language-server', '--stdio'},
      root_markers = {'tsconfig.json', 'jsconfig.json', 'package.json', '.git'},
      capabilities = default_capabilities,
      filetypes = {
        'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact',
        'typescript.tsx', 'vue'
      },
      init_options = {plugins = {vue_plugin}}
    }
)

vim.lsp.config(
    'vue_ls', {
      cmd = {'vue-language-server', '--stdio'},
      filetypes = {'vue'},
      root_markers = {'package.json', '.git'},
      capabilities = default_capabilities,
      init_options = {typescript = {tsdk = npm_global_root .. '/typescript/lib'}}
    }
)

vim.lsp.config(
    'eslint', {
      cmd = {'vscode-eslint-language-server', '--stdio'},
      root_markers = {
        '.eslintrc', '.eslintrc.js', '.eslintrc.json', 'eslint.config.js', 'package.json', '.git'
      },
      capabilities = default_capabilities
    }
)

vim.lsp.config('jdtls', {capabilities = default_capabilities})

vim.lsp.enable({'lua_ls', 'ts_ls', 'eslint', 'vue_ls', 'jdtls'})
