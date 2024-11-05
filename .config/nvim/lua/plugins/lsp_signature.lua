local cfg = {
  extra_trigger_chars = { "(", "," },
  handler_opts = {
    border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
  },
  max_height = 24,
  max_width = 100,
  move_cursor_key = "<M-t>",
  select_signature_key = "<M-n>",
  toggle_key = "<M-x>",
}

return {
  "ray-x/lsp_signature.nvim",
  event = "BufRead",
  config = function() require("lsp_signature").setup(cfg) end,
}
