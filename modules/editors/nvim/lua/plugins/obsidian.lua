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
        path = "/mnt/c/Users/omarh/Documents/ObsidianVault",
      },
    },

    -- Configuración de notas diarias (opcional)
    daily_notes = {
      folder = "1_Inbox",
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

    -- 1. CONFIGURACIÓN DEL NOMBRE DEL ARCHIVO (El ID)
    -- Esta función determina cómo se llamará el archivo físico .md
    note_id_func = function(title)
      -- Generamos un ID de sufijo (timestamp)
      local suffix = ""
      if title ~= nil then
        -- Si le damos un título (ej: :ObsidianNew docker-intro),
        -- el nombre será "docker-intro" (más legible)
        return title
      else
        -- Si creamos una nota sin título, usa timestamp base 36 (muy corto)
        -- O puedes usar os.time() para el timestamp clásico
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. "-" .. suffix
      end
    end,

    -- 2. CONFIGURACIÓN DEL FRONTMATTER (La metadata automática)
    -- Esto se escribe AUTOMÁTICAMENTE al principio de cada nota nueva
    note_frontmatter_func = function(note)
      -- Si preferimos usar el timestamp como ID dentro de la nota:
      local out = {
        id = note.id,
        aliases = note.aliases,
        tags = note.tags,
        -- Agregamos fecha y hora automática
        created = os.date("%Y-%m-%d %H:%M"),
        updated = os.date("%Y-%m-%d %H:%M"),
      }

      -- Si el nombre del archivo no tiene el ID numérico,
      -- podemos forzar que el ID interno sea la fecha actual:
      if note.title then
        note.id = os.date("%Y%m%d%H%M") -- Formato Zettelkasten clásico
      end

      -- Agregamos el título como alias automáticamente si quieres
      if note.title and not note.aliases[1] then
        note.aliases = { note.title }
      end

      local note_metadata = {}
      for k, v in pairs(out) do
        note_metadata[k] = v
      end
      return note_metadata
    end,

    -- Frontmatter (metadatos)
    disable_frontmatter = false,

    -- Directorio para plantillas más complejas (opcional)
    templates = {
      subdir = "3_Attachments/Templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },
  },
}
