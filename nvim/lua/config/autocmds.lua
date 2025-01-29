-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  group = augroup("highlight_matching_parens"),
  callback = function()
    vim.cmd([[
        hi MatchParen ctermbg=lightblue guibg=lightgreen cterm=italic gui=italic
        ]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("cpp_header_swithch"),
  pattern = {
    "c",
    "cpp",
  },
  callback = function(event)
    vim.keymap.set("n", "<leader>a", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Help in new tabs
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("help_in_tab"),
  callback = function()
    local ft = vim.api.nvim_get_option_value("filetype", {})
    if ft == "help" then
      vim.cmd([[
        wincmd T
        nnoremap <buffer> q :q<cr>
      ]])
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("dap_repl_keymap"),
  callback = function()
    if vim.api.nvim_get_option_value("filetype", {}) == "dap-repl" then
      require("dap.ext.autocompl").attach()
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "n",
        "<cmd>lua require('dap').step_over()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "s",
        "<cmd>lua require('dap').step_into()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "S",
        "<cmd>lua require('dap').step_out()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "o",
        "<cmd>lua require('dap').step_out()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "c",
        "<cmd>lua require('dap').continue()<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(0, "i", "<c-k>", "<c-w>k", { noremap = true, silent = true })
    end
  end,
})

require("lazyvim.util").lsp.on_attach(function(client, bufnr)
  -- set formatexpr and tagfunc to keep using Vim default mappings for formatting and jumping to a tag
  if client.server_capabilities.definitionProvider then
    vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = bufnr })
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_set_option_value("formatexpr", "v:lua.vim.lsp.formatexpr()", { buf = bufnr })
    -- Add this <leader> bound mapping so formatting the entire document is easier.
    vim.api.nvim_set_keymap(
      "n",
      "<leader>gq",
      ":lua vim.lsp.buf.format({async = true})<CR>",
      { noremap = true, silent = true }
    )

    -- local lsp_format_modifications = require("lsp-format-modifications")
    -- lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
  end
end)

-- Disable autoformat for lua files
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "cpp", "c" },
--   callback = function()
--     vim.b.autoformat = false
--   end,
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
    local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
    copy_to_unnamedplus(vim.v.event.regcontents)
    local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
    copy_to_unnamed(vim.v.event.regcontents)
  end,
})

-- Ensure copilot.vim is installed and configured
-- if pcall(require, "copilot") then
-- end
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("CopilotWorkspace", { clear = true }),
  callback = function()
    local root_dir = require("lazyvim.util").root()
    if root_dir then
      vim.g.copilot_workspace_folders = { root_dir }
    end
  end,
})

-- color for copilot suggestions
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "dayfox",
  -- group = ...,
  callback = function()
    vim.api.nvim_set_hl(0, "CopilotSuggestion", {
      link = "DiffAdd",
      force = true,
    })
  end,
})
