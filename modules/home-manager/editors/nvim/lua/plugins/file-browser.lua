return {

  "nvim-telescope/telescope-file-browser.nvim",
  keys = {
    { "<leader>sz", ":Telescope file_browser path=%:p:h=%:p:h<cr>", desc = "Browse Files" },
  },
  config = function()
    require("telescope").load_extension("file_browser")
    local telescope = require("telescope")
    telescope.setup({
      pickers = { find_files = { hidden = true } },
    })
  end,
}
