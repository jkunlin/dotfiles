return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope.nvim",
    },
    keys = {
      { "<F5>", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
      { "<leader>n", "<cmd>lua require'dap'.step_over()<cr>", desc = "Continue" },
      { "<leader>s", "<cmd>lua require'dap'.step_into()<cr>", desc = "Continue" },
      { "<leader>b", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Continue" },
      { "<leader>B", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        desc = "Continue" },
      { "<leader>lp", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        desc = "Continue" },
      { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "" },
    },
    config = function()
      local dap = require('dap')
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }
      dap.configurations.cpp = {
        {
          name = "cut_stock",
          type = "cppdbg",
          request = "launch",
          program = os.getenv("HOME") .. '/cut_stock/cut_stock',

          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
            {
              text = 'set args ~/cut_stock/input/small/cut_4733647496755019778_20532.json 1 20532',
              description = 'instance',
              ignoreFailures = false
            }
          },
        },
        {
          name = "cut_stock_cut_width",
          type = "cppdbg",
          request = "launch",
          program = os.getenv("HOME") .. '/cut_stock/cut_stock',

          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
            {
              text = 'set args input/small/cut_4733647496755019778_32734.json 1 32743',
              description = 'instance',
              ignoreFailures = false
            }
          },
        },
        {
          name = "z3",
          type = "cppdbg",
          request = "launch",
          program = os.getenv("HOME") .. '/smt/z3_code/build/z3',

          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
            {
              text = 'set args /pub/data/linjk/smt/incremental/QF_BV/20170501-Heizmann-UltimateAutomizer/gcd_1_true-unreach-call_true-no-overflow.i.smt2',
              description = 'instance',
              ignoreFailures = false
            },
          },
        },
        {
          name = "bitwuzla",
          type = "cppdbg",
          request = "launch",
          program = os.getenv("HOME") .. '/smt/bitwuzla/build/bin/bitwuzla',

          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
            {
              text = 'set args /home/linjk/smt/2021_QF_BV/2017-BuchwaldFried/counterexample.dump.ia32_Mul_base_disp--Add32.load32.Mul32.Mulh_u32.0005.smt2 -v',

              description = 'instance',
              ignoreFailures = false
            },
          },
        },
        {
          name = "Launch file",
          type = "cppdbg",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
            {
              text = function()
                return 'set args ' .. vim.fn.input("args: ")
                -- return vim.fn.input("args: ", 'set args ')
              end,
              description = 'args',
              ignoreFailures = false
            },
          },
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = vim.fn.stdpath("data") .. '/dapinstall/ccppr_vsc/gdb-10.2/gdb/gdb',
          cwd = '${workspaceFolder}',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false
            },
          },
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      dap.defaults.fallback.exception_breakpoints = { 'raised', 'uncaught' }

    end
  },

  -- dap ui
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc =""},
      { "<leader>k", "<cmd>lua require'dapui'.eval()<cr>", desc = "Continue"},
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Expand lines larger than the window
      -- Requires >= 0.7
      expand_lines = vim.fn.has("nvim-0.7"),
      -- Layouts define sections of the screen to place windows.
      -- The position can be "left", "right", "top" or "bottom".
      -- The size specifies the height/width depending on position.
      -- Elements are the elements shown in the layout (in order).
      -- Layouts are opened in order so that earlier layouts take priority in window sizing.
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 10,
          position = "bottom",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = {
        max_type_length = nil, -- Can be integer or nil.
      }
    },
    config = function (_, opts)
      local dap = require('dap')
      local dapui = require("dapui")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        vim.api.nvim_command('wincmd j')
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
}
