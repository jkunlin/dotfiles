return {
  -- lsp
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim",
      "joechrisellis/lsp-format-modifications.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = false,
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {},
        sumneko_lua = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },

    config = function(plugin, opts)
      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local custom_lsp_attach = function(client, bufnr)
        if client.server_capabilities.documentHighlightProvider then
          vim.cmd([[
          augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd! CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd! CursorMoved <buffer> lua vim.lsp.buf.clear_references()
          augroup END
          ]])
        end

        -- set formatexpr and tagfunc to keep using Vim default mappings for formatting and jumping to a tag
        if client.server_capabilities.definitionProvider then
          vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
        end

        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
          -- Add this <leader> bound mapping so formatting the entire document is easier.
          vim.api.nvim_set_keymap(
            "n",
            "<leader>gq",
            ":lua vim.lsp.buf.format({async = true})<CR>",
            { noremap = true, silent = true }
          )

          local lsp_format_modifications = require("lsp-format-modifications")
          lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
        end
      end

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        server_opts.on_attach = custom_lsp_attach
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- TODO replace it with cmp's border
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        -- Use a sharp border with `FloatBorder` highlights
        border = "single",
      })

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
      require("lsp_signature").setup() -- TODO  replace with vim.lsp.buf.lsp_signature_help

      -- keymaps
      vim.keymap.set({ "n" }, "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
      vim.keymap.set({ "n" }, "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
      vim.keymap.set({ "n" }, "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
      vim.keymap.set({ "n" }, "g\\", "<cmd>vsplit<bar>lua vim.lsp.buf.definition()<cr>")
      vim.keymap.set({ "n" }, "g-", "<cmd>split<bar>lua vim.lsp.buf.definition()<cr>")
      vim.keymap.set({ "n" }, "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
      vim.keymap.set({ "n" }, "gf", "<cmd>lua vim.lsp.buf.code_action()<cr>")
      vim.keymap.set({ "n" }, "[e", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
      vim.keymap.set({ "n" }, "]e", "<cmd>lua vim.diagnostic.goto_next()<cr>")
      vim.keymap.set({ "n" }, "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>")
      vim.api.nvim_create_user_command("Format", "lua vim.lsp.buf.format()", { nargs = 0 })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          -- nls.builtins.formatting.prettierd,
          nls.builtins.formatting.stylua,
          nls.builtins.diagnostics.flake8,
        },
      }
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(plugin, opts)
      if plugin.ensure_installed then
        require("lazyvim.util").deprecate("treesitter.ensure_installed", "treesitter.opts.ensure_installed")
      end
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },
}
