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

  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "/mnt/c/Users/omarh/Documents/ObsidianVault",
        },
      },
      daily_notes = {
        folder = "1_Inbox",
        date_format = "%Y-%m-%d",
        template = nil,
      },

      -- Configuración de plantillas
      templates = {
        subdir = "3_Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },

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

      -- 1. GENERACIÓN DE ID (Solo se ejecuta al CREAR el archivo)
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

      note_frontmatter_func = function(note)
        -- 1. Lógica del ID (Forzar numérico)
        local id_numerico = note.id
        if string.len(note.id) < 12 or tonumber(note.id) == nil then
          id_numerico = tostring(os.date("%Y%m%d%H%M"))
        end

        -- 2. Lógica de Aliases (Añadir título como alias)
        local mis_aliases = note.aliases
        if note.title and note.title ~= id_numerico and not note.aliases[1] then
          mis_aliases = { note.title }
        end

        -- 3. Lógica de Tags (SOLO SI ES NUEVA)
        local mis_tags = note.tags

        -- Verificamos si es una nota nueva:
        -- Una nota es nueva si no tiene metadata previa (note.metadata es nil o vacío).
        local es_nueva = note.metadata == nil or vim.tbl_isempty(note.metadata)

        if es_nueva and #mis_tags == 0 then
          mis_tags = { "status/semilla", "tipo/procedimiento" }
        end

        -- 4. CREAR LA TABLA 'out' (Aquí estaba tu error antes, faltaba esto)
        local out = {
          id = id_numerico,
          aliases = mis_aliases,
          tags = mis_tags,
        }

        -- 5. Lógica de Fechas
        -- Si la nota ya tiene fecha de creación (metadata), la respetamos.
        if note.metadata ~= nil and note.metadata["created"] ~= nil then
          out.created = note.metadata["created"]
        else
          out.created = os.date("%Y-%m-%d %H:%M")
        end

        -- La fecha de actualización siempre es ahora
        out.updated = os.date("%Y-%m-%d %H:%M")

        return out
      end,

      disable_frontmatter = false,
    })

    -- ATAJOS
    local keymap = vim.keymap.set
    keymap("n", "zkn", ":ObsidianNew ", { desc = "Zettelkasten [N]ew" })
    keymap("n", "zkt", ":ObsidianTemplate default<CR>", { desc = "Zettelkasten [T]emplate Default" })
    keymap("n", "zkr", ":ObsidianTemplate Referencias<CR>", { desc = "Zettelkasten [T]emplate Referencias" })
    keymap("n", "zks", ":ObsidianSearch<CR>", { desc = "Zettelkasten [S]earch" })
    keymap("n", "zkd", ":ObsidianToday<CR>", { desc = "Zettelkasten [D]aily" })
  end,
}
