-- lazy.nvim
return {
  "folke/snacks.nvim",
  opts = {
    statuscolumn = {
      enabled = true,
    },
    dashboard = {
      statuscolumn = "",
    },
    image = {
      -- your image configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      enabled = true, -- Ensure the image feature is enabled
      -- backend = "kitty", -- Force the Kitty backend
      backend = "ueberzug", -- Force the Kitty backend
      force = true,
      inline = true,

      doc = {
        enabled = true,
        inline = true,
        -- float = true,
      },
      wo = {
        wrap = false,
        number = false,
        relativenumber = false,
        cursorcolumn = false,
        signcolumn = "no",
        foldcolumn = "0",
        list = false,
        spell = false,
        statuscolumn = "",
      },
    },
  },
}
