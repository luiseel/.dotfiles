local M = {}

function M.run()
  local function bootstrap()
    assert(vim.fn.has('nvim-0.12') == 1, 'This config requires Neovim 0.12 or newer')
    assert(vim.v.errmsg == '', vim.v.errmsg)
    require('lazy').install({wait = true, show = false})
    require('lazy').restore({wait = true, show = false})
    for name, plugin in pairs(require('lazy.core.config').plugins) do
      for _, task in ipairs(plugin._.tasks or {}) do
        assert(not task:has_errors(), 'Plugin bootstrap failed: ' .. name)
      end
    end
    require('config.treesitter').install()
    assert(vim.v.errmsg == '', vim.v.errmsg)
  end
  local ok, err = xpcall(bootstrap, debug.traceback)
  if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd('cquit 1')
  else
    vim.cmd('qa!')
  end
end

return M
