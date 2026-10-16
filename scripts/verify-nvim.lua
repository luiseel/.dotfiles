-- Run with the normal config loaded: nvim --headless -i NONE -S scripts/verify-nvim.lua
local function verify()
  assert(vim.v.errmsg == '', vim.v.errmsg)
  assert(vim.fn.has('nvim-0.12') == 1, 'Neovim 0.12 is required')

  -- Both clients are required by Vue's hybrid protocol, including its TS bridge.
  assert(vim.tbl_contains(vim.lsp.config.ts_ls.filetypes, 'vue'), 'ts_ls must handle Vue scripts')
  assert(vim.tbl_contains(vim.lsp.config.vue_ls.filetypes, 'vue'), 'vue_ls must handle Vue markup')
  assert(type(vim.lsp.config.vue_ls.on_init) == 'function', 'Vue request forwarding is missing')

  -- Exercise real parsers and FileType highlighting, not just successful requires.
  local samples = {
    lua = 'local answer = 42',
    typescript = 'const answer: number = 42;',
    vue = '<template><div>Hello</div></template>'
  }
  for ft, source in pairs(samples) do
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {source})
    vim.bo[buf].filetype = ft
    local tree = vim.treesitter.get_parser(buf):parse()[1]
    assert(not tree:root():has_error(), 'Parser rejected valid ' .. ft)
    assert(vim.treesitter.highlighter.active[buf], 'Highlighting is disabled for ' .. ft)
    vim.api.nvim_buf_delete(buf, {force = true})
  end
  -- Exercise the asynchronous parsing path used by Kotlin's highlighter.
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {'fun main() { println("Hello") }'})
  vim.treesitter.start(buf, 'kotlin')
  local done, parse_error, parsed = false, nil, nil
  vim.treesitter.get_parser(buf, 'kotlin'):parse(
      true, function(err, trees) done, parse_error, parsed = true, err, trees end
  )
  assert(vim.wait(5000, function() return done end), 'Kotlin parse timed out')
  assert(not parse_error, parse_error)
  assert(parsed and not parsed[1]:root():has_error(), 'Parser rejected valid Kotlin')
  vim.cmd('redraw')
  vim.api.nvim_buf_delete(buf, {force = true})
  assert(vim.v.errmsg == '', vim.v.errmsg)
  print('Neovim startup, Vue hybrid config, parsers, and Kotlin highlighting verified')
end
local ok, err = xpcall(verify, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd('cquit 1')
else
  vim.cmd('qa!')
end
