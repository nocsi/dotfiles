return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    dim_inactive = { enabled = true, percentage = 0.25 },
    highlight_overrides = {
      mocha = function(c)
        return {
          Normal = { bg = c.mantle },
          Comment = { fg = "#7687a0" },
          ["@tag.attribute"] = { style = {} },
        }
      end,
    },
  },
}
