return {
  {
    "EdenEast/nightfox.nvim",
  },

  {
    "folke/noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
  },

  -- { "folke/noice.nvim", enabled = false },
  -- { "rcarriga/nvim-notify", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },
  -- { "stevearc/dressing.nvim", enabled = false },
  -- { "akinsho/bufferline.nvim", enabled = false },
  -- { "MunifTanjim/nui.nvim", enabled = false },


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
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      dashboard = {
        preset = {
          -- Used by the `header` section
          header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        },
      },
    },
  },

  -- {
  --   "nvimdev/dashboard-nvim",
  --   event = "VimEnter",
  --   opts = function(_, opts)
  --     local logo = [[
  --   ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗
  --   ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║
  --   ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║
  --   ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
  --   ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║
  --   ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝
  --   ]]
  --
  --     logo = string.rep("\n", 8) .. logo .. "\n\n"
  --     opts.config.header = vim.tbl_deep_extend("force", opts.config.header, vim.split(logo, "\n"))
  --   end,
  -- },

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

  {
    'oribarilan/lensline.nvim',
    tag = '1.0.0', -- or: branch = 'release/1.x' for latest non-breaking updates
    event = 'LspAttach',
    config = function()
      require("lensline").setup()
    end,
  }
}
