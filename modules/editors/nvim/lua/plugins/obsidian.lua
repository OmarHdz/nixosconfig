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
        -- 1. ID NUMÉRICO
        local id_numerico = note.id
        if string.len(note.id) < 12 or tonumber(note.id) == nil then
          id_numerico = os.date("%Y%m%d%H%M")
        end

        -- FUNCIÓN AUXILIAR: Limpiar y separar texto por comas
        local function limpiar_lista(lista_entrada)
          local set = {}
          local resultado = {}
          for _, item in ipairs(lista_entrada) do
            -- Separar por comas si el plugin leyó todo el string como un solo item
            for subitem in string.gmatch(item, "([^,]+)") do
              local limpio = subitem:gsub("^%s*(.-)%s*$", "%1") -- Trim (quitar espacios)
              if limpio ~= "" and not set[limpio] then
                set[limpio] = true
                table.insert(resultado, limpio)
              end
            end
          end
          return resultado
        end

        -- 2. LÓGICA DE ALIASES (Sin repeticiones)
        local raw_aliases = note.aliases or {}
        -- Añadimos el título a la lista para procesarlo
        if note.title and note.title ~= id_numerico then
          table.insert(raw_aliases, note.title)
        end

        local lista_aliases_limpia = limpiar_lista(raw_aliases)
        local final_aliases = table.concat(lista_aliases_limpia, ", ")

        -- 3. LÓGICA DE TAGS (Sin comas dobles ni repeticiones)
        local es_nueva = note.metadata == nil or vim.tbl_isempty(note.metadata)
        local raw_tags = note.tags or {}

        if es_nueva then
          table.insert(raw_tags, "status/semilla")
          table.insert(raw_tags, "tipo/procedimiento")
        end

        local lista_tags_limpia = limpiar_lista(raw_tags)
        local final_tags = table.concat(lista_tags_limpia, ", ")

        -- 4. CONSTRUCCIÓN DE SALIDA
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
