local map = vim.keymap.set

-- Convenience (originally in lua/mappings.lua)
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- LSP
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- DAP: execution control
-- Lazy function wrappers mean nvim-dap loads on first key press, not at startup.
map("n", "<F5>",  function() require("dap").continue() end,   { desc = "DAP Continue" })
map("n", "<F10>", function() require("dap").step_over() end,  { desc = "DAP Step Over" })
map("n", "<F11>", function() require("dap").step_into() end,  { desc = "DAP Step Into" })
map("n", "<F12>", function() require("dap").step_out() end,   { desc = "DAP Step Out" })

-- DAP: breakpoints
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint" })

map("n", "<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "DAP Conditional Breakpoint" })

map("n", "<leader>dl", function()
  require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
end, { desc = "DAP Log Point" })

-- DAP: UI and REPL
map("n", "<leader>du", function() require("dapui").toggle() end,  { desc = "DAP Toggle UI" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "DAP REPL" })
map("n", "<leader>dR", function() require("dap").run_last() end,  { desc = "DAP Run Last" })
map("n", "<leader>dx", function() require("dap").terminate() end, { desc = "DAP Terminate" })

-- Telescope: LSP navigation (complements NvChad's ff/fw/fb/fh defaults)
map("n", "<leader>lr", "<cmd>Telescope lsp_references<CR>",        { desc = "Telescope LSP references" })
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<CR>",       { desc = "Telescope LSP definitions" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>",  { desc = "Telescope LSP doc symbols" })
map("n", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Telescope LSP workspace symbols" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>",           { desc = "Telescope diagnostics" })

-- Oil: filesystem editing
map("n", "<leader>-", "<cmd>Oil<CR>", { desc = "Oil: open parent directory" })
