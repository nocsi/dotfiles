return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    local ts = require "telescope"
    ts.setup {
      defaults = {
        winblend = 10,
        path_display = { "smart" },
        layout_strategy = "flex",
        layout_config = {
          prompt_position = "top",
        },
        file_ignore_patterns = { "vendor/*" },
        mappings = {
          n = {
            ["dd"] = "delete_buffer",
          },
        },
      },
      pickers = {},
      extensions = {
        file_browser = {
          hijack_netrw = false,
        },
      },
    }
    local extensions = {
      "fzf",
      "notify",
      "undo",
      -- 'yank_history',
    }
    for _, e in pairs(extensions) do
      ts.load_extension(e)
    end
  end,
  require("telescope").setup {
    defaults = {
      mappings = {
        i = {
          ["<C-g>"] = function(prompt_bufnr)
            -- Use nvim-window-picker to choose the window by dynamically attaching a function
            local action_set = require "telescope.actions.set"
            local action_state = require "telescope.actions.state"

            local picker = action_state.get_current_picker(prompt_bufnr)
            picker.get_selection_window = function(picker, entry)
              local picked_window_id = require("window-picker").pick_window() or vim.api.nvim_get_current_win()
              -- Unbind after using so next instance of the picker acts normally
              picker.get_selection_window = nil
              return picked_window_id
            end

            return action_set.edit(prompt_bufnr, "edit")
          end,
        },
      },
    },
  },
}
