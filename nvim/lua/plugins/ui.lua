return {
  {
    "EdenEast/nightfox.nvim",
  },

  -- { "folke/noice.nvim", enabled = false },
  -- { "rcarriga/nvim-notify", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },
  -- { "akinsho/bufferline.nvim", enabled = false },
  -- { "MunifTanjim/nui.nvim", enabled = false },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dayfox",
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- search index
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
      table.insert(opts.sections.lualine_b, {
        function()
          return search_stat()
        end,
        cond = function()
          return search_stat() ~= nil
        end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function()
      local logo = [[
\ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
\ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
\ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
\ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
\ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
\ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          -- stylua: ignore
          center = {
            { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
            { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
            { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
            { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
            { action = [[lua require("lazyvim.util").telescope.config_files()()]], desc = " Config", icon = " ", key = "c" },
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
            { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
            { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
            { action = "qa", desc = " Quit", icon = " ", key = "q" },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardLoaded",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      return opts
    end,
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
      },
    },
    config = function(_, opts)
      require("incline").setup(opts)
    end,
  },

  -- vim-smoothie
  {
    "psliwka/vim-smoothie",
    event = "BufReadPost",
  },
}
