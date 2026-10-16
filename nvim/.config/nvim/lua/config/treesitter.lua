local M = {}
local install_dir = vim.fn.stdpath('data') .. '/site'

M.parsers = {
  'c', 'lua', 'vim', 'vimdoc', 'query', 'javascript', 'typescript', 'rust', 'yaml', 'json',
  'prisma', 'tsx', 'zig', 'java', 'kotlin', 'vue', 'css', 'scss'
}

local function attach(buf, lang)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.treesitter.language.get_lang(vim.bo[buf].filetype) ~= lang then return end
  vim.treesitter.start(buf, lang)
  if vim.treesitter.query.get(lang, 'indents') then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

function M.setup()
  local ts = require('nvim-treesitter')
  vim.fn.mkdir(install_dir .. '/parser', 'p')
  ts.setup({install_dir = install_dir})
  vim.api.nvim_create_autocmd(
      'FileType', {
        group = vim.api.nvim_create_augroup('dotfiles_treesitter', {clear = true}),
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
          if not lang then return end
          if vim.treesitter.language.add(lang) then
            attach(event.buf, lang)
          elseif vim.tbl_contains(ts.get_available(), lang) then
            -- Preserve automatic parser installation for additional filetypes.
            ts.install({lang}):await(
                function(err, installed)
                  vim.schedule(
                      function()
                        if err or not installed then
                          vim.notify(
                              'Could not install Treesitter parser: ' .. lang, vim.log.levels.ERROR
                          )
                        else
                          vim.opt.rtp:prepend(install_dir)
                          attach(event.buf, lang)
                        end
                      end
                  )
                end
            )
          end
        end
      }
  )
end

function M.install()
  local ts = require('nvim-treesitter')
  assert(ts.update():wait(300000), 'Treesitter parser update failed')
  local ok = ts.install(M.parsers):wait(300000)
  assert(ok, 'Treesitter parser installation failed')
  -- Refresh runtime lookup after installing into a previously missing directory.
  vim.opt.rtp:prepend(install_dir)
  for _, lang in ipairs(M.parsers) do
    local loaded, err = vim.treesitter.language.add(lang)
    assert(loaded, err or ('Missing parser: ' .. lang))
  end
end

return M
