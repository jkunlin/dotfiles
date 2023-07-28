local Util = require("util")

return {

  -- Better `vim.notify()`
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(plugin)
      -- if plugin.override then
      --   require("lazyvim.util").deprecate("lualine.override", "lualine.opts")
      -- end

      -- local icons = require("lazyvim.config").icons

      local function fg(name)
        return function()
          ---@type {foreground?:number}?
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
        end
      end

      local function search_stat()
        if vim.v.hlsearch == 1 then
          local sinfo = vim.fn.searchcount({ maxcount = 0 })
          local stat = sinfo.incomplete > 0 and "[?/?]"
          or sinfo.total > 0 and ("[%s/%s]"):format(sinfo.current, sinfo.total)
          or nil

          return stat
          -- if stat ~= nil then
          --   return stat
          -- end
        end
      end


      return {
        options = {
          theme = "auto",
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch",
            {
              function() return search_stat() end,
              cond = function() return search_stat() ~= nil end,
              color = fg("Constant"),
            },
          },
          lualine_c = {
            {
              "diagnostics",
              -- symbols = {
              --   error = icons.diagnostics.Error,
              --   warn = icons.diagnostics.Warn,
              --   info = icons.diagnostics.Info,
              --   hint = icons.diagnostics.Hint,
              -- },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
            -- stylua: ignore
            {
              function() return require("nvim-navic").get_location() end,
              cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = fg("Statement")
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = fg("Constant"),
            },
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = fg("Special") },
            {
              "diff",
              -- symbols = {
              --   added = icons.git.added,
              --   modified = icons.git.modified,
              --   removed = icons.git.removed,
              -- },
            },
          },
          lualine_y = {
            { "progress", separator = "", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "nvim-tree" },
      }
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = "BufReadPre",
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  -- startify
  {
    "mhinz/vim-startify",
    event = "VimEnter",
    config = function()
      vim.cmd[[
      let g:startify_files_number=5
      let g:startify_files_number=5
      let g:startify_list_order = [
        \ ["   MRU " . getcwd()],
        \ 'dir',
        \ ['   MRU'],
        \ 'files',
        \ ['   sessions:'],
        \ 'sessions',
        \ ]
      ]]
    end
  },

  -- dashboard
  -- {
  --   "goolord/alpha-nvim",
  --   event = "VimEnter",
  --   opts = function()
  --     local dashboard = require("alpha.themes.dashboard")
  --     local logo = [[
  --     ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
  --     ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
  --     ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
  --     ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
  --     ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
  --     ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
  --     ]]
  --
  --     dashboard.section.header.val = vim.split(logo, "\n")
  --     dashboard.section.buttons.val = {
  --       dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
  --       dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
  --       dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
  --       dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
  --       dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
  --       dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
  --       dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
  --       dashboard.button("q", " " .. " Quit", ":qa<CR>"),
  --     }
  --     for _, button in ipairs(dashboard.section.buttons.val) do
  --       button.opts.hl = "AlphaButtons"
  --       button.opts.hl_shortcut = "AlphaShortcut"
  --     end
  --     dashboard.section.footer.opts.hl = "Type"
  --     dashboard.section.header.opts.hl = "AlphaHeader"
  --     dashboard.section.buttons.opts.hl = "AlphaButtons"
  --     dashboard.opts.layout[1].val = 8
  --     return dashboard
  --   end,
  --   config = function(_, dashboard)
  --     vim.b.miniindentscope_disable = true
  --
  --     -- close Lazy and re-open when the dashboard is ready
  --     if vim.o.filetype == "lazy" then
  --       vim.cmd.close()
  --       vim.api.nvim_create_autocmd("User", {
  --         pattern = "AlphaReady",
  --         callback = function()
  --           require("lazy").show()
  --         end,
  --       })
  --     end
  --
  --     require("alpha").setup(dashboard.opts)
  --
  --     vim.api.nvim_create_autocmd("User", {
  --       pattern = "LazyVimStarted",
  --       callback = function()
  --         local stats = require("lazy").stats()
  --         local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  --         dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
  --         pcall(vim.cmd.AlphaRedraw)
  --       end,
  --     })
  --   end,
  -- },

  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function()
      vim.g.navic_silence = true
      Util.on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = { separator = " ", highlight = true, depth_limit = 5 },
  },

  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim"
    },
    -- keys = {
    --   { "<leader>nv", "<cmd>Navbuddy<cr>", desc = "Nav" },
    -- },
    config = function()
      local navbuddy = require("nvim-navbuddy")
      navbuddy.setup({
        window = {
          border = "double"
        },
        lsp = { auto_attach = true }
      })

      vim.keymap.set({ "n" }, "<leader>nv", "<cmd>Navbuddy<cr>")

      -- Util.on_attach(function(client, buffer)
      --   if client.server_capabilities.documentSymbolProvider then
      --     require("nvim-navbuddy").attach(client, buffer)
      --   end
      -- end)
    end
  },

  -- incline
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        placement = {
          horizontal = "right",
          vertical = "top",
        },
        margin = {
          horizontal = 0,
          vertical = 2,
        },
      }
    },
    config = function(_, opts)
      require('incline').setup(opts)
    end
  },

  -- vim-smoothie
  {
    "psliwka/vim-smoothie",
    event = "BufReadPost",
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },
}
