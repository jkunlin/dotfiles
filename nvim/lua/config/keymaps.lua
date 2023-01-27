-- Keymaps are automatically loaded on the VeryLazy event

-- better up/down
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- buffers
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file
-- vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
vim.keymap.set({ "n" }, "<leader>w", "<cmd>update<cr><esc>", { desc = "Save file" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- quit
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>:qa!<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- Escape
vim.keymap.set("i", "jk", "<esc>", { desc = "Escape" })
vim.keymap.set("t", "jk", "<c-\\><c-n>", { desc = "Escape" })

-- Windows
vim.keymap.set("n", "=", "<cmd>vertical resize +5", { desc = "Window resize +5" })
vim.keymap.set("n", "-", "<cmd>vertical resize -5", { desc = "Window resize -5" })
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
vim.keymap.set("n", "]t", "<cmd>tnext<cr>", { desc = "Tab next" })
vim.keymap.set("n", "[t", "<cmd>tprev<cr>", { desc = "Tab previous" })

-- cop to toggle setting
vim.cmd[[
  function! s:map_change_option(...)
    let [key, opt] = a:000[0:1]
    let op = get(a:, 3, 'set '.opt.'!')
    execute printf("nnoremap co%s :%s<bar>set %s?<cr>", key, op, opt)
  endfunction
  call s:map_change_option('r', 'relativenumber')
]]

-- :Root | Change directory to the root of the Git repository
vim.cmd [[
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
]]

-- " Open new line below and above current line
vim.keymap.set("n", "<leader>o", "o<esc>")
vim.keymap.set("n", "<leader>O", "O<esc>")

-- Others
vim.keymap.set("n", "<c-g>", "1<c-g>", { desc = "Path of buffer" })
vim.keymap.set("v", "v", "<c-c>")
vim.keymap.set("n", "<leader>.", "<cmd>cd %:p:h<cr>", { desc = "Change working direcotry" })
vim.keymap.set("n", "Q", "@q", { desc = "qq to record, Q to replay" })

-- floating terminal
-- vim.keymap.set("n", "<leader>ft", function()
--   Util.float_term(nil, { cwd = Util.get_root() })
-- end, { desc = "Terminal (root dir)" })
-- vim.keymap.set("n", "<leader>fT", function()
--   Util.float_term()
-- end, { desc = "Terminal (cwd)" })
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
