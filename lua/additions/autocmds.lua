local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Per-language indentation overrides.
-- Global defaults (4 spaces, expanded) are set in additions/options.lua.
local indent = augroup("AdditionsIndent", { clear = true })

autocmd("FileType", {
  group = indent,
  pattern = { "java", "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- C convention: 2-space tabs. clang-format will handle the final output style.
autocmd("FileType", {
  group = indent,
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = false
  end,
})

autocmd("FileType", {
  group = indent,
  pattern = { "javascript", "typescript", "json", "html", "css" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Java: buffer-local keymaps for nvim-java commands and jdtls refactoring extensions.
-- Scoped to FileType java so they never pollute other buffers.
autocmd("FileType", {
  group = augroup("AdditionsJavaMaps", { clear = true }),
  pattern = "java",
  callback = function()
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
    end

    -- nvim-java project commands
    map("n", "<leader>jb", "<cmd>JavaBuildBuildWorkspace<CR>",  "Java: Build workspace")
    map("n", "<leader>jc", "<cmd>JavaBuildCleanWorkspace<CR>",  "Java: Clean workspace")
    map("n", "<leader>jr", "<cmd>JavaRunnerRunMain<CR>",        "Java: Run main")
    map("n", "<leader>jt", "<cmd>JavaTestRunCurrentMethod<CR>", "Java: Test method")
    map("n", "<leader>jT", "<cmd>JavaTestRunCurrentClass<CR>",  "Java: Test class")
    map("n", "<leader>jd", "<cmd>JavaDapConfig<CR>",            "Java: DAP config")

    -- jdtls refactoring extensions (still accessible through nvim-java's jdtls layer)
    map("n", "<leader>ji", function() require("jdtls").organize_imports() end,       "Java: Organize imports")
    map("v", "<leader>jv", function() require("jdtls").extract_variable() end,       "Java: Extract variable")
    map("v", "<leader>jm", function() require("jdtls").extract_method(true) end,     "Java: Extract method")
  end,
})

-- Flash the yanked region briefly so the yank boundary is visible.
autocmd("TextYankPost", {
  group = augroup("AdditionsYankHL", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
