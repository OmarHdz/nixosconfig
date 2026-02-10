return {
  {
    "3rd/image.nvim",
    opts = {
      backend = "iterm2", -- WezTerm soporta el protocolo de iterm2
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = true, -- ESTO es lo que pediste
          filetypes = { "markdown", "vimwiki", "quarto" },
        },
      },
      max_width = 100,
      max_height = 20,
      window_overlap_clear_enabled = true,
      -- Esta parte es crucial para Mermaid
      code_syntax_highlight = {
        enabled = true,
        executable = "mmdc", -- El binario de mermaid-cli que instalaste con Nix
      },
    },
  },
}
