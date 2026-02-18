return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "personal",
          path = "/mnt/c/Users/omarh/Documents/ObsidianVault",
        },
      },

      daily_notes = {
        folder = "0_Inbox",
        date_format = "%Y-%m-%d",
        template = nil,
      },

      -- Configuración de plantillas
      templates = {
        subdir = "2_Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },

      -- IMPORTANTE: Esto activa el sistema de completado interno.
      -- No necesitas tener instalado el plugin 'nvim-cmp'.
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      note_frontmatter_func = function(note)
        -- 1. Preparamos los campos básicos
        -- Usamos note.metadata para mantener datos existentes y evitar sobrescribir
        local out = {
          id = note.id,
          aliases = note.aliases or {},
          tags = note.tags or {},
        }

        -- 2. Lógica de Aliases (EVITAR DUPLICADOS)
        -- Solo añadimos el título como alias si:
        -- - Existe un título.
        -- - El título no es igual al ID (para no repetir).
        -- - El título NO está ya en la lista de aliases.
        if note.title and note.title ~= note.id then
          local ya_existe = false
          for _, alias in ipairs(out.aliases) do
            if alias == note.title then
              ya_existe = true
              break
            end
          end
          if not ya_existe then
            table.insert(out.aliases, note.title)
          end
        end

        -- 3. Lógica de Tags por defecto
        -- Si la lista de tags está vacía, ponemos los de por defecto
        if #out.tags == 0 then
          out.tags = { "status/to-do", "tipo/nota" }
        end

        -- 4. Lógica de Fechas
        -- Si la nota ya tiene fecha de creación en los metadatos, la dejamos.
        -- Si no, la creamos (esto solo pasará la primera vez).
        if note.metadata ~= nil and note.metadata.created ~= nil then
          out.created = note.metadata.created
        else
          out.created = os.date("%Y-%m-%d %H:%M")
        end

        -- La fecha de actualización siempre cambia al guardar
        out.updated = os.date("%Y-%m-%d %H:%M")

        return out
      end,

      -- Generación de ID
      note_id_func = function(title)
        if title ~= nil then
          return title
        else
          return tostring(os.time())
        end
      end,

      wiki_link_func = "use_alias_only",

      -- Atajos internos corregidos
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
    })

    local keymap = vim.keymap.set
    keymap("n", "zkn", ":ObsidianNew ", { desc = "Zettelkasten [N]ew" })
    keymap("n", "zkt", ":ObsidianTemplate Default<CR>", { desc = "Zettelkasten [T]emplate Default" })
    keymap("n", "zkrr", ":ObsidianTemplate Referencias<CR>", { desc = "Zettelkasten [T]emplate Referencias" })
    keymap("n", "zkrn", ":ObsidianRename ", { desc = "Renombrar sin Romper" })
    keymap("n", "zks", ":ObsidianSearch<CR>", { desc = "Zettelkasten [S]earch" })
    keymap("n", "zkd", ":ObsidianToday<CR>", { desc = "Zettelkasten [D]aily" })
    keymap("n", "zkl", ":ObsidianLinks<CR>", { desc = "Zettelkasten [L]inks" })
    keymap("n", "zkb", ":ObsidianBacklinks<CR>", { desc = "Zettelkasten [B]acklinks" })
  end,
}
