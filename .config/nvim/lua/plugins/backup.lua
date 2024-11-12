local lazy_cmds = vim.api.nvim_create_augroup("lazy_cmds", { clear = true })
local snapshot_dir = vim.fn.stdpath "data" .. "/plugin-snapshot"
local lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json"

return {
  {
    vim.api.nvim_create_user_command("BrowseSnapshots", "edit " .. snapshot_dir, {}),

    vim.api.nvim_create_autocmd("User", {
      group = lazy_cmds,
      pattern = "LazyUpdatePre",
      desc = "Backup lazy.nvim lockfile",
      callback = function(event)
        vim.fn.mkdir(snapshot_dir, "p")
        local snapshot = snapshot_dir .. os.date "/%Y-%m-%dT%H:%M:%S.json"

        vim.loop.fs_copyfile(lockfile, snapshot)
      end,
    }),

    {
      "p00f/clangd_extensions.nvim", -- install lsp plugin
      lazy = true,
      init = function()
        -- load clangd extensions when clangd attaches
        local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
          group = augroup,
          desc = "Load clangd_extensions with clangd",
          callback = function(args)
            if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
              require "clangd_extensions"
              -- add more `clangd` setup here as needed such as loading autocmds
              vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
            end
          end,
        })
      end,
    },
  },
}
