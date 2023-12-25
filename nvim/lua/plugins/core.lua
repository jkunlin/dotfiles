return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_snipmate").lazy_load()
      end,
    },
    keys = function()
      return {
        {
          "<c-j>",
          function()
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<c-j>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<c-j>",
          function()
            require("luasnip").jump(1)
          end,
          mode = "s",
        },
        {
          "<c-k>",
          function()
            require("luasnip").jump(-1)
          end,
          mode = { "i", "s" },
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts.completion.completeopt = "menu,menuone,noselect, noinsert"

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          n = {
            ["q"] = "close",
          },
          i = {
            ["<esc>"] = "close",
          },
        },
      },
      pickers = {
        find_files = {
          mappings = {
            n = {
              ["cd"] = function(prompt_bufnr)
                local selection = require("telescope.actions.state").get_selected_entry()
                local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                require("telescope.actions").close(prompt_bufnr)
                -- Depending on what you want put `cd`, `lcd`, `tcd`
                vim.cmd(string.format("silent lcd %s", dir))
              end,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>;", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>j", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>`", "<cmd>Telescope marks<cr>", desc = "Marks" },
      {
        "<leader>rw",
        function()
          require("telescope.builtin").grep_string({ search_dirs = { vim.fn.expand("%:p") } })
        end,
        desc = "grep current word",
      },
      { "<leader>rW", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        -- options used when flash is activated through
        -- a regular search with `/` or `?`
        search = {
          -- when `true`, flash will be activated during regular search by default.
          -- You can always toggle when searching with `require("flash").toggle()`
          enabled = false,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- git
  -- { "lewis6991/gitsigns.nvim", enabled = false },
  -- { "airblade/vim-gitgutter" },
  { "tpope/vim-fugitive" },
  { "kshenoy/vim-signature" },

  {
    "folke/todo-comments.nvim",
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    },
  },

  -- windows.nvim
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    keys = {
      { "<c-w>z", "<Cmd>WindowsMaximize<CR>", desc = "Maximum windows" },
      { "<leader>z", "<Cmd>WindowsMaximize<CR>", desc = "Maximum windows" },
      { "<c-w>a", "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle windows autowidth" },
    },
    opts = {
      autowidth = { enable = false },
    },
    config = function(_, opts)
      require("windows").setup(opts)
    end,
  },

  -- hydra
  {
    "anuvyklack/hydra.nvim",
    event = "BufReadPost",
    opts = {
      name = "Resize Windows",
      mode = { "n" },
      body = "<C-w>",
      config = {
        -- color = "pink",
      },
      heads = {
        -- resizing window
        { "h", "<C-w>3<" },
        { "l", "<C-w>3>" },
        { "k", "<C-w>2+" },
        { "j", "<C-w>2-" },

        -- equalize window sizes
        { "=", "<C-w>=" },

        -- exit this Hydra
        { "q", nil, { exit = true, nowait = true } },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    },
    config = function(_, opts)
      require("hydra")(opts)
    end,
  },

  -- bqf
  {
    "kevinhwang91/nvim-bqf",
    event = "BufReadPost",
    opts = {
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end,
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        tabc = "",
        ptogglemode = "z,",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    },
    config = function(_, opts)
      vim.cmd([[
        hi BqfPreviewBorder guifg=#50a14f ctermfg=71
        hi link BqfPreviewRange Search
      ]])
      require("bqf").setup(opts)
    end,
  },

  -- diffview
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
    },
    opts = { git_cmd = { vim.loop.os_homedir() .. "/dotfiles/git" } },
    config = true,
  },

  -- linediff
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
  },

  -- tmux
  {
    "wellle/tmux-complete.vim",
    event = "InsertEnter",
  },

  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", mode = "n", desc = "Tmux Navigate Left" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", mode = "n", desc = "Tmux Navigate Down" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", mode = "n", desc = "Tmux Navigate Up" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", mode = "n", desc = "Tmux Navigate Right" },
    },
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "U", "<cmd>UndotreeToggle<cr>", desc = "Undotree Toggle" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2
      if vim.fn.has("persistent_undo") == 1 then
        local undodir = vim.loop.os_homedir() .. "/.undodir"
        if not vim.fn.isdirectory(undodir) then
          vim.fn.mkdir(undodir, "p")
        end
        vim.opt.undodir = undodir
        vim.opt.undofile = true
      end
    end,
  },

  -- rsi.vim
  {
    "tpope/vim-rsi",
    event = "BufReadPost",
  },

  -- 'voldikss/vim-translator'
  {
    "voldikss/vim-translator",
    keys = {
      { "<leader>tw", "<Plug>TranslateW", desc = "Translate word" },
      { "<leader>tw", "<Plug>TranslateWV", mode = "v", desc = "Translate word" },
    },
  },

  -- vim-lexical
  {
    "reedes/vim-lexical",
    event = "BufReadPost",
    config = function()
      vim.cmd([[let g:lexical#spell_key = 'z=']])
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "plaintex",
          "tex",
          "text",
          "markdown",
        },
        callback = function()
          vim.cmd([[call lexical#init()]])
        end,
      })
    end,
  },

  -- vim-easy-align
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "x", "n" }, desc = "Easy Align" },
    },
    config = function()
      vim.cmd([[
        let g:easy_align_delimiters = {
          \  't': { 'pattern': '\t',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 }
          \}
      ]])
    end,
  },

  -- fzf
  {
    "junegunn/fzf",
    cmd = "FZF",
    build = "./install --all",
    dependencies = { "junegunn/fzf.vim" },
  },

  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        replace = "cs", -- Replace surrounding
      },
    },
  },

  -- delete keymap for <leader>w and <leader>q
  {
    "folke/which-key.nvim",

    opts = function(_, opts)
      opts.defaults["<leader>w"] = nil
      opts.defaults["<leader>q"] = nil
    end,
  },

  {
    "folke/persistence.nvim",
    keys = function()
      return {}
    end,
  },

  -- toggleterm.nvim
  -- {
  --   "akinsho/toggleterm.nvim",
  --   keys = {
  --     { "<c-\\>", nil, desc = "" },
  --   },
  --   opts = {
  --     direction = "float",
  --     open_mapping = [[<c-\>]],
  --   },
  --   config = function(_, opts)
  --     require("toggleterm").setup(opts)
  --   end,
  -- },

  -- copliot
  {
    "github/copilot.vim",
    config = function()
      vim.keymap.set("i", "<M-\\>", "copilot#Accept()", {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot Accept",
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
  -- codeium
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "BufEnter",
  --   config = function()
  --     vim.g.codeium_disable_bindings = 1
  --     -- Change '<C-g>' here to any keycode you like.
  --     -- vim.keymap.set('i', '<M-p>', function() return vim.fn['codeium#Complete']() end, { noremap = true, expr = true })
  --     vim.keymap.set("i", "<M-[>", function()
  --       return vim.fn["codeium#CycleCompletions"](1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<M-]>", function()
  --       return vim.fn["codeium#CycleCompletions"](-1)
  --     end, { expr = true })
  --     vim.keymap.set("i", "<M-\\>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     -- vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  --   end,
  -- },
}
