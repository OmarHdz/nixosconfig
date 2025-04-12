return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },

  -- https://github.com/nvim-neotest/neotest-python/tree/master
  opts = function(_, opts)
    table.insert(
      opts.adapters, --se carga del core.test de lazyvim, en lazy.init
      require("neotest-python")({
        -- dap = { justMyCode = false },
        -- args = {"--log-level", "DEBUG"},
        -- python = ".venv/bin/python",
        runner = "pytest",
        pytest_discover_instances = true,
      })
    )
  end,

  -- config = function()
  --   require("neotest").setup({
  --     adapters = {
  --       require("neotest-python"),
  --     },
  --   })
  -- end,

  -- config = function()
  --   local nt = require("neotest")
  --   nt.setup({
  --     log_level = 1,
  --     icons = {},
  --     highlights = {},
  --     consumers = {},
  --     floating = { "border" },
  --     strategies = {"integrated"},
  --     adapters = {
  --       require("neotest-python")({
  --         dap = { justMyCode = false },
  --       }),
  --       require("neotest-plenary"),
  --       require("neotest-vim-test")({
  --         ignore_file_types = { "python", "vim", "lua" },
  --       }),
  --     },
  --   })
  -- end,

  keys = {
    { "<leader>t", "", desc = "+test" },
    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File (Neotest)",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files (Neotest)",
    },
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest (Neotest)",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last (Neotest)",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary (Neotest)",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output (Neotest)",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel (Neotest)",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop (Neotest)",
    },
    {
      "<leader>tw",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Toggle Watch (Neotest)",
    },
  },
}
