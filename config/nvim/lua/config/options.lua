-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

-- Tabs
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4

vim.g.autoformat = true

-- Always render whitespace
opt.list = true
opt.listchars = {
  space = "·",
  tab = "→→",
  eol = "↵",
  nbsp = "␠",
}

vim.api.nvim_set_hl(0, "Whitespace", {
  fg = "#efefef",
})
vim.api.nvim_set_hl(0, "NonText", {
  fg = "#efefef",
})
