return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    -- Asegúrate de que obsidian se cargue si es necesario,
    -- aunque lazy suele manejarlo bien.
  },
  version = "*",
  opts = {
    -- ... otras opciones de keymap, appearance, etc ...

    sources = {
      -- 1. AÑADE "obsidian" AQUI
      default = { "lsp", "path", "snippets", "buffer", "obsidian" },

      -- 2. DEFINE EL PROVEEDOR AQUI
      providers = {
        obsidian = {
          name = "obsidian",
          module = "blink.cmp.sources.obsidian",
          score_offset = 100, -- (Opcional) Para que salga arriba en la lista
        },
      },
    },
  },
}
