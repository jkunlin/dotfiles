return {
  {
    "mfussenegger/nvim-dap",
    --   opts = function()
    --     for _, lang in ipairs({ "c", "cpp" }) do
    --       require("dap").configurations[lang] = {
    --         {
    --           type = "codelldb",
    --           request = "launch",
    --           name = "Launch file",
    --           program = function()
    --             return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    --           end,
    --           cwd = "${workspaceFolder}",
    --         },
    --         {
    --           type = "codelldb",
    --           request = "attach",
    --           name = "Attach to process",
    --           processId = require("dap.utils").pick_process,
    --           cwd = "${workspaceFolder}",
    --         },
    --       }
    --     end
    --   end,
    -- },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["codelldb"] then
        require("dap").adapters["codelldb"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "codelldb",
            args = {
              "--port",
              "${port}",
            },
          },
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            name = "stp",
            type = "cppdbg",
            request = "launch",
            program = os.getenv("HOME") .. "/smt/stp/build/stp",
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            setupCommands = {
              {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false,
              },
              {
                text = "set args /home/linjk/smt/2021_QF_BV/Sage2/bench_13275.smt2",
                description = "instance",
                ignoreFailures = false,
              },
            },
          },
          -- {
          --   type = "codelldb",
          --   request = "launch",
          --   name = "stp",
          --   program = function()
          --     return "/home/linjk/smt/stp/build/stp"
          --   end,
          --   args = { "/home/linjk/smt/2021_QF_BV/Sage2/bench_13275.smt2" },
          --   cwd = "${workspaceFolder}",
          -- },
          {
            type = "codelldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
          },
          {
            type = "codelldb",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
