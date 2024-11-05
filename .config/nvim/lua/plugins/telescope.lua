local actions = require "telescope.actions"

return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      -- layout_config = {
      --   -- prompt_position = "top",
      --   height = 0.90,
      --   width = 0.90,
      --   bottom_pane = {
      --     height = 25,
      --     preview_cutoff = 120,
      --   },
      --   center = {
      --     height = 0.4,
      --     preview_cutoff = 40,
      --     width = 0.5,
      --   },
      --   cursor = {
      --     preview_cutoff = 40,
      --   },
      --   horizontal = {
      --     preview_cutoff = 120,
      --     preview_width = 0.6,
      --   },
      --   vertical = {
      --     preview_cutoff = 40,
      --   },
      --   flex = {
      --     flip_columns = 150,
      --   },
      -- },
      prompt_prefix = " ",
      scroll_strategy = "limit",
    },
    pickers = {
      buffers = {
        initial_mode = "insert",
        -- Be able to "delete" (close) a buffer from the list of buffers.
        mappings = {
          i = {
            ["<C-d>"] = actions.delete_buffer,
          },
          n = {
            ["dd"] = actions.delete_buffer,
          },
        },
        scroll_strategy = "limit",
      },
    },
  },
}
