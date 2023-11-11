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
