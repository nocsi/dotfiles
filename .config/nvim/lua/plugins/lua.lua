return {
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- Do not auto-install `selene`
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "stylua" })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = function(_, opts)
      -- Do not auto-install `selene`
      opts.ensure_installed =
        require("astrocore").list_insert_unique(opts.ensure_installed, { "lua-language-server", "stylua" })
    end,
  },
}
