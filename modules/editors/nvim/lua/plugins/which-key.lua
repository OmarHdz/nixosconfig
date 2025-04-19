return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- config = function()
    --   local wk = require("which-key")
    --   wk.add({
    --     { "<leader>a", group = "[A]vante", icon = "⚇" },
    --     --{ "<leader>c_", hidden = true },
    --   })
    -- end,
  },
  keys = function()
    local wk = require("which-key")
    wk.add({
      { "<leader>a", group = "Avante Ops", icon = { icon = "󱜙", color = "purple" } },
      { "<leader>r", group = "SendCode", icon = { icon = "", color = "cyan" } },
    })
  end,
}
