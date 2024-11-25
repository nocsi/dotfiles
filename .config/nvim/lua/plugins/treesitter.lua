-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "bash",
      "c",
      "c_sharp",
      "css",
      "csv",
      "cpp",
      "dockerfile",
      "dot",
      "eex",
      "elixir",
      "erlang",
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
      "markdown_inline",
      "ocaml",
      "ocaml_interface",
      "ocamllex",
      "php",
      "python",
      "regex",
      "ruby",
      "rust",
      "sql",
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
}
