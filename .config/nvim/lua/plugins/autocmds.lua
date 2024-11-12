return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- first key is the augroup name
        terminal_settings = {
          -- the value is a list of autocommands to create
          {
            -- event is added here as a string or a list-like table of events
            event = "TermOpen",
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "Disable line number/fold column/sign column for terminals",
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.foldcolumn = "0"
              vim.opt_local.signcolumn = "no"
            end,
          },
        },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      automcds = {
        -- these autocommands will only be created in buffers where
        -- a language servers attaches
        lsp_codelens_refresh = {
          -- condition to create/delete auto command group
          -- can either be a string of a client capability
          -- or a function of `fun(client, bufnr): boolean`
          cond = "textDocument/codeLens",
          {
            -- events to trigger
            event = { "InsertLeave", "BufEnter" },
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "Refresh codelens (buffer)",
            callback = function(args) vim.lsp.codelens.refresh { bufnr = args.buf } end,
          },
        },
      },
    },
  },
}
