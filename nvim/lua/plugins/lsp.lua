return {
  {
    "simrat39/symbols-outline.nvim",
    keys = { { "gt", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  },

  {
    "neovim/nvim-lspconfig",
    -- you need to configure it using the init() method.
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>" }
      keys[#keys + 1] = { "g\\", "<cmd>vsplit<bar>lua vim.lsp.buf.definition()<cr>" }
      keys[#keys + 1] = { "g-", "<cmd>split<bar>lua vim.lsp.buf.definition()<cr>" }
      keys[#keys + 1] = { "gf", "<cmd>lua vim.lsp.buf.code_action()<cr>" }
      keys[#keys + 1] = { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>" }
      vim.api.nvim_create_user_command("Format", "lua vim.lsp.buf.format()", { nargs = 0 })
    end,

    -- Fix clangd offset encoding
    opts = {
      setup = {
        clangd = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = false
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
}
