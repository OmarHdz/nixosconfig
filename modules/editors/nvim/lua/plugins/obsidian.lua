return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recomiendan usar la última versión estable
  lazy = true,
  ft = "markdown", -- Cargar solo cuando abras archivos markdown
  dependencies = {
    -- Requerido
    "nvim-lua/plenary.nvim",
    -- Opcional, para completado de enlaces [[link]]
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim", -- o "ibhagwan/fzf-lua" si prefieres
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        -- IMPORTANTE: Cambia esto a la ruta real de tu bóveda.
        -- Si usas WSL y la bóveda está en Windows:
        path = "/mnt/c/Users/omarh/Documents/Obsidian Vault",
      },
    },

    -- Configuración de notas diarias (opcional)
    daily_notes = {
      folder = "dailies",
      date_format = "%Y-%m-%d",
      template = nil,
    },

    -- Completado de enlaces [[...]]
    completion = {
      nvim_cmp = false,
      blink = true,
      min_chars = 2,
    },

    -- Mapeos de teclas sugeridos (puedes personalizarlos)
    mappings = {
      -- "Obsidian follow" (ir al enlace bajo el cursor)
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Checkbox toggle
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Si quieres abrir en un split vertical usa <leader>v
      ["<leader>v"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox() -- ejemplo, cambia por comando de split si quieres
        end,
        opts = { buffer = true },
      },
    },

    -- Frontmatter (metadatos)
    disable_frontmatter = false,
    note_id_func = function(title)
      -- Generar ID basado en el título (o usar Zettelkasten ID si prefieres)
      return title
    end,
  },
}
