-- local buffer = require "util.buffer"

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "vrischmann/tree-sitter-templ",
  },
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "astro",
      "bash",
      "c",
      "clojure",
      "c_sharp",
      "css",
      "csv",
      "cpp",
      "dockerfile",
      "dot",
      "eex",
      "elixir",
      "elm",
      "embedded_template",
      -- "erlang",
      "git_config",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "heex",
      "html",
      "java",
      "javascript",
      "json",
      "json5",
      "lua",
      "make",
      "markdown",
      "ocaml",
      "ocaml_interface",
      "ocamllex",
      "pkl",
      "php",
      "python",
      "rubyregex",
      "ruby",
      "rust",
      "scss",
      "sql",
      "svelte",
      "terraform",
      "toml",
      "typescript",
      "tsv",
      "tsx",
      "v",
      "vim",
      "yaml",
      "zig",
      -- add more arguments for adding more treesitter parsers
    })
  end,
  highlight = {
    enable = true,
    disable = function(_, buf)
      if buf.is_large(buf) then return true end
    end,
  },
  incremental_selection = {
    enable = false,
  },
  indent = {
    enable = true,
    disable = function(lang, buf)
      if lang == "html" or lang == "ruby" or lang == "rust" or buf.is_large(buf) then
        -- Disable indent for certain filetypes & large files.
        return true
      end
    end,
  },

  -- For nvim-treesitter-endwise plugin.
  endwise = {
    enable = true,
  },
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}
