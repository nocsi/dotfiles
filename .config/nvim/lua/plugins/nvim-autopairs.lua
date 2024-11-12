return { -- override nvim-autopairs plugin
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function(plugin, opts)
    -- run default AstroNvim config
    require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
    -- require Rule function
    local Rule = require "nvim-autopairs.rule"
    local npairs = require "nvim-autopairs"
    -- configure autopairs
    npairs.setup {
      check_ts = true, -- enable treesitter
      ts_config = {
        lua = { "string" }, -- don't add pairs in lua string treesitter nodes
        javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
        java = false, -- don't check treesitter on java
      },
    }

    npairs.add_rules {
      {
        -- specify a list of rules to add
        -- Rule(" ", " "):with_pair(function(options)
        --   local pair = options.line:sub(options.col - 1, options.col)
        --  return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        -- end),
        Rule("( ", " )")
          :with_pair(function() return false end)
          :with_move(function(options) return options.prev_char:match ".%)" ~= nil end)
          :use_key ")",
        Rule("{ ", " }")
          :with_pair(function() return false end)
          :with_move(function(options) return options.prev_char:match ".%}" ~= nil end)
          :use_key "}",
        Rule("[ ", " ]")
          :with_pair(function() return false end)
          :with_move(function(options) return options.prev_char:match ".%]" ~= nil end)
          :use_key "]",
      },
    }
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"

    -- import nvim-cmp plugin (completions plugin)
    local cmp = require "cmp"

    -- make autopairs and completion work together
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
