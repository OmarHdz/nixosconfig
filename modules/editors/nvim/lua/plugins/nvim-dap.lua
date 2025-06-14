return {
  -- ... otros plugins existentes ...

  -- DAP (Debug Adapter Protocol)
  -- cerrar ventanas especificas (se puede poner en un keymap)
  -- :lua require('dapui').elements.watches.close()
  {
    "mfussenegger/nvim-dap",
    event = "VimEnter",
    dependencies = {
      "rcarriga/nvim-dap-ui",         -- Interfaz gráfica para DAP
      "mfussenegger/nvim-dap-python", -- Adaptador para Python
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      -- Configuración básica de DAP

      -- Ejemplo: Cambiar el breakpoint normal a un emoji de 'stop' (🛑)
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DebugLine", numhl = "DapStopped" }
      ) --🐞

      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "❓", texthl = "DapBreakpointCondition", numhl = "DapBreakpointCondition" }
      )

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

      -- dap.configurations.python = {
      --   -- ... (tus otras configuraciones de Python pueden estar aquí) ...
      --
      --   {
      --     -- Nombre descriptivo para la configuración
      --     name = "FastAPI: Uvicorn (A2A)",
      --     type = "python", -- Usa el adaptador Python (debugpy)
      --     request = "launch", -- Estamos iniciando el proceso
      --     module = "uvicorn", -- ¡Importante! Ejecuta uvicorn como módulo
      --     args = { -- Argumentos a pasar a uvicorn
      --       "src.main:app", -- Dónde encontrar tu aplicación FastAPI
      --       "--host",
      --       "127.0.0.1", -- O '0.0.0.0' si necesitas acceso externo
      --       "--port",
      --       "8000",
      --       -- ¡NO uses --reload con el debugger! El debugger maneja los reinicios si es necesario,
      --       -- y --reload crea procesos hijos que complican el debugging.
      --       -- '--reload'
      --     },
      --     -- Opcional: Si necesitas variables de entorno específicas para el debug
      --     -- env = {
      --     --   ['MY_API_KEY'] = 'secret_value'
      --     -- },
      --     -- Opcional: Establecer el directorio de trabajo actual.
      --     -- Generalmente funciona bien si inicias nvim desde la raíz del proyecto.
      --     cwd = vim.fn.getcwd(), -- Directorio desde donde iniciaste nvim
      --     console = "integratedTerminal", -- Muestra la salida de uvicorn en una terminal
      --     -- O puedes usar 'internalConsole' si lo prefieres
      --     justMyCode = true, -- Opcional: poner en false si necesitas entrar en librerías
      --   },
      --
      --   -- ... (más configuraciones si las tienes) ...
      -- }
    end,
  },
}
