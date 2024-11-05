-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.elixir-phoenix" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.just" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.pkl" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.motion.nvim-surround" },
  { import = "astrocommunity.recipes.telescope-nvchad-theme" },
  {
    import = "astrocommunity.lsp.nvim-lint",
    opts = {
      linters_by_ft = {
        clojure = { "clj-kondo" },
        cmakefile = { "cmakelint" },
        cpp = { "clangtidy", "cppcheck", "cpplint", "flawfinder" },
        css = { "stylelint" },
        dotenv = { "dotenv_linter" },
        elixir = { "credo" },
        dockerfile = { "hadolint", "trivy" },
        haskell = { "hlint" },
        go = { "golangcilint", "revive" },
        java = { "checkstyle" },
        javascript = { "biomejs", "eslint", "jshint", "standardjs" },
        json = { "jsonlint" },
        jsx = { "biomejs" },
        kotlin = { "ktlint" },
        latex = { "chktex", "lacheck" },
        lua = { "selene" },
        markdown = { "markdownlint", "vale" },
        nix = { "nix", "statix" },
        perl = { "checkpatch", "perlcritic", "perlimports" },
        php = { "php", "phpcs", "phpinsights", "phpmd", "phpstan", "psalm" },
        proto = { "buf_lint" },
        python = { "bandit", "flake8", "mypy", "pycodestyle", "pydocstyle", "pylint", "ruff", "vulture" },
        ruby = { "ruby", "rubocop", "standardrb" },
        shell = { "shellcheck" },
        sql = { "sqlfluff" },
        typescript = { "biomejs" },
        yaml = { "yamllint" },
        zsh = { "zsh" },
      },
    },
  },
  -- import/override with your plugins folder
}
