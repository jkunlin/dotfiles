-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "x" }, "gw", "*N")
vim.keymap.set({ "n" }, "<leader>w", "<cmd>update<cr><esc>", { desc = "Save file" })

-- quit
vim.keymap.del("n", "<leader>qq")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:qa!<cr>", { desc = "Quit all" })

-- Escape
vim.keymap.set("i", "jk", "<esc>", { desc = "Escape" })
vim.keymap.set("t", "jk", "<c-\\><c-n>", { desc = "Escape" })

-- Windows
vim.keymap.del("n", "<leader>ww")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>w|")
vim.keymap.set("n", "=", "<cmd>vertical resize +5<cr>", { desc = "Window resize +5" })
vim.keymap.set("n", "-", "<cmd>vertical resize -5<cr>", { desc = "Window resize -5" })
vim.keymap.set("n", "<leader>\\", "<cmd>vsplit<cr>", { desc = "Virtical split" })
vim.keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split" })
vim.keymap.set("n", "<tab>", "<c-w>w", { desc = "Window next" })
vim.keymap.set("n", "<s-tab>", "<c-w>W", { desc = "Window previous" })
vim.keymap.set("n", "<c-p>", "<c-i>", { desc = "Jump list (to newer position)" })

-- '[' and ']' keymaps
vim.keymap.set("n", "<leader>c", "<cmd>cclose<bar>lclose<cr>", { desc = "Close Quickfix and Location" })
vim.keymap.set("n", "]q", "<cmd>cnext<cr>", { desc = "Quickfix next" })
vim.keymap.set("n", "[q", "<cmd>cprev<cr>", { desc = "Quickfix previous" })
vim.keymap.set("n", "]l", "<cmd>lnext<cr>", { desc = "Location next" })
vim.keymap.set("n", "[l", "<cmd>lprev<cr>", { desc = "Location previous" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Buffer next" })
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { desc = "Beffer previous" })
-- vim.keymap.set("n", "]t", "<cmd>tnext<cr>", { desc = "Tab next" })
-- vim.keymap.set("n", "[t", "<cmd>tprev<cr>", { desc = "Tab previous" })

-- :Root | Change directory to the root of the Git repository
vim.cmd([[
  function! s:root()
    let root = systemlist('git rev-parse --show-toplevel')[0]
    if v:shell_error
      echo 'Not in git repo'
    else
      execute 'lcd' root
      echo 'Changed directory to: '.root
    endif
  endfunction
  command! Root call s:root()
]])

-- " Open new line below and above current line
vim.keymap.set("n", "<leader>o", "o<esc>", { desc = "new line below" })
vim.keymap.set("n", "<leader>O", "O<esc>", { desc = "new line above" })

-- Others
vim.keymap.set("n", "<c-g>", "1<c-g>", { desc = "Path of buffer" })
vim.keymap.set("v", "v", "<c-c>")
vim.keymap.set("n", "<leader>.", "<cmd>cd %:p:h<cr>", { desc = "Change working direcotry" })
vim.keymap.set("n", "Q", "@q", { desc = "qq to record, Q to replay" })
