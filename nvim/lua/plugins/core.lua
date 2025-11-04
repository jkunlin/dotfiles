return {
  -- snippets
  -- {
  --   "L3MON4D3/LuaSnip",
  --   dependencies = {
  --     "rafamadriz/friendly-snippets",
  --     config = function()
  --       require("luasnip.loaders.from_vscode").lazy_load()
  --       require("luasnip.loaders.from_snipmate").lazy_load()
  --     end,
  --   },
  --   keys = function()
  --     return {
  --       {
  --         "<c-j>",
  --         function()
  --           return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<c-j>"
  --         end,
  --         expr = true,
  --         silent = true,
  --         mode = "i",
  --       },
  --       {
  --         "<c-j>",
  --         function()
  --           require("luasnip").jump(1)
  --         end,
  --         mode = "s",
  --       },
  --       {
  --         "<c-k>",
  --         function()
  --           require("luasnip").jump(-1)
  --         end,
  --         mode = { "i", "s" },
  --       },
  --     }
  --   end,
  -- },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     opts.completion.completeopt = "menu,menuone,noselect, noinsert"
  --
  --     local cmp = require("cmp")
  --
  --     opts.mapping = vim.tbl_extend("force", opts.mapping, {
  --       ["<Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_next_item()
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --       ["<S-Tab>"] = cmp.mapping(function(fallback)
  --         if cmp.visible() then
  --           cmp.select_prev_item()
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --       ["<CR>"] = cmp.mapping({
  --         i = function(fallback)
  --           if cmp.visible() and cmp.get_selected_entry() then
  --             cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
  --           else
  --             fallback()
  --           end
  --         end,
  --         -- s = cmp.mapping.confirm({ select = true }),
  --         c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
  --         s = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
  --       }),
  --     })
  --   end,
  -- },

  {
    "saghen/blink.cmp",
    ---@class PluginLspOpts
    opts = {
      signature = { enabled = true },
      completion = { list = { selection = { preselect = false, auto_insert = true } } },
      keymap = {
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-k>"] = {
          "snippet_forward",
          -- function() -- sidekick next edit suggestion
          --   return require("sidekick").nes_jump_or_apply()
          -- end,
          "fallback"
        },
        ["<C-j>"] = { "snippet_backward", "fallback" },
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader>:",
        function()
          require("fzf-lua").commands()
        end,
        desc = "Commands",
        mode = { "n", "v" },
      },
      {
        "<leader>;",
        function()
          require("fzf-lua").commands()
        end,
        desc = "Commands",
        mode = { "n", "v" },
      },
      {
        "<leader>`",
        function()
          require("fzf-lua").marks()
        end,
        desc = "Commands",
        mode = { "n", "v" },
      },
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
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git vertical diff split" },
    },
  },
  { "kshenoy/vim-signature" },

  -- windows.nvim
  {
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    keys = {
      { "<c-w>z",    "<Cmd>WindowsMaximize<CR>",        desc = "Maximum windows" },
      { "<leader>z", "<Cmd>WindowsMaximize<CR>",        desc = "Maximum windows" },
      { "<c-w>a",    "<Cmd>WindowsToggleAutowidth<CR>", desc = "Toggle windows autowidth" },
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
    "nvimtools/hydra.nvim",
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
        { "h",     "<C-w>3<" },
        { "l",     "<C-w>3>" },
        { "k",     "<C-w>2+" },
        { "j",     "<C-w>2-" },

        -- equalize window sizes
        { "=",     "<C-w>=" },

        -- exit this Hydra
        { "q",     nil,      { exit = true, nowait = true } },
        { "<Esc>", nil,      { exit = true, nowait = true } },
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
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>",  mode = "n", desc = "Tmux Navigate Left" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>",  mode = "n", desc = "Tmux Navigate Down" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>",    mode = "n", desc = "Tmux Navigate Up" },
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
      { "<leader>tw", "<Plug>TranslateW",  desc = "Translate word" },
      { "<leader>tw", "<Plug>TranslateWV", mode = "v",             desc = "Translate word" },
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
    "nvim-mini/mini.surround",
    opts = {
      mappings = {
        add = "ys",     -- Add surrounding in Normal and Visual modes
        delete = "ds",  -- Delete surrounding
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

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
          print("Add harpoon")
        end,
        desc = "Add harpoon mark",
      },
      {
        "<leader>hm",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon toogle quick menu",
      },
      {
        "<leader>hj",
        nil,
        { desc = "Open harpoon window" },
      },
      {
        "<leader>fh",
        nil,
        { desc = "Open harpoon window" },
      },
    },
    config = function()
      -- 确保已经安装了必要的插件
      local harpoon = require("harpoon")
      local fzf_lua = require("fzf-lua")

      -- 创建一个函数来使用fzf-lua显示harpoon标记的文件
      local function toggle_fzf_harpoon()
        -- 获取harpoon列表中的所有项目
        local harpoon_files = harpoon:list()
        local file_paths = {}

        -- 提取文件路径
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        -- 如果没有标记的文件，显示提示信息
        if #file_paths == 0 then
          vim.notify("No files in Harpoon list", vim.log.levels.INFO)
          return
        end

        -- 使用fzf-lua显示文件列表
        fzf_lua.fzf_exec(file_paths, {
          prompt = "Harpoon Files❯ ",
          actions = {
            -- 回车时打开选中的文件
            ["default"] = function(selected)
              vim.cmd("edit " .. selected[1])
            end,
          },
          -- 自定义fzf选项
          fzf_opts = {
            -- 在顶部显示预览窗口
            ["--preview-window"] = "up:60%",
            ["--layout"] = "reverse",
          },
          -- 启用文件预览
          previewer = "builtin",
          -- 自定义提示信息
          prompt_title = "Harpoon Files",
        })
      end

      -- 设置快捷键
      vim.keymap.set("n", "<leader>hj", toggle_fzf_harpoon, {
        desc = "Open Harpoon files with FZF",
        silent = true,
      })
      vim.keymap.set("n", "<leader>fh", toggle_fzf_harpoon, {
        desc = "Open Harpoon files with FZF",
        silent = true,
      })
    end,
  },

  {
    "mechatroner/rainbow_csv",
  },

  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      scroll = { enabled = false },
    },
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
      vim.keymap.set("i", "<C-Bslash>", "copilot#Accept()", {
        expr = true,
        replace_keycodes = false,
        desc = "Copilot Accept",
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   cmd = {
  --     "CopilotChat",
  --     "CopilotChatExplain",
  --     "CopilotChatReview",
  --     "CopilotChatFix",
  --     "CopilotChatOptimize",
  --     "CopilotChatDocs",
  --     "CopilotChatTests",
  --     "CopilotChatFixDiagnostic",
  --     "CopilotChatCommit",
  --     "CopilotChatCommitStaged",
  --   },
  --   -- opts = {
  --   --   mappings = {
  --   --     submit_prompt = { normal = "<CR>", insert = "<C-CR>" },
  --   --   },
  --   --   system_prompt = require("CopilotChat.prompts").COPILOT_INSTRUCTIONS .. "\nReply in Chinese.",
  --   -- },
  --   opts = function(_, opts)
  --     opts.mappings =
  --       vim.tbl_extend("force", opts.mappings or {}, { submit_prompt = { normal = "<CR>", insert = "<C-CR>" } })
  --
  --     local copilot_instructions = require("CopilotChat.prompts").COPILOT_INSTRUCTIONS
  --     local sentences = {}
  --
  --     -- Split copilot_instructions into sentences
  --     for sentence in copilot_instructions:gmatch("([^%.]+)") do
  --       table.insert(sentences, sentence)
  --     end
  --
  --     -- Insert "Reply in Chinese" into the second last sentence
  --     sentences[#sentences - 1] = sentences[#sentences - 1] .. "\nYou shuold response in Chinese"
  --
  --     -- Join the sentences back together
  --     local new_copilot_instructions = table.concat(sentences, ".")
  --
  --     opts.system_prompt = new_copilot_instructions
  --   end,
  --   keys = {
  --     {
  --       "<leader>ac",
  --       function()
  --         return require("CopilotChat").toggle()
  --       end,
  --       desc = "Toggle (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>aa",
  --       false,
  --       mode = { "n", "v" },
  --     },
  --   },
  -- },

  -- {
  --   "yetone/avante.nvim",
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   -- ⚠️ must add this setting! ! !
  --   build = function()
  --     -- conditionally use the correct build system for the current OS
  --     if vim.fn.has("win32") == 1 then
  --       return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --     else
  --       return "make BUILD_FROM_SOURCE=true"
  --     end
  --   end,
  --   event = "VeryLazy",
  --   lazy = false,
  --   version = false, -- Never set this value to "*"! Never!
  --   ---@module 'avante'
  --   ---@type avante.Config
  --   opts = {
  --     behaviour = {
  --       enable_fastapply = true, -- Enable Fast Apply feature
  --     },
  --     highlights = {
  --       diff = {
  --         incoming = "DiffAdd",   -- need have background color
  --         current = "DiffChange", -- need have background color
  --       },
  --     },
  --
  --     -- add any opts here
  --     -- for example
  --     provider = "moonshot",
  --     providers = {
  --       copilot = {
  --         model = "claude-3.5-sonnet"
  --       },
  --       claude = {
  --         endpoint = "https://api.anthropic.com",
  --         model = "claude-sonnet-4-20250514",
  --         timeout = 30000, -- Timeout in milliseconds
  --         extra_request_body = {
  --           temperature = 0.75,
  --           max_tokens = 20480,
  --         },
  --       },
  --       moonshot = {
  --         -- endpoint = "https://api.moonshot.ai/v1",
  --         endpoint = "https://api.moonshot.cn/v1",
  --         model = "kimi-k2-turbo-preview",
  --         timeout = 30000, -- Timeout in milliseconds
  --         extra_request_body = {
  --           temperature = 0.75,
  --           max_tokens = 32768,
  --         },
  --       },
  --     },
  --   },
  --
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     "nvim-mini/mini.pick",         -- for file_selector provider mini.pick
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
  --     "ibhagwan/fzf-lua",              -- for file_selector provider fzf
  --     "stevearc/dressing.nvim",        -- for input provider dressing
  --     "folke/snacks.nvim",             -- for input provider snacks
  --     "nvim-tree/nvim-web-devicons",   -- or nvim-mini/mini.icons
  --     "zbirenbaum/copilot.lua",        -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- },
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<C-k>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<C-k>" -- fallback to normal key
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").send({ selection = true }) end,
        mode = { "v" },
        desc = "Sidekick Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "v" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ prompt = "file", submit = false }) end,
        mode = { "n", "v" },
        desc = "Sidekick Select Prompt",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        mode = { "n", "x", "i", "t" },
        desc = "Sidekick Switch Focus",
      },
      -- Example of a keybinding to open Claude directly
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
        desc = "Sidekick Codex Toggle",
        mode = { "n", "v" },
      },
    },
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
  --     vim.keymap.set("i", "<M-Bslash>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     -- vim.keymap.set('i', '<M-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
  --   end,
  -- },

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
    },
    opts = {
      keywords = {
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "CHECK" } },
      },
      highlight = {
        pattern = {
          -- NOTE(xyz):
          [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
          -- TODO 123:
          [[.*<((KEYWORDS)%(\s+\d+)?):]],
        },
      },
    },
  },
}
