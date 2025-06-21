return {
  -- OTRA FORMA DE HACERLO con iron nvim
  -- https://dev.to/rnrbarbosa/how-to-run-python-on-neovim-like-jupyter-3ln0
  -- https://github.com/Vigemus/iron.nvim/discussions/319
  -- slime (REPL integration)
  {
    "jpalardy/vim-slime",
    -- Mapeo para modo visual (seleccionar código y enviar)
    lazy = false,

    -- Mapeo para modo normal (enviar movimiento/text-object)
    vim.keymap.set("x", "<leader>rr", "<Plug>SlimeRegionSend"),
    vim.keymap.set("n", "<leader>rr", "<Plug>SlimeMotionSend<cr>j"),
    vim.keymap.set("n", "<leader>rd", ":SlimeSend1 exit<cr>"),

    keys = {
      { "<leader>rc", "<cmd>SlimeConfig<cr>", desc = "Slime Config" },
      --{ "<leader>rr", "<Plug>SlimeRegionSend", desc = "Slime Send Cell" },
    },

    config = function()
      vim.g.mapleader = " "
      vim.g.slime_target = "tmux"
      vim.g.slime_python_ipython = 1
      vim.g.slime_default_config = { socket_name = "default", target_pane = "2" }
      vim.g.slime_dont_ask_default = 1
    end,
  },
}
