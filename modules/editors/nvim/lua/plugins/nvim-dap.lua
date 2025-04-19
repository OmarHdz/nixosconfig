return {
  -- ... otros plugins existentes ...

  -- DAP (Debug Adapter Protocol)
  -- cerrar ventanas especificas (se puede poner en un keymap)
  -- :lua require('dapui').elements.watches.close()
  {
    "mfussenegger/nvim-dap",
    event = "VimEnter",
    dependencies = {
      "rcarriga/nvim-dap-ui", -- Interfaz gráfica para DAP
      "mfussenegger/nvim-dap-python", -- Adaptador para Python
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      -- Configuración básica de DAP
      local dap = require("dap")

      -- Configuración de DAP-Python
      require("dap-python").setup("uv") -- Usa el ejecutable de Python por defecto

      -- Configuración de DAP-UI
      local dapui = require("dapui")
      -- require("nvim-dap-virtual-text").setup({commented = true})
      dapui.setup()

      -- Abre DAP-UI automáticamente al depurar
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
