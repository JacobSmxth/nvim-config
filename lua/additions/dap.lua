local M = {}

-- Called when nvim-dap loads (lazy; triggered by a DAP keymap or explicit require).
-- Registers adapters and launch configurations for each supported language.
--
-- Java DAP is handled automatically by nvim-java/nvim-java-dap — do not add it here.
function M.setup()
  local dap = require "dap"

  -- C / C++ — codelldb adapter.
  -- codelldb is installed by mason-nvim-dap (ensure_installed in plugins/additions.lua).
  -- The executable path matches Mason's standard install location.
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.c = {
    {
      name = "Launch executable (codelldb)",
      type = "codelldb",
      request = "launch",
      -- Prompts for the compiled binary path each session.
      program = function()
        return vim.fn.input("Executable path: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      terminal = "integrated",
    },
    {
      name = "Attach to process (codelldb)",
      type = "codelldb",
      request = "attach",
      pid = function()
        return require("dap.utils").pick_process()
      end,
      cwd = "${workspaceFolder}",
    },
  }

  -- C++ reuses C configs; add cpp-specific entries below if needed.
  dap.configurations.cpp = dap.configurations.c
end

-- Called when nvim-dap-ui loads.
-- nvim-dap is guaranteed to have loaded first via the `dependencies` declaration
-- in plugins/additions.lua, so require("dap") here returns the configured module.
function M.setup_ui()
  local dap = require "dap"
  local dapui = require "dapui"

  dapui.setup()

  -- Automatically open the UI when a session initializes and close it when it ends.
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

return M
