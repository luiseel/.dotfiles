local jdtls_bin = vim.fn.exepath('jdtls')
if jdtls_bin == '' then
  vim.notify('jdtls not found. Install via: brew install jdtls', vim.log.levels.WARN)
  return
end

local jdtls = require('jdtls')

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

-- Find a Java 21+ installation for running jdtls itself.
-- The project can still target older Java versions via runtimes config.
local function find_jdtls_java()
  local mise_java_dir = vim.fn.expand('~/.local/share/mise/installs/java')
  if vim.fn.isdirectory(mise_java_dir) == 1 then
    local handle = vim.loop.fs_scandir(mise_java_dir)
    if handle then
      while true do
        local name = vim.loop.fs_scandir_next(handle)
        if not name then break end
        local version = name:match('(%d+)')
        if version and tonumber(version) >= 21 then
          local java_path = mise_java_dir .. '/' .. name .. '/bin/java'
          if vim.fn.executable(java_path) == 1 then
            return mise_java_dir .. '/' .. name
          end
        end
      end
    end
  end
  return nil
end

-- Collect all mise Java installations as runtimes
local function get_runtimes()
  local runtimes = {}
  local mise_java_dir = vim.fn.expand('~/.local/share/mise/installs/java')
  if vim.fn.isdirectory(mise_java_dir) == 1 then
    local handle = vim.loop.fs_scandir(mise_java_dir)
    if handle then
      while true do
        local name = vim.loop.fs_scandir_next(handle)
        if not name then break end
        local path = mise_java_dir .. '/' .. name
        if vim.fn.executable(path .. '/bin/java') == 1 then
          local version = name:match('(%d+)')
          if version then
            table.insert(runtimes, {name = 'JavaSE-' .. version, path = path})
          end
        end
      end
    end
  end
  return runtimes
end

local jdtls_java_home = find_jdtls_java()

local cmd = {jdtls_bin, '-data', workspace_dir}
if jdtls_java_home then
  table.insert(cmd, 2, '--java-executable')
  table.insert(cmd, 3, jdtls_java_home .. '/bin/java')
end

local config = {
  cmd = cmd,
  root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'}),
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  settings = {
    java = {
      configuration = {
        runtimes = get_runtimes(),
      },
    },
  },
}

jdtls.start_or_attach(config)
