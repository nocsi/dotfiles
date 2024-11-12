return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- { 'folke/neodev.nvim', config = true },
      {
        "nvim-java/nvim-java",
      },
      "mrcjkb/rustaceanvim",
      "nvimtools/none-ls.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
      },
      {
        "yioneko/nvim-vtsls",
      },
      {
        "mrcjkb/haskell-tools.nvim",
        version = "^3", -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      {
        "https://git.sr.ht/~p00f/clangd_extensions.nvim",
      },
    },
    config = function()
      local lspconfig = require "lspconfig"
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
      local handlers = {
        rust_analyzer = function() end, -- use rustaceanvim
        jdtls = function() require("java").setup() end, -- use nvim-jdtls
        hls = function() end, -- use haskell-tools
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
          },
        },
        clangd = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Both",
              },
              hint = {
                enable = true,
                arrayIndex = "Disable",
              },
              telemetry = {
                enable = true,
              },
            },
          },
        },
      }
      -- if vim.fn.executable('ccls') == 1 then
      --   handlers.clangd = function() end
      --   require('lspconfig').ccls.setup({})
      -- end
      require("mason-lspconfig").setup {
        ensure_installed = {
          "clangd",
          "lua_ls",
          "rust_analyzer",
          "marksman",
          "jdtls",
          "powershell_es",
          "ltex",
          "clangd",
        },
        handlers = handlers,
      }
      local null_ls = require "null-ls"
      null_ls.setup {
        sources = {
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.hover.dictionary,
          null_ls.builtins.hover.printenv,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "single" },
      PATH = "append",
    },
    config = function(_, opts) require("mason").setup(opts) end,
  },
}
