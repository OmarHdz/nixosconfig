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
        -- 1. ID Numérico (Siempre se mantiene)
        local id_numerico = note.id
        if string.len(note.id) < 12 or tonumber(note.id) == nil then
          id_numerico = os.date("%Y%m%d%H%M")
        end

        -- 2. LÓGICA DE ALIASES (Convertir a texto separado por comas)
        local lista_aliases = {}
        if note.title and note.title ~= id_numerico then
          table.insert(lista_aliases, note.title)
        end
        if note.aliases then
          for _, alias in ipairs(note.aliases) do
            -- Evitar duplicar el título en los aliases
            if alias ~= note.title then
              table.insert(lista_aliases, alias)
            end
          end
        end
        -- Convertimos la tabla de aliases a un solo string: "alias1, alias2"
        local final_aliases = table.concat(lista_aliases, ", ")

        -- 3. LÓGICA DE TAGS (Sin duplicados y convertido a texto con comas)
        local tag_set = {}
        local es_nueva = note.metadata == nil or vim.tbl_isempty(note.metadata)

        if es_nueva then
          tag_set["status/semilla"] = true
          tag_set["tipo/procedimiento"] = true
        end

        if note.tags then
          for _, tag in ipairs(note.tags) do
            tag_set[tag] = true
          end
        end

        local lista_tags = {}
        for tag, _ in pairs(tag_set) do
          table.insert(lista_tags, tag)
        end
        -- Convertimos la tabla de tags a un solo string: "tag1, tag2"
        local final_tags = table.concat(lista_tags, ", ")

        -- 4. TABLA DE SALIDA
        -- Al pasar strings en lugar de tablas, el plugin los escribe en una sola línea
        local out = {
          id = id_numerico,
          aliases = final_aliases,
          tags = final_tags,
          updated = os.date("%Y-%m-%d %H:%M"),
        }

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
