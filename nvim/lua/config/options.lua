-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.relativenumber = false
opt.splitkeep = "cursor"
opt.shortmess:append({ S = true, s = true }) -- S for search, s for hit-enter message
opt.wrap = true
opt.swapfile = false
opt.diffopt:append("linematch:60") -- https://github.com/neovim/neovim/pull/14537
