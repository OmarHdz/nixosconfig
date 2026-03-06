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

      templates = {
        subdir = "2_Attachments/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },

      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      note_frontmatter_func = function(note)
        -- 1. ID NUMÉRICO (Timestamp)
        local id_numerico = note.id
        if string.len(note.id) < 12 or tonumber(note.id) == nil then
          id_numerico = os.date("%Y%m%d%H%M")
        end

        -- FUNCIÓN AUXILIAR: Limpia duplicados y separa si hay comas antiguas
        -- Ahora devuelve una TABLA (lista), no un string.
        local function obtener_lista_limpia(input)
          local set = {}
          local resultado = {}
          for _, item in ipairs(input or {}) do
            -- Esto limpia posibles restos de comas del formato anterior
            for subitem in string.gmatch(item, "([^,]+)") do
              local limpio = subitem:gsub("^%s*(.-)%s*$", "%1")
              if limpio ~= "" and not set[limpio] then
                set[limpio] = true
                table.insert(resultado, limpio)
              end
            end
          end
          return resultado
        end

        -- 2. LÓGICA DE ALIASES
        local lista_aliases = obtener_lista_limpia(note.aliases)
        if note.title and note.title ~= id_numerico then
          -- Verificar si el título ya está en la lista para no duplicar
          local titulo_presente = false
          for _, a in ipairs(lista_aliases) do
            if a == note.title then
              titulo_presente = true
              break
            end
          end
          if not titulo_presente then
            table.insert(lista_aliases, 1, note.title)
          end
        end

        -- 3. LÓGICA DE TAGS
        local es_nueva = note.metadata == nil or vim.tbl_isempty(note.metadata)
        local lista_tags = obtener_lista_limpia(note.tags)

        if es_nueva and #lista_tags == 0 then
          lista_tags = { "status/semilla", "tipo/info" }
        end

        -- 4. CONSTRUCCIÓN DE SALIDA
        -- Al pasar tablas {}, el plugin genera listas verticales con '-'
        return {
          id = id_numerico,
          aliases = lista_aliases,
          tags = lista_tags,
          updated = os.date("%Y-%m-%d %H:%M"),
        }
      end,

      note_id_func = function(title)
        if title ~= nil then
          return title
        else
          return tostring(os.time())
        end
      end,

      wiki_link_func = "use_alias_only",

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

    -- Atajos de teclado
    local keymap = vim.keymap.set
    keymap("n", "zkn", ":ObsidianNew ", { desc = "Zettelkasten [N]ew" })
    keymap("n", "zkt", ":ObsidianTemplate Default<CR>", { desc = "Zettelkasten [T]emplate Default" })
    keymap("n", "zkrr", ":ObsidianTemplate Referencias<CR>", { desc = "Zettelkasten [T]emplate Referencias" })
    keymap("n", "zkrn", ":ObsidianRename ", { desc = "Renombrar sin Romper" })
    keymap("n", "zks", ":ObsidianSearch<CR>", { desc = "Zettelkasten [S]earch" })
    keymap("n", "zkd", ":ObsidianToday<CR>", { desc = "Zettelkasten [D]aily" })
    keymap("n", "zkls", ":ObsidianLinks<CR>", { desc = "Zettelkasten [L]inks" })
    keymap("n", "zkb", ":ObsidianBacklinks<CR>", { desc = "Zettelkasten [B]acklinks" })
    -- Crear nota nueva a partir de la selección
    keymap("v", "zkli", ":ObsidianLinkNew<CR>", { desc = "Crear nota nueva y vincular" })
    -- Vincular selección a nota existente
    keymap("v", "zklk", ":ObsidianLink<CR>", { desc = "Convertir selección en enlace" })
  end,
}
