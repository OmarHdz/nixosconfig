-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Ejecuta python ligado a mi funcion en opctions
vim.api.nvim_set_keymap(
  "n",
  "<leader>ra",
  ":lua RunPythonInTmux()<CR>",
  { noremap = true, silent = true, desc = "Exec All" }
)

-- tab keymaps
vim.keymap.set("n", "<leader>j", ":bn<cr>")
vim.keymap.set("n", "<leader>h", ":bp<cr>")
vim.keymap.set("n", "<leader>z", ":bd<cr>")

-- tmux keymaps
vim.keymap.set("n", "<c-k>", ":wincmd k<cr>")
vim.keymap.set("n", "<c-j>", ":wincmd j<cr>")
vim.keymap.set("n", "<c-h>", ":wincmd h<cr>")
vim.keymap.set("n", "<c-l>", ":wincmd l<cr>")

-- Copiar al portapapeles del computador
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Activar/Desactivar colores
vim.keymap.set("n", "<leader>co", ":ColorizerToggle<cr>")

-- Select all text
vim.keymap.set("n", "<leader>i", "ggVG<cr>")

-- Go to next diagnostic message
vim.keymap.set("n", "<leader>dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Sig diagnostic" })

-- Show Mensages de diagnostic en buffer para copiarlos
-- https://stackoverflow.com/questions/74099090/how-do-you-copy-text-from-a-diagnostic-float-window-in-neovim-lunarvim
vim.keymap.set("n", "<leader>dd", "<Cmd>lua vim.diagnostic.setqflist()<CR>", { desc = "Mostrar diagnostic" })

-- Go to next diagnostic message
vim.keymap.set("n", "<leader>dn", "<Cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "Sig diagnostic" })

-- Depuración con DAP
local map = vim.keymap.set
map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { desc = "Iniciar/Continuar depuración" })
map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { desc = "Step over" })
map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { desc = "Step into" })
map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { desc = "Step out" })
map("n", "<leader>db", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Alternar breakpoint" })
map(
  "n",
  "<leader>dk",
  "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Condición: '))<CR>",
  { desc = "Breakpoint condicional" }
)
map("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { desc = "Abrir REPL de depuración" })
map("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { desc = "Repetir última depuración" })

vim.keymap.set("n", "<leader>dc", "<Cmd>lua require('dapui').close()<CR>", { desc = "Cerrar DAP-UI" })
