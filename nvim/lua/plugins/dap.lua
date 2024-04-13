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
            -- coreDumpPath = function()
            --   return vim.fn.input("Path to coredump: ", "/var/lib/apport/coredump/", "file")
            -- end,
            coreDumpPath = function()
              local directory = "/var/lib/apport/coredump/"
              local scan_command = "ls -t " .. directory .. " | head -n1"
              local handle = io.popen(scan_command)
              local result = handle:read("*a")
              handle:close()
              local newest_file = result:gsub("\n$", "") -- 去除结果字符串末尾的换行符
              return directory .. "/" .. newest_file
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = true,
            -- setupCommands = {
            --   {
            --     text = "-enable-pretty-printing",
            --     description = "enable pretty printing",
            --     ignoreFailures = false,
            --   },
          },
          {
            name = "stp-tmp",
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
                text = "set args /home/linjk/smt/stp/build/test.smt2",
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

      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }

      dap.configurations.python = {
        {
          name = "Launch file",
          type = "python",
          request = "launch",
          program = "${file}", -- current file
          -- If true, the console opens at the start of the session; otherwise, it's closed.
          console = "integratedTerminal",
          args = {
            "--file",
            "/pub/netdisk1/linjk/smt/bv/benchmarks/QF_BV-42472/spear/samba_v3.0.24/bin_libsmbsharemodes_vc5774.smt2",
            "--output-dir",
            "/home/linjk/smt/BVPartition/results/raw-QF_BV-42472/debug/temp",
            "--partitioner",
            "/home/linjk/smt/BVPartition/src/partitioner/build/stp",
            "--solver",
            "/home/linjk/smt/stp-cadical/build/stp",
            "--max-running-tasks",
            "1",
            "--time-limit",
            "200",
          },
        },
      }
    end,
  },
}
