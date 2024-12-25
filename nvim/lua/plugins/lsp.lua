return {
  -- {
  --   "simrat39/symbols-outline.nvim",
  --   keys = { { "gt", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  -- },

  {
    "neovim/nvim-lspconfig",
    -- you need to configure it using the init() method.
    -- init = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()
    --   keys[#keys + 1] = { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>" }
    --   keys[#keys + 1] = { "g\\", "<cmd>vsplit<bar>lua vim.lsp.buf.definition()<cr>" }
    --   keys[#keys + 1] = { "g-", "<cmd>split<bar>lua vim.lsp.buf.definition()<cr>" }
    --   keys[#keys + 1] = { "gf", "<cmd>lua vim.lsp.buf.code_action()<cr>" }
    --   keys[#keys + 1] = { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>" }
    --   keys[#keys + 1] = {
    --     "gd",
    --     function()
    --       require("telescope.builtin").lsp_definitions()
    --     end,
    --     desc = "Goto Definition",
    --     has = "definition",
    --   }
    --   vim.api.nvim_create_user_command("Format", "lua vim.lsp.buf.format()", { nargs = 0 })
    -- end,

    -- Fix clangd offset encoding
    -- opts = {
    --   setup = {
    --     clangd = function(_, opts)
    --       opts.capabilities.textDocument.completion.completionItem.snippetSupport = false
    --       opts.capabilities.offsetEncoding = { "utf-16" }
    --     end,
    --   },
    --   inlay_hints = { enabled = false },
    -- },

    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>" }
      keys[#keys + 1] = { "g\\", "<cmd>vsplit<bar>lua vim.lsp.buf.definition()<cr>" }
      keys[#keys + 1] = { "g-", "<cmd>split<bar>lua vim.lsp.buf.definition()<cr>" }
      keys[#keys + 1] = { "gf", "<cmd>lua vim.lsp.buf.code_action()<cr>" }
      keys[#keys + 1] = { "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>" }
      -- keys[#keys + 1] = {
      --   "gd",
      --   function()
      --     require("fzf-lua").lsp_definitions()
      --   end,
      --   desc = "Goto Definition",
      --   has = "definition",
      -- }

      vim.api.nvim_create_user_command("Format", "lua vim.lsp.buf.format()", { nargs = 0 })
      return vim.tbl_deep_extend("force", opts, {
        -- Move setup configuration here
        setup = {
          clangd = function(_, clangd_opts)
            clangd_opts.capabilities.textDocument.completion.completionItem.snippetSupport = false
            clangd_opts.capabilities.offsetEncoding = { "utf-16" }
          end,
        },
        inlay_hints = { enabled = false },
      })
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     if LazyVim.pick.want() ~= "telescope" then
  --       return
  --     end
  --     local Keys = require("lazyvim.plugins.lsp.keymaps").get()
  --     -- stylua: ignore
  --     vim.list_extend(Keys, {
  --       { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
  --       { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
  --       { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
  --       { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
  --     })
  --   end,
  -- },
}
