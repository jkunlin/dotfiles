-- bootstrap lazy.nvim, LazyVim and your plugins
vim.env.PATH = vim.env.HOME .. "/home/linjk/dotfiles/bin:" .. vim.env.PATH
require("config.lazy")
