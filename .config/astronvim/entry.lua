local path_sep = vim.loop.os_uname().version:match("Windows") and "\\" or "/"
local join = function(...)
  return table.concat({ ... }, path_sep)
end
local getpath = function(arg)
  local path = vim.fn.stdpath(arg)
  return vim.fn.substitute(path, [[\(.*\)\zsnvim]], "astronvim", "")
end

local data_path = getpath("data")
local astro_config = join(data_path, "core")
local user_path = getpath("config")

vim.env.XDG_DATA_HOME = data_path
vim.env.XDG_CACHE_HOME = join(data_path, "cache")
vim.env.XDG_STATE_HOME = join(data_path, "state")

-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.opt.runtimepath = {
  user_path,
  astro_config,
  vim.env.VIMRUNTIME,
  join(astro_config, "after"),
  join(user_path, "after"),
}

vim.opt.packpath = {
  join(data_path, "nvim", "site"),
  user_path,
  vim.env.VIMRUNTIME,
}

astronvim_installation = { home = astro_config }

local execute = loadfile(join(astro_config, "init.lua"))

if not execute then
  vim.api.nvim_err_writeln("Could not load AstroNvim's init.lua")
  return
end

execute()
