-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "bashls",
        "cssls",
        "cssmodules_ls",
        "dockerls",
        "docker_compose_language_service",
        "earthlyls",
        "elixirls",
        -- "erlangls",
        "eslint", -- Javascript, Typescript
        "gopls", -- Golang
        "golangci_lint_ls", -- Golang
        "html",
        "htmx",
        "jsonls",
        "lemminx", -- XML
        "lexical", -- Elixir
        "lua_ls",
        "marksman", -- Markdown
        "pyright", -- Python
        "rust_analyzer",
        "sqlls",
        "taplo", -- TOML
        -- "tsserver", -- Javascript, Typescript
        "vimls",
        "yamlls",
        "zk", -- Markdown
        "zls", -- Zig
        -- add more arguments for adding more language servers
      })
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "biome", -- Javascript, Typescript
        "gofumpt",
        "goimports",
        "golangci-lint", -- Golang
        "gomodifytags",
        "htmlhint",
        "nilaway", -- Golang
        "prettier", -- Javascript, Typescript
        "rubocop",
        "ruff", -- Python
        "shellcheck",
        "shellharden",
        "sqlfluff",
        "standardjs",
        "staticcheck", -- Golang
        "stylua", -- Lua
        "systemdlint",
        "tflint",
        "tfsec",
        "trivy", -- Many languages
        "vacuum", -- OpenAPI / Swagger
        "yamllint",
        -- add more arguments for adding more null-ls sources
      })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
        "python",
        -- add more arguments for adding more debuggers
      })
    end,
  },
}
