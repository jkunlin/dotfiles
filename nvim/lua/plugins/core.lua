-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- colorscheme
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[
        colorscheme dayfox
        hi MatchParen ctermbg=lightblue guibg=lightgreen cterm=italic gui=italic
      ]])
    end,
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<c-j>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<c-j>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<c-j>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<c-k>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
      local cmp = require("cmp")
      return {
        completion = {
          -- completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
          end),

          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "cmdline" },
        }),
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")

      cmp.setup(opts)

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },

  -- symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "gt", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- comment
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      require("Comment").setup()
    end,
  },

  -- file explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = {
      { "ge", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },

    keys = {
      { "<leader>f", nil, desc = "files" },
      { "<leader>F", nil, desc = "git_files or find_files" },
      { "<leader><leader>", nil, desc = "Commands" },
      { "<leader>j", nil, desc = "jumplist" },
      { "<leader>rg", nil, desc = "livegrep" },
      { "<leader>`", nil, desc = "marks" },
      { "<leader>rW", nil, desc = "Grep string under cursor (root)" },
      { "<leader>rw", nil, desc = "grep string under cursor (buffer)" },
    },
    opts = {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          -- height = vim.o.lines, -- maximally available lines
          -- width = vim.o.columns, -- maximally available columns
          -- mirror = true,
          preview_cutoff = 30,
          vertical = {
            preview_height = 0.5, -- 50% of available lines
          },
        },
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
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("dap")
      require("telescope").load_extension("noice")
      local builtin = require("telescope.builtin")
      vim.keymap.set({ "n" }, "<leader><leader>", builtin.commands)
      vim.keymap.set({ "n" }, "<leader>j", builtin.jumplist)
      vim.keymap.set({ "n" }, "<leader>rg", builtin.live_grep)
      vim.keymap.set({ "n" }, "<leader>`", builtin.marks)
      vim.keymap.set({ "n" }, "<leader>rw", function()
        builtin.grep_string({ search_dirs = { vim.fn.expand("%:p") } })
      end)
      vim.keymap.set({ "n" }, "<leader>rW", builtin.grep_string)
      -- Falling back to find_files if git_files can't find a .git directory
      local project_files = function()
        local in_git_repo = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1] == "true"
        if in_git_repo then
          require("telescope.builtin").git_files()
        else
          require("telescope.builtin").find_files()
        end
      end

      vim.keymap.set({ "n" }, "<leader>f", project_files, { noremap = true, silent = true })
      vim.keymap.set({ "n" }, "<leader>F", builtin.find_files)
      -- vim.keymap.set({'n'}, '<leader>f', builtin.git_files)
    end,
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/leap.nvim",
    event = "BufReadPost",
    dependencies = { { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings()
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>sn"] = { name = "+noice" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },

  -- vim-gitgutter
  {
    "airblade/vim-gitgutter",
    event = "BufReadPre",
  },

  -- fugitive
  {
    "tpope/vim-fugitive",
    cmd = "Git",
  },

  -- vim-signature
  {
    "kshenoy/vim-signature",
    event = "VeryLazy",
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },

    -- nvim-ufo
    {
      "kevinhwang91/nvim-ufo",
      event = "BufReadPost",
      dependencies = {
        "kevinhwang91/promise-async",
      },
      config = function()
        vim.o.foldcolumn = "0"
        vim.o.foldlevel = 99 -- feel free to decrease the value
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        }
        local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
        for _, ls in ipairs(language_servers) do
          require("lspconfig")[ls].setup({
            capabilities = capabilities,
            -- you can add other fields for setting up lsp server in this table
          })
        end

        local handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ("  %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end

        -- global handler
        require("ufo").setup({
          fold_virt_text_handler = handler,
        })
      end,
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
  },

  -- linediff
  {
    "AndrewRadev/linediff.vim",
    cmd = { "Linediff" },
  },

  -- vim-table-mode
  {
    "dhruvasagar/vim-table-mode",
    cmd = "TableModeToggle",
  },

  -- vim-matchup
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
  },

  -- tmux
  {
    "wellle/tmux-complete.vim",
    event = "InsertEnter",
  },

  {
    "christoomey/vim-tmux-navigator",
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft", mode = "n", desc = "Tmux Navigate Left" },
      { "<c-j>", "<cmd>TmuxNavigateDown", mode = "n", desc = "Tmux Navigate Down" },
      { "<c-k>", "<cmd>TmuxNavigateUp", mode = "n", desc = "Tmux Navigate Up" },
      { "<c-l>", "<cmd>TmuxNavigateRight", mode = "n", desc = "Tmux Navigate Right" },
    },
    config = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
  },

  -- undo tree
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    build = "mkdir ~/.undodir",
    keys = {
      { "U", "<cmd>UndotreeToggle<cr>", desc = "Undotree Toggle" },
    },
    config = function()
      vim.g.undotree_WindowLayout = 2
      if vim.fn.has("persistent_undo") == 1 then
        vim.opt.undodir = "~/.undodir/"
        vim.opt.undofile = true
      end
    end,
  },

  -- vim-obsession
  {
    "tpope/vim-obsession",
  },

  -- vim-surround
  {
    "tpope/vim-surround",
    event = "BufReadPost",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "plaintex",
          "tex",
        },
        callback = function()
          vim.cmd([[let b:surround_{char2nr('b')} = "\\textbf{\r}"]])
          vim.cmd([[let b:surround_{char2nr('i')} = "\\textit{\r}"]])
          vim.cmd([[let b:surround_{char2nr('$')} = "$\r$"]])
          vim.cmd([[let g:surround_{char2nr('c')} = "\\\1command\1{\r}"]])
        end,
      })
    end,
  },

  -- delitMate
  {
    "Raimondi/delimitMate",
    event = "BufReadPost",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "plaintex",
          "tex",
        },
        callback = function()
          vim.cmd([[let b:delimitMate_quotes = "\" ' $"]])
        end,
      })
      vim.delimitMate_expand_space = 1
      vim.delimitMate_expand_cr = 1
      vim.delimitMate_jump_expansion = 1
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

  -- tex-conceal.vim
  {
    "KeitaNakamura/tex-conceal.vim",
    ft = "tex",
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

  -- toggleterm.nvim
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {"<c-\\>", nil, desc = ""},
    },
    opts = {
      direction = 'float',
      open_mapping = [[<c-\>]],
    },
    config = function (_, opts)
      require("toggleterm").setup(opts)
    end
  },
}