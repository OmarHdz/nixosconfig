return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  -- Ponemos todo dentro de CONFIG para evitar errores de Lazy
  config = function()
    require("obsidian").setup({

      workspaces = {
        {
          name = "personal",
          -- IMPORTANTE: Cambia esto a la ruta real de tu bóveda.
          -- Si usas WSL y la bóveda está en Windows:
          path = "/mnt/c/Users/omarh/Documents/ObsidianVault",
        },
      },
      -- Directorio para plantillas más complejas (opcional)
      templates = {
        subdir = "3_Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },

      -- Configuración de notas diarias
      -- daily_notes = { folder = "1_Inbox" date_format = "%Y-%m-%d", template = nil, },

      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
      },

      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
      },

      -- GENERACIÓN DE ID
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          return title
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
          return tostring(os.time()) .. "-" .. suffix
        end
      end,

      -- GENERACIÓN DE FRONTMATTER
      note_frontmatter_func = function(note)
        -- Si el nombre del archivo no tiene ID numérico, generamos uno basado en la fecha
        if note.title then
          note.id = os.date("%Y%m%d%H%M")
        end

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
          created = os.date("%Y-%m-%d %H:%M"),
          updated = os.date("%Y-%m-%d %H:%M"),
        }

        if note.title and not note.aliases[1] then
          note.aliases = { note.title }
        end

        return out
      end,

      disable_frontmatter = false,
    })

    -- === TUS ATAJOS PERSONALIZADOS ===
    local keymap = vim.keymap.set
    local options = { noremap = true, silent = true }

    -- zkn: Crear nueva nota
    keymap("n", "zkn", ":ObsidianNew ", { desc = "Zettelkasten [N]ueva Nota" })

    -- zkt: Insertar Template
    keymap("n", "zkt", ":ObsidianTemplate ", { desc = "Zettelkasten [T]emplate" })

    -- zks: Buscar notas
    keymap("n", "zks", ":ObsidianSearch<CR>", { desc = "Zettelkasten [S]earch" })

    -- zkd: Ir a nota diaria
    keymap("n", "zkd", ":ObsidianToday<CR>", { desc = "Zettelkasten [D]aily" })
  end,
}
