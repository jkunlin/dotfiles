-- Autocmds are automatically loaded on the VeryLazy event
-- Add any additional autocmds here

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=500}
  end,
})

-- TODO resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c",
    "cpp",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = event.buf, silent = true })
  end,
})


-- Help in new tabs
vim.cmd[[
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
]]


vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local ft = vim.api.nvim_buf_get_option(0, 'filetype')
    if ft == 'help' then
      vim.cmd[[
        wincmd T
        nnoremap <buffer> q :q<cr>
      ]]
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "dap-repl",
  },
  callback = function(event)
    vim.api.nvim_set_keymap("n", "n", "<cmd>lua require('dap').step_over()<cr>", { buffer = event.buf, noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "s", "<cmd>lua require('dap').step_into()<cr>", { buffer = event.buf, noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "S", "<cmd>lua require('dap').step_out()<cr>", { buffer = event.buf, noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "o", "<cmd>lua require('dap').step_out()<cr>", { buffer = event.buf, noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "c", "<cmd>lua require('dap').continue()<cr>", { buffer = event.buf, noremap = true, silent = true })
    vim.api.nvim_set_keymap("i", "<c-k>", "<c-w>k", { buffer = event.buf, noremap = true, silent = true })
  end,
})
