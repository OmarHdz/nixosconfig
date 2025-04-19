return {
  "williamboman/mason.nvim",
  keys = {
    -- { "<leader>t", "", desc = "+test" },
    { "<leader>cj", vim.lsp.buf.hover, desc = "LSP Hover" },
    -- { "<leader>ck", vim.diagnostic.open_float({ focusable = true }), desc = "Show Diagnostics" },
    { "<leader>ck", vim.diagnostic.open_float, desc = "Show Diagnostics" },
  },
  opts = {
    ensure_installed = {
      -- -- Linters
      -- "ruff", -- Python
      -- "mypy", -- Python para organizar los imports
      --
      -- -- Formatters
      -- "prettier", -- JS/TS/HTML/CSS
      --
      -- -- LSP
      -- "pyright", -- Python
    },
  },
}
