-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.clipboard:append("unnamedplus")
vim.opt.clipboard = "unnamedplus"

function RunPythonInTmux()
  vim.cmd("w")
  local file = vim.fn.expand("%")
  local command = string.format("echo ' > python %s ';  python %s; zsh", file, file)
  local tmux_cmd = string.format('tmux split-window -d -v -p 20 "%s"', command)
  vim.fn.system(tmux_cmd)
  vim.cmd("redraw!")
end
