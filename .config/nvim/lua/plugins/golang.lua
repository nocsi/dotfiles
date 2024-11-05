return {
  "ray-x/go.nvim",
  config = function()
    require("go").setup {
      max_line_len = 100,
      gofmt = "golines",
      goimports = "golines",
    }
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
}
